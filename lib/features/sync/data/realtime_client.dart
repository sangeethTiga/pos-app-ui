import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'sync_api.dart';

/// Reverb (Pusher protocol 7) client for one private channel. Events are notifications only:
/// data always travels through push/pull, so a missed event only delays a sync.
class RealtimeClient {
  RealtimeClient(this._api, {WebSocketChannel Function(Uri uri, String origin)? connect})
    : _connect = connect ?? ((uri, origin) => IOWebSocketChannel.connect(uri, headers: {'Origin': origin}));

  final SyncApi _api;
  final WebSocketChannel Function(Uri uri, String origin) _connect;
  final _events = StreamController<String>.broadcast();
  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _sub;
  Timer? _reconnect;
  bool _closed = false;

  /// Event names on the subscribed channel, e.g. `sync.change_available`.
  Stream<String> get events => _events.stream;

  bool get connected => _channel != null;

  /// [realtime] is the `realtime` block of `/sync/config`.
  void start(Map<String, dynamic> realtime, {required String origin}) {
    _closed = false;
    final key = realtime['app_key'] as String?;
    final host = realtime['host'] as String?;
    final channel = (realtime['channels'] as Map?)?['sync'] as String?;
    if (key == null || host == null || channel == null) return;
    final scheme = realtime['scheme'] == 'https' ? 'wss' : 'ws';
    final uri = Uri.parse('$scheme://$host:${realtime['port']}/app/$key?protocol=7&client=pos-flutter&version=1.0');

    _sub?.cancel();
    final ws = _channel = _connect(uri, origin);
    _sub = ws.stream.listen(
      (raw) => _onMessage(ws, channel, raw as String),
      onDone: () => _scheduleReconnect(realtime, origin),
      onError: (_) => _scheduleReconnect(realtime, origin),
    );
  }

  Future<void> _onMessage(WebSocketChannel ws, String channel, String raw) async {
    final msg = jsonDecode(raw) as Map<String, dynamic>;
    switch (msg['event']) {
      case 'pusher:connection_established':
        final socketId = (jsonDecode(msg['data'] as String) as Map)['socket_id'] as String;
        try {
          final auth = await _api.broadcastAuth(socketId: socketId, channel: channel);
          ws.sink.add(
            jsonEncode({
              'event': 'pusher:subscribe',
              'data': {'channel': channel, 'auth': auth},
            }),
          );
        } on Object {
          await ws.sink.close();
        }
      case 'pusher:ping':
        ws.sink.add(jsonEncode({'event': 'pusher:pong', 'data': <String, dynamic>{}}));
      case final String e when !e.startsWith('pusher'):
        _events.add(e);
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
