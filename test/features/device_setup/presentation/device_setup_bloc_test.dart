import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pos_app_ui/core/error/failure.dart';
import 'package:pos_app_ui/core/utils/result.dart';
import 'package:pos_app_ui/features/device_setup/domain/entities/device_session.dart';
import 'package:pos_app_ui/features/device_setup/domain/repositories/device_repository.dart';
import 'package:pos_app_ui/features/device_setup/domain/usecases/get_current_session.dart';
import 'package:pos_app_ui/features/device_setup/domain/usecases/preview_registration.dart';
import 'package:pos_app_ui/features/device_setup/domain/usecases/register_device.dart';
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
  DeviceSetupBloc build() => DeviceSetupBloc(RegisterDevice(repo), GetCurrentSession(repo), PreviewRegistration(repo));

  setUpAll(() => registerFallbackValue(const DeviceProfile()));
  setUp(() => repo = _MockRepo());

  blocTest<DeviceSetupBloc, DeviceSetupState>(
    'started: unpaired when nothing is stored',
    setUp: () => when(() => repo.currentSession()).thenAnswer((_) async => null),
    build: build,
    act: (b) => b.add(const DeviceSetupEvent.started()),
    expect: () => [const DeviceSetupState.unpaired()],
  );

  blocTest<DeviceSetupBloc, DeviceSetupState>(
    'started: paired when a session is stored',
    setUp: () => when(() => repo.currentSession()).thenAnswer((_) async => _session),
    build: build,
    act: (b) => b.add(const DeviceSetupEvent.started()),
    expect: () => [DeviceSetupState.paired(_session)],
  );

  const preview = RegistrationPreview(
    storeId: 's1',
    storeCode: 'ST-0007',
    storeName: 'Khyber Darbar',
    kiosks: [KioskOption(id: 'k1', name: 'U Kiosk')],
    hardwareId: 'HW-1',
  );
  const failure = Failure.server(
    statusCode: 422,
    code: 'INVALID_REGISTRATION_CODE',
    message: 'Registration code is invalid or expired.',
  );

  blocTest<DeviceSetupBloc, DeviceSetupState>(
    'codes: trims and upper-cases, then shows the settings screen',
    setUp: () =>
        when(() => repo.preview(storeCode: 'ST-0007', registrationCode: '483920'))
            .thenAnswer((_) async => const Success(preview)),
    build: build,
    act: (b) => b.add(const DeviceSetupEvent.codesSubmitted(storeCode: ' st-0007 ', registrationCode: '483920 ')),
    expect: () => [const DeviceSetupState.verifying(), const DeviceSetupState.ready(preview)],
  );

  blocTest<DeviceSetupBloc, DeviceSetupState>(
    'codes: failure keeps the codes form',
    setUp: () => when(
      () => repo.preview(
        storeCode: any(named: 'storeCode'),
        registrationCode: any(named: 'registrationCode'),
      ),
    ).thenAnswer((_) async => const Err(failure)),
    build: build,
    act: (b) => b.add(const DeviceSetupEvent.codesSubmitted(storeCode: 'X', registrationCode: '1')),
    expect: () => [const DeviceSetupState.verifying(), const DeviceSetupState.failure(failure)],
  );

  const profile = DeviceProfile(deviceType: DeviceType.captain, kioskId: 'k1', deliveryManagerPos: true);

  blocTest<DeviceSetupBloc, DeviceSetupState>(
    'register: sends the codes from step 1 with role, kiosk and device id, then paired',
    setUp: () {
      when(() => repo.preview(storeCode: 'ST-0007', registrationCode: '483920'))
          .thenAnswer((_) async => const Success(preview));
      when(
        () => repo.register(
          storeCode: 'ST-0007',
          registrationCode: '483920',
          deviceName: 'POS-1',
          profile: profile.copyWith(hardwareId: 'HW-1'),
        ),
      ).thenAnswer((_) async => Success(_session));
    },
    build: build,
    act: (b) async {
      b.add(const DeviceSetupEvent.codesSubmitted(storeCode: 'ST-0007', registrationCode: '483920'));
      await Future<void>.delayed(Duration.zero);
      b.add(const DeviceSetupEvent.registerSubmitted(deviceName: ' POS-1', profile: profile));
    },
    expect: () => [
      const DeviceSetupState.verifying(),
      const DeviceSetupState.ready(preview),
      const DeviceSetupState.ready(preview, submitting: true),
      DeviceSetupState.paired(_session),
    ],
  );

  blocTest<DeviceSetupBloc, DeviceSetupState>(
    'register: failure stays on the settings screen; back returns to the codes form',
    seed: () => const DeviceSetupState.ready(preview),
    setUp: () => when(
      () => repo.register(
        storeCode: any(named: 'storeCode'),
        registrationCode: any(named: 'registrationCode'),
        deviceName: any(named: 'deviceName'),
        profile: any(named: 'profile'),
      ),
    ).thenAnswer((_) async => const Err(failure)),
    build: build,
    act: (b) async {
      b.add(const DeviceSetupEvent.registerSubmitted(deviceName: 'P', profile: DeviceProfile()));
      await Future<void>.delayed(Duration.zero);
      b.add(const DeviceSetupEvent.back());
    },
    expect: () => [
      const DeviceSetupState.ready(preview, submitting: true),
      const DeviceSetupState.ready(preview, failure: failure),
      const DeviceSetupState.unpaired(),
    ],
  );
}
