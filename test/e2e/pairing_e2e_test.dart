@Tags(['e2e'])
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/core/config/app_config.dart';
import 'package:pos_app_ui/core/network/api_client.dart';
import 'package:pos_app_ui/core/network/device_auth_interceptor.dart';
import 'package:pos_app_ui/core/network/request_signer.dart';
import 'package:pos_app_ui/core/storage/secure_store.dart';
import 'package:pos_app_ui/core/utils/result.dart';
import 'package:pos_app_ui/features/device_setup/data/datasources/device_local_data_source.dart';
import 'package:pos_app_ui/features/device_setup/data/datasources/device_remote_data_source.dart';
import 'package:pos_app_ui/features/device_setup/data/repositories/device_repository_impl.dart';
import 'package:pos_app_ui/features/device_setup/domain/entities/device_session.dart';

/// Real backend, real HTTP, real HMAC. Needs a running backend and a fresh registration code:
///
/// E2E_BASE_URL=http://localhost:8000/api/v1 E2E_STORE_CODE=ST-0007 E2E_REG_CODE=123456 \
///   flutter test --tags e2e
void main() {
  final env = Platform.environment;
  final base = env['E2E_BASE_URL'];

  test('pair with the real backend, then a signed GET /devices/me', () async {
    final config = AppConfig(apiBaseUrl: base!, appVersion: '1.0.0');
    final local = DeviceLocalDataSource(MemorySecureStore());
    final dio = createDio(config, interceptors: [DeviceAuthInterceptor(local, RequestSigner())]);
    final repo = DeviceRepositoryImpl(DeviceRemoteDataSource(dio), local, config, platform: 'windows');

    final paired = await repo.register(
      storeCode: env['E2E_STORE_CODE']!,
      registrationCode: env['E2E_REG_CODE']!,
      deviceName: 'E2E terminal',
    );
    final session = switch (paired) {
      Success(:final value) => value,
      Err(:final failure) => fail('register failed: $failure'),
    };
    expect(session.deviceCode, matches(RegExp(r'^P\d+$')));

    final status = await repo.status();
    final DeviceStatus st = switch (status) {
      Success(:final value) => value,
      Err(:final failure) => fail('signed request failed: $failure'),
    };
    expect(st.deviceCode, session.deviceCode);
    expect(st.status, 'ACTIVE');
  }, skip: base == null ? 'set E2E_BASE_URL to run against a backend' : false);
}
