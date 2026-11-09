import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'sync_api.dart';

/// One event received on a private channel; [data] is the decoded payload (empty when none).
class RealtimeMessage {
  const RealtimeMessage(this.event, this.channel, this.data);

  final String event;
  final String? channel;
  final Map<String, dynamic> data;
}

/// Reverb (Pusher protocol 7) client for the store's private channels (`sync`, and `devices` when the
/// server lists it). Sync events are notifications only: data always travels through push/pull, so a
/// missed event only delays a sync.
class RealtimeClient {
  RealtimeClient(this._api, {WebSocketChannel Function(Uri uri, String origin)? connect})
    : _connect = connect ?? ((uri, origin) => IOWebSocketChannel.connect(uri, headers: {'Origin': origin}));

  final SyncApi _api;
  final WebSocketChannel Function(Uri uri, String origin) _connect;
  final _events = StreamController<String>.broadcast();
  final _messages = StreamController<RealtimeMessage>.broadcast();
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _sub;
  Timer? _reconnect;
  bool _closed = false;

  /// Event names on the subscribed channel, e.g. `sync.change_available`.
  Stream<String> get events => _events.stream;

  /// The same events with channel and payload (e.g. `device.activation`). An event the server sends on
  /// several channels arrives once per channel.
  Stream<RealtimeMessage> get messages => _messages.stream;

  bool get connected => _channel != null;

  /// [realtime] is the `realtime` block of `/sync/config`.
  void start(Map<String, dynamic> realtime, {required String origin}) {
    _closed = false;
    final key = realtime['app_key'] as String?;
    final host = realtime['host'] as String?;
    final listed = (realtime['channels'] as Map?) ?? const {};
    final sync = listed['sync'] as String?;
    if (key == null || host == null || sync == null) return;
    final channels = [sync, if (listed['devices'] case final String devices when devices != sync) devices];
    final scheme = realtime['scheme'] == 'https' ? 'wss' : 'ws';
    final uri = Uri.parse('$scheme://$host:${realtime['port']}/app/$key?protocol=7&client=pos-flutter&version=1.0');

    _sub?.cancel();
    final ws = _channel = _connect(uri, origin);
    _sub = ws.stream.listen(
      (raw) => _onMessage(ws, channels, raw as String),
      onDone: () => _scheduleReconnect(realtime, origin),
      onError: (_) => _scheduleReconnect(realtime, origin),
    );
  }

  Future<void> _onMessage(WebSocketChannel ws, List<String> channels, String raw) async {
    final msg = jsonDecode(raw) as Map<String, dynamic>;
    switch (msg['event']) {
      case 'pusher:connection_established':
        final socketId = (jsonDecode(msg['data'] as String) as Map)['socket_id'] as String;
        try {
          for (final channel in channels) {
            final auth = await _api.broadcastAuth(socketId: socketId, channel: channel);
            ws.sink.add(
              jsonEncode({
                'event': 'pusher:subscribe',
                'data': {'channel': channel, 'auth': auth},
              }),
            );
          }
        } on Object {
          await ws.sink.close();
        }
      case 'pusher:ping':
        ws.sink.add(jsonEncode({'event': 'pusher:pong', 'data': <String, dynamic>{}}));
      case final String e when !e.startsWith('pusher'):
        _events.add(e);
        _messages.add(RealtimeMessage(e, msg['channel'] as String?, _payload(msg['data'])));
    }
  }

  /// Pusher sends `data` as a JSON string.
  static Map<String, dynamic> _payload(Object? data) {
    try {
      final decoded = data is String ? jsonDecode(data) : data;
      return decoded is Map ? Map<String, dynamic>.from(decoded) : const {};
    } on Object {
      return const {};
    }
  }

  void _scheduleReconnect(Map<String, dynamic> realtime, String origin) {
    _channel = null;
    if (_closed) return;
    _reconnect?.cancel();
    _reconnect = Timer(const Duration(seconds: 5), () => start(realtime, origin: origin));
  }

  Future<void> stop() async {
    _closed = true;
    _reconnect?.cancel();
    await _sub?.cancel();
    await _channel?.sink.close();
    _channel = null;
  }
}
