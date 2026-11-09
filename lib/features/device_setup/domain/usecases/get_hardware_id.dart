import '../repositories/device_repository.dart';

/// This terminal's own id (shown with a copy button on the setup screen).
class GetHardwareId {
  const GetHardwareId(this._repository);

  final DeviceRepository _repository;

  Future<String> call() => _repository.hardwareId();
}
