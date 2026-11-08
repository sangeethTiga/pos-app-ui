import '../../../../core/utils/result.dart';
import '../entities/device_session.dart';
import '../repositories/device_repository.dart';

class RegisterDevice {
  const RegisterDevice(this._repository);

  final DeviceRepository _repository;

  Future<Result<DeviceSession>> call({
    required String storeCode,
    required String registrationCode,
    required String deviceName,
    DeviceProfile profile = const DeviceProfile(),
  }) => _repository.register(
    storeCode: storeCode.trim().toUpperCase(),
    registrationCode: registrationCode.trim(),
    deviceName: deviceName.trim(),
    profile: profile,
  );
}
