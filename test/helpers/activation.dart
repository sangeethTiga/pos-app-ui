import 'package:pos_app_ui/core/di/injection.dart';
import 'package:pos_app_ui/features/device_setup/domain/entities/device_activation.dart';
import 'package:pos_app_ui/features/device_setup/domain/repositories/activation_repository.dart';
import 'package:pos_app_ui/features/device_setup/presentation/cubit/activation_cubit.dart';

/// Marks the terminal of the configured DI graph as activated for a year (the sell screen and new
/// orders need it). Call after `configureDependencies`.
Future<void> activateTerminal({Duration validFor = const Duration(days: 365)}) async {
  final now = DateTime.now().toUtc();
  await sl<ActivationRepository>().record(
    DeviceActivation(
      deviceId: 'd1',
      status: ActivationStatus.active,
      valid: true,
      startsAt: now.subtract(const Duration(days: 1)),
      expiresAt: now.add(validFor),
    ),
  );
  await sl<ActivationCubit>().load();
}
