import '../../../../core/utils/result.dart';
import '../entities/device_session.dart';

abstract interface class DeviceRepository {
  /// Check an activation code (not used up) and get the store name and its kiosks.
  Future<Result<SetupPreview>> preview(String code);

  /// Pair AND activate this terminal with one activation code from the platform administrator. Stores
  /// the credentials and the activation that comes with them.
  /// [profile]: role, kiosk and delivery-manager flags ([DeviceProfile.kioskName] is ignored).
  Future<Result<DeviceSession>> setup({
    required String code,
    required String deviceName,
    DeviceProfile profile = const DeviceProfile(),
  });

  /// This terminal's own id (kept across re-pairing).
  Future<String> hardwareId();

  /// Stored session, or `null` when the terminal is not paired.
  Future<DeviceSession?> currentSession();

  /// Signed `GET /devices/me`: proves the credentials and the signature work.
  Future<Result<DeviceStatus>> status();

  /// Forget the credentials on this terminal (re-pairing needs a new code).
  Future<void> unpair();
}
