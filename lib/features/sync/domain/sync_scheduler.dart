import 'dart:async';

import '../../../core/sync/local_store.dart';
import '../data/realtime_client.dart';
import 'sync_engine.dart';

/// Decides *when* to sync: after local sales (debounced), on WebSocket notifications, every
/// [interval] as a fallback (also how scheduled occurrences are noticed), and keeps the gateway
/// lease alive with heartbeats.
class SyncScheduler {
  SyncScheduler(
    this.engine,
    this._store,
    this._realtime, {
    this.interval = const Duration(seconds: 30),
    this.debounce = const Duration(seconds: 2),
    this.heartbeatEvery = const Duration(seconds: 10),
  });

  final SyncEngine engine;
  final LocalStore _store;
  final RealtimeClient _realtime;
  final Duration interval;
  final Duration debounce;
  final Duration heartbeatEvery;

  final _reports = StreamController<SyncReport>.broadcast();
  Timer? _periodic, _heartbeat, _debounced;
  StreamSubscription<String>? _events;
  bool _started = false;

  Stream<SyncReport> get reports => _reports.stream;

  Future<void> start({required String websocketOrigin}) async {
    if (_started) return;
    _started = true;
    _periodic = Timer.periodic(interval, (_) => syncNow());
    _heartbeat = Timer.periodic(heartbeatEvery, (_) => engine.heartbeat());
    _events = _realtime.events.listen((e) {
      if (e == 'sync.change_available' || e == 'sync.run_requested' || e == 'gateway.changed') syncNow();
    });
    final report = await syncNow();
    final realtime = (await _store.getJson('sync_config'))['realtime'];
    if (realtime is Map && report.result != SyncResult.failed) {
      _realtime.start(Map<String, dynamic>.from(realtime), origin: websocketOrigin);
    }
  }

  /// Call after every local commit: uploads within [debounce] in CONTINUOUS mode.
  void localChangeCommitted() {
    _debounced?.cancel();
    _debounced = Timer(debounce, syncNow);
  }

  Future<SyncReport> syncNow() async {
    final r = await engine.sync();
    if (!_reports.isClosed) _reports.add(r);
    return r;
  }

  Future<void> stop() async {
    _started = false;
    _periodic?.cancel();
    _heartbeat?.cancel();
    _debounced?.cancel();
    await _events?.cancel();
    await _realtime.stop();
  }
}
