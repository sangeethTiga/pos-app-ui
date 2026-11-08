import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/core/config/app_config.dart';
import 'package:pos_app_ui/core/di/injection.dart';
import 'package:pos_app_ui/core/storage/secure_store.dart';
import 'package:pos_app_ui/features/device_setup/domain/repositories/device_repository.dart';
import 'package:pos_app_ui/features/device_setup/presentation/bloc/device_setup_bloc.dart';
import 'package:pos_app_ui/features/home/presentation/cubit/home_cubit.dart';

/// Resolves the real object graph, as main() does. Catches cycles and missing registrations.
void main() {
  setUp(() async {
    await sl.reset();
    await configureDependencies(
      config: const AppConfig(apiBaseUrl: 'http://pos.test/api/v1', appVersion: '1.0.0'),
      secureStore: MemorySecureStore(),
    );
  });

  tearDown(sl.reset);

  test('every registered type resolves (no circular dependency)', () async {
    expect(sl<DeviceRepository>(), isNotNull);
    expect(sl<DeviceSetupBloc>(), isNotNull);
    expect(sl<HomeCubit>(), isNotNull);
    expect(await sl<DeviceRepository>().currentSession(), isNull);
  });
}
