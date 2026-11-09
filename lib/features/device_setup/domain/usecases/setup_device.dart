import '../../../../core/utils/result.dart';
import '../activation_policy.dart';
import '../entities/device_session.dart';
import '../repositories/device_repository.dart';

/// Pairs and activates this terminal with one activation code.
class SetupDevice {
  const SetupDevice(this._repository);

  final DeviceRepository _repository;

  Future<Result<DeviceSession>> call({
    required String code,
    required String deviceName,
    DeviceProfile profile = const DeviceProfile(),
  }) => _repository.setup(code: ActivationCode.format(code), deviceName: deviceName.trim(), profile: profile);
}
