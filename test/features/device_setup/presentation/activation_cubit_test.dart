import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/core/error/failure.dart';
import 'package:pos_app_ui/core/utils/result.dart';
import 'package:pos_app_ui/features/device_setup/domain/entities/device_activation.dart';
import 'package:pos_app_ui/features/device_setup/domain/entities/device_session.dart';
import 'package:pos_app_ui/features/device_setup/domain/repositories/activation_repository.dart';
import 'package:pos_app_ui/features/device_setup/presentation/cubit/activation_cubit.dart';
import 'package:pos_app_ui/features/sync/data/realtime_client.dart';
import 'package:pos_app_ui/features/sync/domain/sync_engine.dart';

/// In-memory repository: [serverState] is what the server returns.
class FakeActivationRepository implements ActivationRepository {
  FakeActivationRepository({this.stored, this.serverState});

  ActivationSnapshot? stored;
  DeviceActivation? serverState;
  Failure? activateFailure;
  Failure? fetchFailure;
  int fetches = 0;
  final activatedCodes = <String>[];
  final _changes = StreamController<ActivationSnapshot>.broadcast();
  static final receivedAt = DateTime.utc(2026, 11, 9);

  @override
  Stream<ActivationSnapshot> get changes => _changes.stream;

  @override
  Future<ActivationSnapshot?> cached() async => stored;

  @override
  Future<ActivationSnapshot> record(DeviceActivation activation, {DateTime? serverTime}) async {
    final s = ActivationSnapshot(activation: activation, receivedAt: receivedAt);
    stored = s;
    _changes.add(s);
    return s;
  }

  @override
  Future<Result<ActivationSnapshot>> fetch() async {
    fetches++;
    if (fetchFailure case final f?) return Err(f);
    return Success(await record(serverState ?? const DeviceActivation()));
  }

  @override
  Future<Result<ActivationSnapshot>> activate(String code) async {
    activatedCodes.add(code);
    if (activateFailure case final f?) return Err(f);
    return Success(await record(serverState!));
  }

  @override
  Future<Result<DeviceStatus>> heartbeat() async => const Err(Failure.network(message: 'offline'));

  @override
  Future<ActivationSnapshot?> recordPushed(Map<String, dynamic> payload, {required String deviceId}) async {
    if (payload['device_id'] != deviceId) return null;
    final a = payload['activation'] as Map;
    return record(
      DeviceActivation(
        deviceId: deviceId,
        status: ActivationStatus.fromWire(a['status'] as String?),
        valid: a['valid'] as bool? ?? false,
      ),
    );
  }
}

void main() {
  final now = DateTime.utc(2026, 11, 9, 12);
  final valid = DeviceActivation(
    deviceId: 'd1',
    status: ActivationStatus.active,
    valid: true,
    startsAt: DateTime.utc(2026, 11, 1),
    expiresAt: DateTime.utc(2026, 12, 9, 10),
  );

  Future<void> flush() => Future<void>.delayed(Duration.zero);

  test('start: stored state first (offline), then the server', () async {
    final repo = FakeActivationRepository(
      stored: ActivationSnapshot(activation: valid, receivedAt: now),
      serverState: const DeviceActivation(status: ActivationStatus.suspended),
    )..fetchFailure = const Failure.network(message: 'offline');
    final cubit = ActivationCubit(repo, clock: () => now);
    addTearDown(cubit.close);

    await cubit.start('d1');
    await flush();

    expect(cubit.state.loaded, isTrue);
    expect(cubit.state.canSell, isTrue); // offline: the stored valid state still applies
    expect(cubit.state.refreshError, isNotNull);
    expect(repo.fetches, 1);
  });

  test('expiry passing while offline blocks on the next re-evaluation', () async {
    var clock = DateTime.utc(2026, 12, 9, 9, 59);
    final repo = FakeActivationRepository(stored: ActivationSnapshot(activation: valid, receivedAt: now))
      ..fetchFailure = const Failure.network(message: 'offline');
    final cubit = ActivationCubit(repo, clock: () => clock);
    addTearDown(cubit.close);
    await cubit.start('d1');
    expect(cubit.state.canSell, isTrue);

    clock = DateTime.utc(2026, 12, 9, 10, 0, 1);
    cubit.reevaluate();

    expect(cubit.state.canSell, isFalse);
    expect(cubit.state.verdict.block, ActivationBlock.expired);
  });

  test('device.activation: own event applied at once and re-fetched; other terminals ignored', () async {
    final events = StreamController<RealtimeMessage>.broadcast();
    addTearDown(events.close);
    final repo = FakeActivationRepository(serverState: valid);
    final cubit = ActivationCubit(repo, realtime: events.stream, clock: () => now);
    addTearDown(cubit.close);
    await cubit.start('d1');
    await flush();
    expect(cubit.state.canSell, isTrue);
    final fetchesBefore = repo.fetches;

    events.add(
      const RealtimeMessage('device.activation', 'c', {
        'event_id': 'e1',
        'device_id': 'd2',
        'activation': {'status': 'REVOKED', 'valid': false},
      }),
    );
    await flush();
    expect(cubit.state.canSell, isTrue);
    expect(repo.fetches, fetchesBefore);

    repo.serverState = const DeviceActivation(deviceId: 'd1', status: ActivationStatus.suspended);
    final states = <ActivationState>[];
    final sub = cubit.stream.listen(states.add);
    const own = RealtimeMessage('device.activation', 'c', {
      'event_id': 'e2',
      'device_id': 'd1',
      'activation': {'status': 'SUSPENDED', 'valid': false},
    });
    events
      ..add(own)
      ..add(own); // same event on the second channel
    await flush();
    await flush();
    await sub.cancel();

    expect(states.first.verdict.block, ActivationBlock.suspended); // before the confirming fetch
    expect(cubit.state.verdict.block, ActivationBlock.suspended);
    expect(repo.fetches, fetchesBefore + 1);
  });

  test('a DEVICE_NOT_ACTIVATED sync rejection refreshes the activation', () async {
    final reports = StreamController<SyncReport>.broadcast();
    addTearDown(reports.close);
    final repo = FakeActivationRepository(serverState: valid);
    final cubit = ActivationCubit(repo, syncReports: reports.stream, clock: () => now);
    addTearDown(cubit.close);
    await cubit.start('d1');
    await flush();
    final before = repo.fetches;

    reports.add(const SyncReport(SyncResult.synced));
    await flush();
    expect(repo.fetches, before);

    reports.add(const SyncReport(SyncResult.synced, rejected: 1, rejectedCodes: {'DEVICE_NOT_ACTIVATED'}));
    await flush();
    expect(repo.fetches, before + 1);
  });

  group('activate', () {
    test('incomplete code is refused locally', () async {
      final repo = FakeActivationRepository(serverState: valid);
      final cubit = ActivationCubit(repo, clock: () => now);
      addTearDown(cubit.close);

      await cubit.activate('ABCD-EF');

      expect(cubit.state.activationError, contains('12-character'));
      expect(repo.activatedCodes, isEmpty);
    });

    test('valid code unblocks', () async {
      final repo = FakeActivationRepository(serverState: valid);
      final cubit = ActivationCubit(repo, clock: () => now);
      addTearDown(cubit.close);

      await cubit.activate('abcd-efgh-jklm');

      expect(repo.activatedCodes, ['abcd-efgh-jklm']);
      expect(cubit.state.canSell, isTrue);
      expect(cubit.state.activating, isFalse);
      expect(cubit.state.activationError, isNull);
    });

    test('422 and 429 messages', () async {
      final repo = FakeActivationRepository(serverState: valid)
        ..activateFailure = const Failure.server(statusCode: 422, code: 'INVALID_ACTIVATION_CODE', message: 'x');
      final cubit = ActivationCubit(repo, clock: () => now);
      addTearDown(cubit.close);

      await cubit.activate('ABCD-EFGH-JKLM');
      expect(cubit.state.activationError, contains('not valid for this terminal'));
      expect(cubit.state.canSell, isFalse);

      repo.activateFailure = const Failure.server(statusCode: 429, code: 'HTTP_429', message: 'Too Many Attempts.');
      await cubit.activate('ABCD-EFGH-JKLM');
      expect(cubit.state.activationError, contains('Too many attempts'));
    });
  });
}
