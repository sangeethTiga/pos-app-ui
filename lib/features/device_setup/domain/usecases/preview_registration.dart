import '../../../../core/utils/result.dart';
import '../entities/device_session.dart';
import '../repositories/device_repository.dart';

/// Step 1 of registration: store code + registration code give the store and its kiosks.
class PreviewRegistration {
  const PreviewRegistration(this._repository);

  final DeviceRepository _repository;

  Future<Result<RegistrationPreview>> call({required String storeCode, required String registrationCode}) =>
      _repository.preview(storeCode: storeCode.trim().toUpperCase(), registrationCode: registrationCode.trim());
}
