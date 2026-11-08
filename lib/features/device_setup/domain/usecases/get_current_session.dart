import '../entities/device_session.dart';
import '../repositories/device_repository.dart';

class GetCurrentSession {
  const GetCurrentSession(this._repository);

  final DeviceRepository _repository;

  Future<DeviceSession?> call() => _repository.currentSession();
}
