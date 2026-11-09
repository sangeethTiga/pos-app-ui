import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pos_app_ui/core/error/failure.dart';
import 'package:pos_app_ui/core/utils/result.dart';
import 'package:pos_app_ui/features/device_setup/domain/entities/device_session.dart';
import 'package:pos_app_ui/features/device_setup/domain/repositories/device_repository.dart';
import 'package:pos_app_ui/features/device_setup/domain/usecases/get_current_session.dart';
import 'package:pos_app_ui/features/device_setup/domain/usecases/get_hardware_id.dart';
import 'package:pos_app_ui/features/device_setup/domain/usecases/preview_setup.dart';
import 'package:pos_app_ui/features/device_setup/domain/usecases/setup_device.dart';
import 'package:pos_app_ui/features/device_setup/presentation/bloc/device_setup_bloc.dart';

class _MockRepo extends Mock implements DeviceRepository {}

final _session = DeviceSession(
  deviceId: 'd1',
  deviceCode: 'P1',
  tokenLetter: 'A',
  gatewayPriority: 10,
  store: const StoreInfo(
    id: 's1',
    code: 'ST-0007',
    name: 'Store',
    currency: 'AED',
    currencyDecimals: 2,
    timezone: 'Asia/Dubai',
    businessDayCutoff: '04:00',
    pricesIncludeTax: true,
  ),
  accessToken: 'a',
  accessTokenExpiresAt: DateTime.utc(2026, 11, 9),
  refreshToken: 'r',
  refreshTokenExpiresAt: DateTime.utc(2026, 12, 8),
  signingSecret: 'sec',
);

void main() {
  late _MockRepo repo;
  DeviceSetupBloc build() =>
      DeviceSetupBloc(SetupDevice(repo), GetCurrentSession(repo), PreviewSetup(repo), GetHardwareId(repo));

  setUpAll(() => registerFallbackValue(const DeviceProfile()));
  setUp(() => repo = _MockRepo());

  blocTest<DeviceSetupBloc, DeviceSetupState>(
    'started: unpaired with the device id when nothing is stored',
    setUp: () {
      when(() => repo.currentSession()).thenAnswer((_) async => null);
      when(() => repo.hardwareId()).thenAnswer((_) async => 'HW-1');
    },
    build: build,
    act: (b) => b.add(const DeviceSetupEvent.started()),
    expect: () => [const DeviceSetupState.unpaired(hardwareId: 'HW-1')],
  );

  blocTest<DeviceSetupBloc, DeviceSetupState>(
    'started: paired when a session is stored',
    setUp: () => when(() => repo.currentSession()).thenAnswer((_) async => _session),
    build: build,
    act: (b) => b.add(const DeviceSetupEvent.started()),
    expect: () => [DeviceSetupState.paired(_session)],
  );

  const preview = SetupPreview(
    storeId: 's1',
    storeCode: 'ST-0007',
    storeName: 'Khyber Darbar',
    kiosks: [KioskOption(id: 'k1', name: 'U Kiosk')],
  );
  const invalid = Failure.server(
    statusCode: 422,
    code: 'INVALID_ACTIVATION_CODE',
    message: 'Invalid or expired activation code.',
  );
  const code = 'ABCD-EFGH-JKMN';

  blocTest<DeviceSetupBloc, DeviceSetupState>(
    'incomplete code is not checked',
    seed: () => const DeviceSetupState.unpaired(hardwareId: 'HW-1'),
    build: build,
    act: (b) => b.add(const DeviceSetupEvent.codeChanged('ABCD-EFGH')),
    expect: () => <DeviceSetupState>[],
    verify: (_) => verifyNever(() => repo.preview(any())),
  );

  blocTest<DeviceSetupBloc, DeviceSetupState>(
    'complete code: formatted, checked, store and kiosks shown',
    seed: () => const DeviceSetupState.unpaired(hardwareId: 'HW-1'),
    setUp: () => when(() => repo.preview(code)).thenAnswer((_) async => const Success(preview)),
    build: build,
    act: (b) => b.add(const DeviceSetupEvent.codeChanged('abcdefghjkmn')),
    expect: () => [
      const DeviceSetupState.unpaired(hardwareId: 'HW-1', code: code, checking: true),
      const DeviceSetupState.unpaired(hardwareId: 'HW-1', code: code, preview: preview),
    ],
  );

  blocTest<DeviceSetupBloc, DeviceSetupState>(
    'refused code is shown; editing it clears the store',
    seed: () => const DeviceSetupState.unpaired(),
    setUp: () => when(() => repo.preview(any())).thenAnswer((_) async => const Err(invalid)),
    build: build,
    act: (b) async {
      b.add(const DeviceSetupEvent.codeChanged(code));
      await Future<void>.delayed(Duration.zero);
      b.add(const DeviceSetupEvent.codeChanged('ABCD-EFGH-JKM'));
    },
    expect: () => [
      const DeviceSetupState.unpaired(code: code, checking: true),
      const DeviceSetupState.unpaired(code: code, previewFailure: invalid),
      const DeviceSetupState.unpaired(),
    ],
  );

  blocTest<DeviceSetupBloc, DeviceSetupState>(
    'a preview for a code that changed meanwhile is dropped',
    seed: () => const DeviceSetupState.unpaired(),
    setUp: () {
      when(() => repo.preview(code)).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 20));
        return const Success(preview);
      });
      when(() => repo.preview('ABCD-EFGH-JKMP')).thenAnswer((_) async => const Err(invalid));
    },
    build: build,
    act: (b) async {
      b.add(const DeviceSetupEvent.codeChanged(code));
      await Future<void>.delayed(Duration.zero);
      b.add(const DeviceSetupEvent.codeChanged('ABCD-EFGH-JKMP'));
    },
    wait: const Duration(milliseconds: 50),
    expect: () => [
      const DeviceSetupState.unpaired(code: code, checking: true),
      const DeviceSetupState.unpaired(code: 'ABCD-EFGH-JKMP', checking: true),
      const DeviceSetupState.unpaired(code: 'ABCD-EFGH-JKMP', previewFailure: invalid),
    ],
  );

  const profile = DeviceProfile(deviceType: DeviceType.captain, kioskId: 'k1', deliveryManagerPos: true);

  blocTest<DeviceSetupBloc, DeviceSetupState>(
    'activate: sends the code with name, role, kiosk and device id, then paired',
    seed: () => const DeviceSetupState.unpaired(hardwareId: 'HW-1', code: code, preview: preview),
    setUp: () => when(
      () => repo.setup(
        code: code,
        deviceName: 'POS-1',
        profile: profile.copyWith(hardwareId: 'HW-1'),
      ),
    ).thenAnswer((_) async => Success(_session)),
    build: build,
    act: (b) =>
        b.add(const DeviceSetupEvent.activateSubmitted(code: 'abcd-efgh-jkmn', deviceName: ' POS-1', profile: profile)),
    expect: () => [
      const DeviceSetupState.unpaired(hardwareId: 'HW-1', code: code, preview: preview, submitting: true),
      DeviceSetupState.paired(_session),
    ],
  );

  const limit = Failure.server(statusCode: 402, code: 'DEVICE_LIMIT_REACHED', message: 'Device limit reached.');

  blocTest<DeviceSetupBloc, DeviceSetupState>(
    'activate: failure keeps the page filled in; a double tap sends once',
    seed: () => const DeviceSetupState.unpaired(code: code, preview: preview),
    setUp: () =>
        when(
          () => repo.setup(
            code: any(named: 'code'),
            deviceName: any(named: 'deviceName'),
            profile: any(named: 'profile'),
          ),
        ).thenAnswer((_) async {
          await Future<void>.delayed(const Duration(milliseconds: 10));
          return const Err(limit);
        }),
    build: build,
    act: (b) async {
      b.add(const DeviceSetupEvent.activateSubmitted(code: code, deviceName: 'P', profile: DeviceProfile()));
      await Future<void>.delayed(Duration.zero);
      b.add(const DeviceSetupEvent.activateSubmitted(code: code, deviceName: 'P', profile: DeviceProfile()));
    },
    wait: const Duration(milliseconds: 30),
    expect: () => [
      const DeviceSetupState.unpaired(code: code, preview: preview, submitting: true),
      const DeviceSetupState.unpaired(code: code, preview: preview, failure: limit),
    ],
    verify: (_) => verify(
      () => repo.setup(
        code: any(named: 'code'),
        deviceName: any(named: 'deviceName'),
        profile: any(named: 'profile'),
      ),
    ).called(1),
  );
}
