import '../../../../core/utils/result.dart';
import '../activation_policy.dart';
import '../entities/device_session.dart';
import '../repositories/device_repository.dart';

/// A complete activation code gives the store and its kiosks (the code is not used up).
class PreviewSetup {
  const PreviewSetup(this._repository);

  final DeviceRepository _repository;

  Future<Result<SetupPreview>> call(String code) => _repository.preview(ActivationCode.format(code));
}
