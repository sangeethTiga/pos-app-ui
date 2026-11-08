import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pos_app_ui/core/error/failure.dart';
import 'package:pos_app_ui/core/utils/result.dart';
import 'package:pos_app_ui/features/device_setup/domain/entities/device_session.dart';
import 'package:pos_app_ui/features/device_setup/domain/repositories/device_repository.dart';
import 'package:pos_app_ui/features/device_setup/domain/usecases/get_current_session.dart';
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
  DeviceSetupBloc build() => DeviceSetupBloc(RegisterDevice(repo), GetCurrentSession(repo));

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

  blocTest<DeviceSetupBloc, DeviceSetupState>(
    'submitted: trims and upper-cases input, then paired',
    setUp: () =>
        when(() => repo.register(storeCode: 'ST-0007', registrationCode: '483920', deviceName: 'POS-1'))
            .thenAnswer((_) async => Success(_session)),
    build: build,
    act: (b) => b.add(
      const DeviceSetupEvent.submitted(storeCode: ' st-0007 ', registrationCode: '483920 ', deviceName: ' POS-1'),
    ),
    expect: () => [const DeviceSetupState.submitting(), DeviceSetupState.paired(_session)],
  );

  const failure = Failure.server(
    statusCode: 422,
    code: 'VALIDATION_FAILED',
    message: 'Invalid or expired registration code.',
  );
  blocTest<DeviceSetupBloc, DeviceSetupState>(
    'submitted: failure is shown',
    setUp: () => when(
      () => repo.register(
        storeCode: any(named: 'storeCode'),
        registrationCode: any(named: 'registrationCode'),
        deviceName: any(named: 'deviceName'),
      ),
    ).thenAnswer((_) async => const Err(failure)),
    build: build,
    act: (b) => b.add(const DeviceSetupEvent.submitted(storeCode: 'X', registrationCode: '1', deviceName: 'P')),
    expect: () => [const DeviceSetupState.submitting(), const DeviceSetupState.failure(failure)],
  );
}
