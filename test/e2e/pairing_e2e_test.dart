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
import 'package:pos_app_ui/features/device_setup/data/repositories/activation_repository_impl.dart';
import 'package:pos_app_ui/features/device_setup/data/repositories/device_repository_impl.dart';
import 'package:pos_app_ui/features/device_setup/domain/entities/device_session.dart';

/// Real backend, real HTTP, real HMAC. Needs a running backend and a fresh activation code issued by the
/// platform super admin:
///
/// E2E_BASE_URL=http://localhost:8000/api/v1 E2E_ACTIVATION_CODE=ABCD-EFGH-JKMN flutter test --tags e2e
void main() {
  final env = Platform.environment;
  final base = env['E2E_BASE_URL'];

  test('preview the code, pair + activate in one call, then a signed GET /devices/me', () async {
    final config = AppConfig(apiBaseUrl: base!, appVersion: '1.0.0');
    final local = DeviceLocalDataSource(MemorySecureStore());
    final dio = createDio(config, interceptors: [DeviceAuthInterceptor(local, RequestSigner())]);
    final remote = DeviceRemoteDataSource(dio);
    final activations = ActivationRepositoryImpl(remote, local, config);
    final repo = DeviceRepositoryImpl(remote, local, config, platform: 'windows', activations: activations);
    final code = env['E2E_ACTIVATION_CODE']!;

    final preview = switch (await repo.preview(code)) {
      Success(:final value) => value,
      Err(:final failure) => fail('preview failed: $failure'),
    };
    expect(preview.storeName, isNotEmpty);

    final paired = await repo.setup(code: code, deviceName: 'E2E terminal');
    final session = switch (paired) {
      Success(:final value) => value,
      Err(:final failure) => fail('setup failed: $failure'),
    };
    expect(session.deviceCode, matches(RegExp(r'^P\d+$')));
    expect(session.store.id, preview.storeId);

    // activated by the same call: stored without asking the server again
    final stored = await activations.cached();
    expect(stored, isNotNull, reason: 'POST /devices/setup returned no activation block');
    expect(stored!.activation.deviceId, session.deviceId);

    final status = await repo.status();
    final DeviceStatus st = switch (status) {
      Success(:final value) => value,
      Err(:final failure) => fail('signed request failed: $failure'),
    };
    expect(st.deviceCode, session.deviceCode);
    expect(st.status, 'ACTIVE');
  }, skip: base == null ? 'set E2E_BASE_URL to run against a backend' : false);
}
