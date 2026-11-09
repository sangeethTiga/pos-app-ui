import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/core/config/app_config.dart';
import 'package:pos_app_ui/core/error/failure.dart';
import 'package:pos_app_ui/core/network/api_client.dart';
import 'package:pos_app_ui/core/network/request_signer.dart';
import 'package:pos_app_ui/core/storage/secure_store.dart';
import 'package:pos_app_ui/core/utils/result.dart';
import 'package:pos_app_ui/features/device_setup/data/datasources/device_local_data_source.dart';
import 'package:pos_app_ui/features/device_setup/data/datasources/device_remote_data_source.dart';
import 'package:pos_app_ui/features/device_setup/data/models/device_activation_model.dart';
import 'package:pos_app_ui/features/device_setup/data/models/device_status_model.dart';
import 'package:pos_app_ui/features/device_setup/data/repositories/activation_repository_impl.dart';
import 'package:pos_app_ui/features/device_setup/data/repositories/device_repository_impl.dart';
import 'package:pos_app_ui/features/device_setup/domain/entities/device_activation.dart';

class _Adapter implements HttpClientAdapter {
  _Adapter(this.status, this.body, {this.date});
  final int status;
  final String body;
  final String? date;
  final requests = <(String, String, String?)>[];

  @override
  Future<ResponseBody> fetch(RequestOptions o, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    final sent = requestStream == null ? null : utf8.decode((await requestStream.toList()).expand((c) => c).toList());
    requests.add((o.method, o.path, sent));
    return ResponseBody.fromString(
      body,
      status,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
        'date': ?(date == null ? null : [date!]),
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

const _activationJson = {
  'device_id': 'd1',
  'store_id': 's1',
  'status': 'ACTIVE',
  'valid': true,
  'starts_at': '2026-11-09T10:00:00Z',
  'expires_at': '2026-12-09T10:00:00Z',
  'remaining_days': 30,
  'activation_id': 'a1',
};

void main() {
  const config = AppConfig(apiBaseUrl: 'http://pos.test/api/v1', appVersion: '1.2.3');
  final deviceNow = DateTime.utc(2026, 11, 9, 12);

  (ActivationRepositoryImpl, MemorySecureStore, RequestSigner) build(_Adapter adapter) {
    final dio = createDio(config)..httpClientAdapter = adapter;
    final store = MemorySecureStore();
    final signer = RequestSigner();
    final repo = ActivationRepositoryImpl(
      DeviceRemoteDataSource(dio),
      DeviceLocalDataSource(store),
      config,
      signer: signer,
      clock: () => deviceNow,
    );
    return (repo, store, signer);
  }

  group('parsing', () {
    test('GET /devices/activation body', () {
      final a = DeviceActivationModel.fromJson(_activationJson).toEntity();
      expect(a.status, ActivationStatus.active);
      expect(a.valid, isTrue);
      expect(a.deviceId, 'd1');
      expect(a.storeId, 's1');
      expect(a.startsAt, DateTime.utc(2026, 11, 9, 10));
      expect(a.expiresAt, DateTime.utc(2026, 12, 9, 10));
      expect(a.expiresAt!.isUtc, isTrue);
      expect(a.remainingDays, 30);
      expect(a.activationId, 'a1');
    });

    test('INACTIVE with nulls and unknown statuses', () {
      final a = DeviceActivationModel.fromJson({
        'device_id': 'd1',
        'status': 'INACTIVE',
        'valid': false,
        'starts_at': null,
        'expires_at': null,
        'remaining_days': null,
        'activation_id': null,
      }).toEntity();
      expect([a.status, a.valid, a.startsAt, a.expiresAt, a.remainingDays], [ActivationStatus.inactive, false, null, null, null]);
      for (final s in ['SCHEDULED', 'SUSPENDED', 'EXPIRED', 'REVOKED']) {
        expect(ActivationStatus.fromWire(s).wire, s);
      }
      expect(ActivationStatus.fromWire('SOMETHING_NEW'), ActivationStatus.inactive);
    });

    test('heartbeat / devices/me carries the activation block', () {
      final st = DeviceStatusModel.fromJson({
        'device_id': 'd1',
        'device_code': 'P1',
        'status': 'ACTIVE',
        'store_status': 'ACTIVE',
        'can_sell': false,
        'is_gateway': false,
        'server_time': '2026-11-09T12:00:00.000Z',
        'activation': {..._activationJson, 'status': 'SUSPENDED', 'valid': false},
      }).toEntity();
      expect(st.canSell, isFalse);
      expect(st.activation!.status, ActivationStatus.suspended);
    });

    test('stored snapshot round trip', () {
      final m = ActivationSnapshotModel.fromEntity(
        ActivationSnapshot(
          activation: DeviceActivationModel.fromJson(_activationJson).toEntity(),
          clockOffset: const Duration(seconds: -42),
          lastServerTime: DateTime.utc(2026, 11, 9, 12),
          receivedAt: deviceNow,
        ),
      );
      final back = ActivationSnapshotModel.fromJson(jsonDecode(jsonEncode(m.toJson())) as Map<String, dynamic>).toEntity();
      expect(back, m.toEntity());
      expect(back.clockOffset, const Duration(seconds: -42));
    });
  });

  test('fetch stores the state and the clock offset from the Date header', () async {
    final adapter = _Adapter(200, jsonEncode(_activationJson), date: 'Mon, 09 Nov 2026 12:00:30 GMT');
    final (repo, store, signer) = build(adapter);
    final emitted = repo.changes.first;

    final r = await repo.fetch();

    expect(r, isA<Success<ActivationSnapshot>>());
    expect(adapter.requests.single.$1, 'GET');
    expect(adapter.requests.single.$2, '/devices/activation');
    final cached = (await repo.cached())!;
    expect(cached.activation.valid, isTrue);
    expect(cached.clockOffset, const Duration(seconds: 30));
    expect(cached.lastServerTime, DateTime.utc(2026, 11, 9, 12, 0, 30));
    expect(signer.clockOffset, const Duration(seconds: 30));
    expect((await emitted).activation.activationId, 'a1');
    expect(store.values.keys, contains('device_activation_v1'));
  });

  test('activate sends the formatted code and stores the returned activation', () async {
    final adapter = _Adapter(
      200,
      jsonEncode({
        'device_id': 'd1',
        'activation': {..._activationJson}..remove('device_id')..remove('store_id'),
      }),
    );
    final (repo, _, _) = build(adapter);

    final r = await repo.activate('abcd efgh jklm');

    expect(jsonDecode(adapter.requests.single.$3!), {'code': 'ABCD-EFGH-JKLM'});
    expect(adapter.requests.single.$2, '/devices/activate');
    final s = (r as Success<ActivationSnapshot>).value;
    expect(s.activation.deviceId, 'd1');
    expect(s.activation.valid, isTrue);
  });

  test('activate: 422 INVALID_ACTIVATION_CODE is a ServerFailure, nothing stored', () async {
    final adapter = _Adapter(
      422,
      jsonEncode({
        'error': {'code': 'INVALID_ACTIVATION_CODE', 'message': 'Activation code is invalid.'},
      }),
    );
    final (repo, _, _) = build(adapter);

    final r = await repo.activate('ABCD-EFGH-JKLM');

    expect((r as Err).failure, isA<ServerFailure>().having((f) => f.code, 'code', 'INVALID_ACTIVATION_CODE'));
    expect(await repo.cached(), isNull);
  });

  test('heartbeat posts the app version and stores the activation with server_time', () async {
    final adapter = _Adapter(
      200,
      jsonEncode({
        'device_id': 'd1',
        'device_code': 'P1',
        'status': 'ACTIVE',
        'store_status': 'ACTIVE',
        'can_sell': true,
        'is_gateway': false,
        'server_time': '2026-11-09T11:59:00.000Z',
        'activation': _activationJson,
      }),
    );
    final (repo, _, _) = build(adapter);

    await repo.heartbeat();

    expect(adapter.requests.single.$1, 'POST');
    expect(adapter.requests.single.$2, '/devices/heartbeat');
    expect(jsonDecode(adapter.requests.single.$3!), {'app_version': '1.2.3'});
    expect((await repo.cached())!.clockOffset, const Duration(minutes: -1));
  });

  test('GET /devices/me stores the activation through the device repository', () async {
    final adapter = _Adapter(
      200,
      jsonEncode({
        'device_id': 'd1',
        'device_code': 'P1',
        'status': 'ACTIVE',
        'store_status': 'ACTIVE',
        'can_sell': false,
        'is_gateway': false,
        'activation': {..._activationJson, 'status': 'EXPIRED', 'valid': false},
      }),
    );
    final dio = createDio(config)..httpClientAdapter = adapter;
    final local = DeviceLocalDataSource(MemorySecureStore());
    final remote = DeviceRemoteDataSource(dio);
    final activations = ActivationRepositoryImpl(remote, local, config);
    final devices = DeviceRepositoryImpl(remote, local, config, platform: 'android', activations: activations);

    await devices.status();

    expect((await activations.cached())!.activation.status, ActivationStatus.expired);
  });

  test('WebSocket payload: stored for this device, ignored for another', () async {
    final (repo, _, _) = build(_Adapter(200, '{}'));
    final payload = {
      'event_id': 'e1',
      'device_id': 'd2',
      'activation': {'status': 'REVOKED', 'valid': false},
    };

    expect(await repo.recordPushed(payload, deviceId: 'd1'), isNull);
    expect(await repo.cached(), isNull);

    final s = await repo.recordPushed({...payload, 'device_id': 'd1'}, deviceId: 'd1');
    expect(s!.activation.status, ActivationStatus.revoked);
    expect(s.activation.deviceId, 'd1');
  });

  test('a device clock turned back keeps the latest server time', () async {
    final (repo, _, _) = build(_Adapter(200, '{}'));
    final a = DeviceActivationModel.fromJson(_activationJson).toEntity();
    await repo.record(a, serverTime: DateTime.utc(2026, 11, 9, 13));
    final s = await repo.record(a, serverTime: DateTime.utc(2026, 11, 9, 12, 30));
    expect(s.lastServerTime, DateTime.utc(2026, 11, 9, 13));
    final noTime = await repo.record(a);
    expect(noTime.clockOffset, const Duration(minutes: 30)); // kept from the last response with a time
  });
}
