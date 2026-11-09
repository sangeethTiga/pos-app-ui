import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

import '../../../core/sync/local_store.dart';
import '../../../core/sync/sync_change.dart';
import '../data/sync_api.dart';

enum SyncResult { synced, waitingForSchedule, notGateway, failed }

class SyncReport {
  const SyncReport(
    this.result, {
    this.mode,
    this.pushed = 0,
    this.pulled = 0,
    this.rejected = 0,
    this.message,
    this.rejectedCodes = const {},
  });

  final SyncResult result;
  final String? mode;
  final int pushed;
  final int pulled;
  final int rejected;
  final String? message;

  /// Codes of the transactions the server rejected in this sync (e.g. DEVICE_NOT_ACTIVATED).
  final Set<String> rejectedCodes;

  /// The server refused something because a terminal is not activated.
  bool get deviceNotActivated => rejectedCodes.contains('DEVICE_NOT_ACTIVATED') || message == 'DEVICE_NOT_ACTIVATED';

  @override
  String toString() =>
      'SyncReport($result, mode: $mode, pushed: $pushed, pulled: $pulled, rejected: $rejected, $message)';
}

/// The gateway side of cloud sync (FLUTTER_BACKEND_INTEGRATION.md §7–§17).
///
/// One [sync] call: read `/sync/config`, decide whether data may move (CONTINUOUS always; MANUAL only with a
/// run a manager authorised; SCHEDULED inside an open occurrence or a due catch-up), claim the gateway,
/// push pending transactions (acknowledged only by `accepted`), pull SERVER changes, complete the run.
class SyncEngine {
  SyncEngine(this._api, this._store);

  final SyncApi _api;
  final LocalStore _store;
  Future<SyncReport>? _running;

  static const _batchChanges = 500;

  /// Serialised: a second call while one runs gets the same result.
  Future<SyncReport> sync() => _running ??= _sync().whenComplete(() => _running = null);

  Future<int> get pullCursor async => int.parse(await _store.getValue('pull_cursor') ?? '0');

  Future<int?> get epoch async => int.tryParse(await _store.getValue('gateway_epoch') ?? '');

  Future<SyncReport> _sync() async {
    String? mode;
    String? runId;
    var pushed = 0, pulled = 0, rejected = 0;
    final rejectedCodes = <String>{};
    try {
      final config = await _api.config();
      mode = config['mode'] as String?;
      await _store.setJson('sync_config', config);

      if (mode != 'CONTINUOUS') {
        runId = await _startRun(config);
        if (runId == null) {
          // Orders wait for the schedule, but staff (new logins, PINs, suspensions) never do.
          final staff = await _refreshStaff();
          return SyncReport(SyncResult.waitingForSchedule, mode: mode, pulled: staff);
        }
      }

      final claim = await _api.claim(
        expectedEpoch: await epoch,
        pullCursor: await pullCursor,
        accepted: (await _store.getJson('acked_vector')).map((k, v) => MapEntry(k, v as int)),
      );
      if (claim['is_gateway'] != true) {
        if (runId != null) await _complete(runId, 'FAILED', error: 'Another terminal is the gateway.');
        return SyncReport(SyncResult.notGateway, mode: mode, message: 'Gateway is ${claim['gateway_device_code']}');
      }
      final ep = claim['epoch'] as int;
      await _store.setValue('gateway_epoch', '$ep');

      // ---- push -----------------------------------------------------------------------
      while (true) {
        final txs = await _store.pendingTransactions(maxChanges: _batchChanges);
        if (txs.isEmpty) break;
        final res = await _api.push({
          'batch_id': const Uuid().v7(),
          'gateway_epoch': ep,
          'schema_version': 1,
          'run_id': ?runId,
          'txs': [
            for (final tx in txs)
              {'tx_id': tx.first.txId, 'origin': tx.first.origin, 'changes': tx.map((c) => c.toPushJson()).toList()},
          ],
        });
        await _store.acknowledge(Map<String, dynamic>.from(res['accepted'] as Map));
        for (final r in (res['rejected'] as List? ?? const [])) {
          final m = Map<String, dynamic>.from(r as Map);
          final txId = (m['tx_id'] ?? m['txn_id']) as String?;
          if (txId != null) await _store.markRejected(txId, '${m['code']}');
          if (m['code'] is String) rejectedCodes.add(m['code'] as String);
          rejected++;
        }
        pushed += (res['applied'] as int? ?? 0);
        final progressed = (res['applied'] as int? ?? 0) + (res['duplicates'] as int? ?? 0) + rejected;
        if (progressed == 0) break; // deferred / gaps: try again next sync, never loop forever
      }

      // ---- pull -----------------------------------------------------------------------
      var cursor = await pullCursor;
      while (true) {
        final page = await _api.pull(cursor: cursor, runId: runId);
        final changes = (page['changes'] as List)
            .map((c) => SyncChange.fromJson(Map<String, dynamic>.from(c as Map)))
            .toList();
        await _store.applyIncoming(changes);
        cursor = page['next_cursor'] as int;
        await _store.setValue('pull_cursor', '$cursor'); // after the local commit
        pulled += changes.length;
        if (page['has_more'] != true) break;
      }

      if (runId != null) await _complete(runId, rejected > 0 ? 'PARTIAL' : 'SUCCESS');
      await _store.setValue('last_sync_at', DateTime.now().toUtc().toIso8601String());
      return SyncReport(
        SyncResult.synced,
        mode: mode,
        pushed: pushed,
        pulled: pulled,
        rejected: rejected,
        rejectedCodes: rejectedCodes,
      );
    } on DioException catch (e) {
      final data = e.response?.data;
      final code = data is Map && data['error'] is Map ? (data['error'] as Map)['code'] as String? : null;
      if (code == 'STALE_GATEWAY_EPOCH' || code == 'NOT_GATEWAY') await _store.setValue('gateway_epoch', '');
      if (runId != null) {
        try {
          await _complete(runId, 'FAILED', status: e.response?.statusCode, code: code, error: e.message);
        } on DioException {
          // the server marks silent runs ABANDONED
        }
      }
      return SyncReport(
        SyncResult.failed,
        mode: mode,
        pushed: pushed,
        pulled: pulled,
        message: code ?? e.message,
        rejectedCodes: rejectedCodes,
      );
    }
  }

  /// Applies the store's current staff profiles (LWW by HLC, so the same changes arriving later with
  /// the normal pull are no-ops). The pull cursor is not moved. A server without the endpoint is ignored.
  Future<int> _refreshStaff() async {
    try {
      final page = await _api.staff();
      final changes = (page['changes'] as List? ?? const [])
          .map((c) => SyncChange.fromJson(Map<String, dynamic>.from(c as Map)))
          .toList();
      await _store.applyIncoming(changes);
      return changes.length;
    } on DioException {
      return 0;
    }
  }

  /// Run for MANUAL / SCHEDULED mode, or null when nothing may move now.
  Future<String?> _startRun(Map<String, dynamic> config) async {
    final pending = config['pending_manual_run'];
    final plan = Map<String, dynamic>.from((config['schedule_plan'] ?? const {}) as Map);
    final Map<String, dynamic> body;
    if (pending is Map && pending['id'] != null) {
      body = {'trigger': 'USER', 'run_id': pending['id']};
    } else if (config['mode'] == 'SCHEDULED' && plan['open_occurrence'] is Map) {
      final key = (plan['open_occurrence'] as Map)['occurrence_key'] as String;
      body = {'trigger': 'SCHEDULE', 'occurrence_key': key, 'idempotency_key': _idem(key)};
    } else if (config['mode'] == 'SCHEDULED' && config['catch_up_due'] == true && plan['latest_occurrence'] is Map) {
      final key = (plan['latest_occurrence'] as Map)['occurrence_key'] as String;
      body = {'trigger': 'CATCH_UP', 'occurrence_key': key, 'idempotency_key': _idem(key)};
    } else {
      return null;
    }
    try {
      final run = await _api.startRun(body);
      return (run['data'] is Map ? run['data']['id'] : run['id']) as String?;
    } on DioException catch (e) {
      if (e.response?.statusCode == 409 || e.response?.statusCode == 422) return null; // not due / done / not allowed
      rethrow;
    }
  }

  String _idem(String occurrence) =>
      'run-${occurrence.replaceAll('@', '_')}-${DateTime.now().millisecondsSinceEpoch ~/ 60000}';

  Future<void> _complete(String runId, String state, {int? status, String? code, String? error}) =>
      _api.completeRun(runId, {
        'state': state,
        'completion_key': 'done-$runId',
        'local_pending_changes': 0,
        if (state == 'FAILED')
          'failure_kind': (status != null && status >= 400 && status < 500) ? 'PERMANENT' : 'TRANSIENT',
        'last_http_status': ?status,
        'last_error_code': ?code,
        if (error != null) 'error': error.length > 2000 ? error.substring(0, 2000) : error,
      });

  /// Keeps the gateway lease (every 10 s while this terminal is the gateway).
  Future<bool> heartbeat() async {
    final ep = await epoch;
    if (ep == null) return false;
    try {
      await _api.heartbeat(epoch: ep, pending: await _store.pendingCount(), pullCursor: await pullCursor);
      return true;
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map && data['error'] is Map && (data['error'] as Map)['code'] == 'STALE_GATEWAY_EPOCH') {
        await _store.setValue('gateway_epoch', ''); // another terminal took over: step down
      }
      return false;
    }
  }
}
