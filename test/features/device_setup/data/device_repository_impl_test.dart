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
import 'package:pos_app_ui/features/device_setup/data/repositories/activation_repository_impl.dart';
import 'package:pos_app_ui/features/device_setup/data/repositories/device_repository_impl.dart';
import 'package:pos_app_ui/features/device_setup/domain/activation_policy.dart';
import 'package:pos_app_ui/features/device_setup/domain/entities/device_activation.dart';
import 'package:pos_app_ui/features/device_setup/domain/entities/device_session.dart';
import 'package:pos_app_ui/features/device_setup/domain/repositories/activation_repository.dart';

class _Adapter implements HttpClientAdapter {
  _Adapter(this.status, this.body);
  final int status;
  final String body;
  String? sentBody;
  String? path;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    path = options.path;
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
  final fixture = File('test/fixtures/setup_response.json').readAsStringSync();

  DeviceRepositoryImpl repo(_Adapter adapter, SecureStore store, {ActivationRepository? activations}) {
    final dio = createDio(config)..httpClientAdapter = adapter;
    final remote = DeviceRemoteDataSource(dio);
    return DeviceRepositoryImpl(
      remote,
      DeviceLocalDataSource(store),
      config,
      platform: 'android',
      activations: activations,
    );
  }

  test('setup sends snake_case body, parses the response, stores credentials and the activation', () async {
    final adapter = _Adapter(201, fixture);
    final store = MemorySecureStore();
    final local = DeviceLocalDataSource(store);
    final dio = createDio(config)..httpClientAdapter = adapter;
    final activations = ActivationRepositoryImpl(
      DeviceRemoteDataSource(dio),
      local,
      config,
      clock: () => DateTime.utc(2026, 11, 8, 7),
    );
    final r = repo(adapter, store, activations: activations);
    final announced = activations.changes.first;

    final result = await r.setup(
      code: 'abcd efgh-jkmn',
      deviceName: 'POS-1',
      profile: const DeviceProfile(
        deviceType: DeviceType.captain,
        kioskId: 'k1',
        kioskWiseOrderListing: true,
        deliveryManagerPos: true,
      ),
    );

    expect(adapter.path, '/devices/setup');
    expect(jsonDecode(adapter.sentBody!), {
      'code': 'ABCD-EFGH-JKMN',
      'device_name': 'POS-1',
      'platform': 'android',
      'app_version': '1.2.3',
      'device_type': 'CAPTAIN',
      'hardware_id': await local.hardwareId(),
      'kiosk_id': 'k1',
      'settings': {
        'kiosk_wise_order_listing': true,
        'delivery_manager_pos': true,
        'settle_assigned_orders_only': false,
      },
    });
    final session = (result as Success).value;
    expect(session.profile.deviceType, DeviceType.captain);
    expect(session.profile.kioskName, 'U Kiosk');
    expect(session.profile.deliveryManagerPos, isTrue);
    expect(session.deviceCode, 'P1');
    expect(session.store.currencyDecimals, 2);
    expect(session.store.pricesIncludeTax, isTrue);
    expect(session.accessTokenExpiresAt, DateTime.utc(2026, 11, 9, 7));

    // persisted and readable after an app restart
    final again = await repo(_Adapter(200, '{}'), store).currentSession();
    expect(again, session);
    expect(await local.deviceCredentials(), (accessToken: '12|devicetokenvalue', signingSecret: session.signingSecret));

    // activated in the same call: stored for the sell gate and announced to the activation cubit
    final stored = (await activations.cached())!;
    expect(stored.activation.status, ActivationStatus.active);
    expect(stored.activation.valid, isTrue);
    expect(stored.activation.deviceId, session.deviceId);
    expect(stored.activation.expiresAt, DateTime.utc(2026, 12, 8, 7));
    expect(stored.lastServerTime, DateTime.utc(2026, 11, 8, 7));
    expect(ActivationPolicy.evaluate(stored, DateTime.utc(2026, 11, 8, 8)).canSell, isTrue);
    expect((await announced).activation, stored.activation);
  });

  test('wrong code: failure from the error envelope, nothing stored', () async {
    final store = MemorySecureStore();
    final r = repo(
      _Adapter(
        422,
        '{"error":{"code":"INVALID_ACTIVATION_CODE","message":"Invalid or expired activation code.","details":{},'
        '"retryable":false}}',
      ),
      store,
    );

    final result = await r.setup(code: 'ABCD-EFGH-JKMN', deviceName: 'POS-1');

    expect((result as Err).failure, isA<ServerFailure>().having((f) => f.code, 'code', 'INVALID_ACTIVATION_CODE'));
    expect(store.values.keys, ['terminal_hardware_id']); // the terminal's own id only, no credentials
    expect(await r.currentSession(), isNull);
  });

  test('device limit: 402 failure keeps its code', () async {
    final r = repo(
      _Adapter(402, '{"error":{"code":"DEVICE_LIMIT_REACHED","message":"Device limit reached.","retryable":false}}'),
      MemorySecureStore(),
    );
    final failure = ((await r.setup(code: 'ABCD-EFGH-JKMN', deviceName: 'POS-1')) as Err).failure;
    expect(failure, isA<ServerFailure>().having((f) => f.statusCode, 'status', 402));
    expect((failure as ServerFailure).code, 'DEVICE_LIMIT_REACHED');
  });

  test('server paired but secure storage fails: clear failure, not a stuck screen', () async {
    final r = repo(_Adapter(201, fixture), _FailingStore());
    final result = await r.setup(code: 'ABCD-EFGH-JKMN', deviceName: 'POS-1');
    final failure = (result as Err).failure;
    expect(failure, isA<UnexpectedFailure>());
    expect(failure.userMessage, contains('Ask for a new code'));
  });

  test('response without an activation block still pairs (the gate asks the server)', () async {
    final body = Map<String, dynamic>.from(jsonDecode(fixture) as Map)..remove('activation');
    final store = MemorySecureStore();
    final local = DeviceLocalDataSource(store);
    final adapter = _Adapter(201, jsonEncode(body));
    final dio = createDio(config)..httpClientAdapter = adapter;
    final activations = ActivationRepositoryImpl(DeviceRemoteDataSource(dio), local, config);
    final result = await repo(adapter, store, activations: activations).setup(code: 'ABCD-EFGH-JKMN', deviceName: 'P');
    expect(result, isA<Success<DeviceSession>>());
    expect(await activations.cached(), isNull);
  });

  test('preview sends the formatted code and parses store, kiosks, roles and the re-paired device', () async {
    final adapter = _Adapter(
      200,
      '{"store":{"id":"s1","code":"ST-0007","name":"Khyber Darbar"},'
      '"kiosks":[{"id":"k1","name":"U Kiosk"}],"device_types":["CASHIER","CAPTAIN"],"re_pair":true,'
      '"device":{"id":"d1","code":"P3","name":"Front till"}}',
    );
    final r = repo(adapter, MemorySecureStore());

    final p = ((await r.preview('abcdefghjkmn')) as Success<SetupPreview>).value;

    expect(adapter.path, '/devices/setup/preview');
    expect(jsonDecode(adapter.sentBody!), {'code': 'ABCD-EFGH-JKMN'});
    expect(
      p,
      const SetupPreview(
        storeId: 's1',
        storeCode: 'ST-0007',
        storeName: 'Khyber Darbar',
        kiosks: [KioskOption(id: 'k1', name: 'U Kiosk')],
        deviceTypes: [DeviceType.cashier, DeviceType.captain],
        rePair: true,
        deviceCode: 'P3',
        deviceName: 'Front till',
      ),
    );
  });

  test('preview: invalid code comes back as a failure', () async {
    final r = repo(
      _Adapter(422, '{"error":{"code":"INVALID_ACTIVATION_CODE","message":"Invalid activation code."}}'),
      MemorySecureStore(),
    );
    final failure = ((await r.preview('ABCD-EFGH-JKMN')) as Err).failure;
    expect(failure, isA<ServerFailure>().having((f) => f.code, 'code', 'INVALID_ACTIVATION_CODE'));
  });

  test('hardware id is stable across calls', () async {
    final r = repo(_Adapter(200, '{}'), MemorySecureStore());
    final id = await r.hardwareId();
    expect(id, matches(RegExp(r'^[0-9A-F-]{36}$')));
    expect(await r.hardwareId(), id);
  });

  test('session stored before roles existed reads as a cashier', () async {
    final old = Map<String, dynamic>.from(jsonDecode(fixture) as Map)..remove('profile');
    final store = MemorySecureStore()..values['device_session_v1'] = jsonEncode(old);
    final session = await repo(_Adapter(200, '{}'), store).currentSession();
    expect(session!.profile, const DeviceProfile());
  });

  test('corrupt stored session is discarded', () async {
    final store = MemorySecureStore()..values['device_session_v1'] = '{not json';
    expect(await repo(_Adapter(200, '{}'), store).currentSession(), isNull);
    expect(store.values, isEmpty);
  });
}

class _FailingStore extends MemorySecureStore {
  @override
  Future<void> write(String key, String value) async =>
      throw Exception('-34018 A required entitlement is not present.');
}
