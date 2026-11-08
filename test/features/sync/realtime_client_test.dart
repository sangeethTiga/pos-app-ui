import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/features/sync/data/realtime_client.dart';
import 'package:pos_app_ui/features/sync/data/sync_api.dart';

class _Api implements SyncApi {
  final authCalls = <(String, String)>[];
  @override
  Future<String> broadcastAuth({required String socketId, required String channel}) async {
    authCalls.add((socketId, channel));
    return 'key:signature';
  }

  @override
  dynamic noSuchMethod(Invocation i) => throw UnimplementedError();
}

/// A local server speaking the Reverb/Pusher handshake.
void main() {
  test('connects, authorises the private channel with a signed request, emits events', () async {
    final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
    final subscribed = Completer<Map<String, dynamic>>();
    String? origin;
    String? path;
    server.listen((req) async {
      origin = req.headers.value('origin');
      path = req.uri.toString();
      final ws = await WebSocketTransformer.upgrade(req);
      ws.add(
        jsonEncode({
          'event': 'pusher:connection_established',
          'data': jsonEncode({'socket_id': '123.456', 'activity_timeout': 30}),
        }),
      );
      ws.listen((raw) {
        final m = jsonDecode(raw as String) as Map<String, dynamic>;
        if (m['event'] == 'pusher:subscribe') {
          subscribed.complete(Map<String, dynamic>.from(m['data'] as Map));
          ws.add(jsonEncode({'event': 'pusher_internal:subscription_succeeded', 'channel': 'c', 'data': '{}'}));
          ws.add(jsonEncode({'event': 'sync.change_available', 'channel': 'c', 'data': '{}'}));
        }
      });
    });

    final api = _Api();
    final client = RealtimeClient(api);
    final firstEvent = client.events.first;
    client.start({
      'app_key': 'appkey',
      'host': '127.0.0.1',
      'port': server.port,
      'scheme': 'http',
      'channels': {'sync': 'private-tenant.t1.store.s1.sync'},
    }, origin: 'http://localhost');

    final sub = await subscribed.future.timeout(const Duration(seconds: 5));
    expect(sub, {'channel': 'private-tenant.t1.store.s1.sync', 'auth': 'key:signature'});
    expect(api.authCalls.single, ('123.456', 'private-tenant.t1.store.s1.sync'));
    expect(await firstEvent.timeout(const Duration(seconds: 5)), 'sync.change_available');
    expect(origin, 'http://localhost');
    expect(path, startsWith('/app/appkey?protocol=7'));

    await client.stop();
    await server.close(force: true);
  });
}
