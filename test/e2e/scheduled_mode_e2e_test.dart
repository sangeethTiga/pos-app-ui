@Tags(['e2e'])
library;

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/core/config/app_config.dart';
import 'package:pos_app_ui/core/database/connection.dart';
import 'package:pos_app_ui/core/network/api_client.dart';
import 'package:pos_app_ui/core/network/device_auth_interceptor.dart';
import 'package:pos_app_ui/core/network/request_signer.dart';
import 'package:pos_app_ui/core/storage/secure_store.dart';
import 'package:pos_app_ui/core/sync/local_store.dart';
import 'package:pos_app_ui/core/utils/result.dart';
import 'package:pos_app_ui/features/device_setup/data/datasources/device_local_data_source.dart';
import 'package:pos_app_ui/features/device_setup/data/datasources/device_remote_data_source.dart';
import 'package:pos_app_ui/features/device_setup/data/repositories/device_repository_impl.dart';
import 'package:pos_app_ui/features/sync/data/sync_api.dart';
import 'package:pos_app_ui/features/sync/domain/sync_engine.dart';

/// SCHEDULED store: first sync runs as CATCH_UP (store never synced), then nothing moves outside the
/// schedule, then a manager-authorised manual run (admin panel) is picked up from /sync/config.
///
/// `E2E_BASE_URL=... E2E_ACTIVATION_CODE=(code for the scheduled store) E2E_OWNER_EMAIL=... E2E_OWNER_PASSWORD=...`
void main() {
  final env = Platform.environment;
  final base = env['E2E_BASE_URL'];

  test('scheduled mode: catch-up, wait, manual run', () async {
    final config = AppConfig(apiBaseUrl: base!, appVersion: '1.0.0');
    final local = DeviceLocalDataSource(MemorySecureStore());
    final dio = createDio(config, interceptors: [DeviceAuthInterceptor(local, RequestSigner())]);
    final devices = DeviceRepositoryImpl(DeviceRemoteDataSource(dio), local, config, platform: 'windows');
    final session = switch (await devices.setup(code: env['E2E_ACTIVATION_CODE']!, deviceName: 'E2E scheduled')) {
      Success(:final value) => value,
      Err(:final failure) => fail('$failure'),
    };
    final store = LocalStore(openTestDatabase(NativeDatabase.memory()));
    await store.open(session.deviceCode);
    final engine = SyncEngine(DioSyncApi(dio), store);

    final first = await engine.sync();
    expect(first.mode, 'SCHEDULED');
    expect(first.result, SyncResult.synced, reason: 'catch-up run: $first');

    final second = await engine.sync();
    expect(second.result, SyncResult.waitingForSchedule, reason: '$second');

    // manager authorises a manual sync from the admin panel
    final admin = Dio(BaseOptions(baseUrl: base, headers: {'Accept': 'application/json'}));
    final token = (await admin.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': env['E2E_OWNER_EMAIL'], 'password': env['E2E_OWNER_PASSWORD']},
    )).data!['access_token'];
    admin.options.headers['Authorization'] = 'Bearer $token';
    await admin.post<dynamic>('/stores/${session.store.id}/sync/manual/authorize', data: <String, dynamic>{});

    final manual = await engine.sync();
    expect(manual.result, SyncResult.synced, reason: 'manual run: $manual');
    // ignore: avoid_print
    print('E2E scheduled: $first | $second | $manual');
  }, skip: base == null ? 'set E2E_BASE_URL to run against a backend' : false);
}
