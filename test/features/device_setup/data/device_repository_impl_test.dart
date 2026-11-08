import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/core/config/app_config.dart';
import 'package:pos_app_ui/core/error/failure.dart';
import 'package:pos_app_ui/core/network/api_client.dart';
import 'package:pos_app_ui/core/storage/secure_store.dart';
import 'package:pos_app_ui/core/utils/result.dart';
import 'package:pos_app_ui/features/device_setup/data/datasources/device_local_data_source.dart';
import 'package:pos_app_ui/features/device_setup/data/datasources/device_remote_data_source.dart';
import 'package:pos_app_ui/features/device_setup/data/repositories/device_repository_impl.dart';

class _Adapter implements HttpClientAdapter {
  _Adapter(this.status, this.body);
  final int status;
  final String body;
  String? sentBody;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    if (requestStream != null) sentBody = utf8.decode((await requestStream.toList()).expand((c) => c).toList());
    return ResponseBody.fromString(
      body,
      status,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  const config = AppConfig(apiBaseUrl: 'http://pos.test/api/v1', appVersion: '1.2.3');
  final fixture = File('test/fixtures/register_response.json').readAsStringSync();

  DeviceRepositoryImpl repo(_Adapter adapter, MemorySecureStore store) {
    final dio = createDio(config)..httpClientAdapter = adapter;
    return DeviceRepositoryImpl(DeviceRemoteDataSource(dio), DeviceLocalDataSource(store), config, platform: 'android');
  }

  test('register sends snake_case body, parses the response and stores credentials', () async {
    final adapter = _Adapter(201, fixture);
    final store = MemorySecureStore();
    final r = repo(adapter, store);

    final result = await r.register(storeCode: 'ST-0007', registrationCode: '483920', deviceName: 'POS-1');

    expect(jsonDecode(adapter.sentBody!), {
      'store_code': 'ST-0007',
      'registration_code': '483920',
      'device_name': 'POS-1',
      'platform': 'android',
      'app_version': '1.2.3',
    });
    final session = (result as Success).value;
    expect(session.deviceCode, 'P1');
    expect(session.store.currencyDecimals, 2);
    expect(session.store.pricesIncludeTax, isTrue);
    expect(session.accessTokenExpiresAt, DateTime.utc(2026, 11, 9, 7));

    // persisted and readable after an app restart
    final again = await repo(_Adapter(200, '{}'), store).currentSession();
    expect(again, session);
    expect(await DeviceLocalDataSource(store).deviceCredentials(), (
      accessToken: '12|devicetokenvalue',
      signingSecret: session.signingSecret,
    ));
  });

  test('wrong code: failure from the error envelope, nothing stored', () async {
    final store = MemorySecureStore();
    final r = repo(
      _Adapter(
        422,
        '{"error":{"code":"VALIDATION_FAILED","message":"Invalid or expired registration code.","details":{},"retryable":false}}',
      ),
      store,
    );

    final result = await r.register(storeCode: 'ST-0007', registrationCode: '000000', deviceName: 'POS-1');

    expect((result as Err).failure, isA<ServerFailure>().having((f) => f.code, 'code', 'VALIDATION_FAILED'));
    expect(store.values, isEmpty);
    expect(await r.currentSession(), isNull);
  });

  test('corrupt stored session is discarded', () async {
    final store = MemorySecureStore()..values['device_session_v1'] = '{not json';
    expect(await repo(_Adapter(200, '{}'), store).currentSession(), isNull);
    expect(store.values, isEmpty);
  });
}
