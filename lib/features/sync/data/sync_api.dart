import 'package:dio/dio.dart';

/// Device-signed sync endpoints (signing is done by DeviceAuthInterceptor). Throws [DioException].
abstract interface class SyncApi {
  Future<Map<String, dynamic>> config();
  Future<Map<String, dynamic>> claim({int? expectedEpoch, int? pullCursor, Map<String, int>? accepted});
  Future<Map<String, dynamic>> heartbeat({required int epoch, required int pending, required int pullCursor});
  Future<Map<String, dynamic>> push(Map<String, dynamic> batch);
  Future<Map<String, dynamic>> pull({required int cursor, int limit = 500, String? runId});

  /// Current staff profiles of the store, in every sync mode (does not move the pull cursor).
  Future<Map<String, dynamic>> staff();
  Future<Map<String, dynamic>> startRun(Map<String, dynamic> body);
  Future<Map<String, dynamic>> completeRun(String runId, Map<String, dynamic> body);
  Future<String> broadcastAuth({required String socketId, required String channel});
}

class DioSyncApi implements SyncApi {
  const DioSyncApi(this._dio);

  final Dio _dio;

  Future<Map<String, dynamic>> _post(String path, Map<String, dynamic> body) async =>
      (await _dio.post<Map<String, dynamic>>(path, data: body)).data!;

  @override
  Future<Map<String, dynamic>> config() async => (await _dio.get<Map<String, dynamic>>('/sync/config')).data!;

  @override
  Future<Map<String, dynamic>> claim({int? expectedEpoch, int? pullCursor, Map<String, int>? accepted}) =>
      _post('/gateway/claim', {
        'expected_epoch': ?expectedEpoch,
        'pull_cursor': ?pullCursor,
        if (accepted != null && accepted.isNotEmpty) 'accepted': accepted,
      });

  @override
  Future<Map<String, dynamic>> heartbeat({required int epoch, required int pending, required int pullCursor}) =>
      _post('/gateway/heartbeat', {'epoch': epoch, 'local_pending_changes': pending, 'pull_cursor': pullCursor});

  @override
  Future<Map<String, dynamic>> push(Map<String, dynamic> batch) => _post('/sync/push', batch);

  @override
  Future<Map<String, dynamic>> pull({required int cursor, int limit = 500, String? runId}) async =>
      (await _dio.get<Map<String, dynamic>>(
        '/sync/pull',
        queryParameters: {'cursor': '$cursor', 'limit': '$limit', 'run_id': ?runId},
      )).data!;

  @override
  Future<Map<String, dynamic>> staff() async => (await _dio.get<Map<String, dynamic>>('/sync/staff')).data!;

  @override
  Future<Map<String, dynamic>> startRun(Map<String, dynamic> body) => _post('/sync/runs', body);

  @override
  Future<Map<String, dynamic>> completeRun(String runId, Map<String, dynamic> body) =>
      _post('/sync/runs/$runId/complete', body);

  @override
  Future<String> broadcastAuth({required String socketId, required String channel}) async =>
      (await _post('/broadcasting/auth', {'socket_id': socketId, 'channel_name': channel}))['auth'] as String;
}
