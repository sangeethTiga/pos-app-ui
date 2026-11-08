import '../../../../core/utils/result.dart';
import '../entities/device_session.dart';

abstract interface class DeviceRepository {
  /// Check store code + registration code (not used up) and get the store name and kiosks.
  Future<Result<RegistrationPreview>> preview({required String storeCode, required String registrationCode});

  /// Pair this terminal with a store using a one-time registration code from the admin panel.
  /// [profile]: role, kiosk and delivery-manager flags ([DeviceProfile.kioskName] is ignored).
  Future<Result<DeviceSession>> register({
    required String storeCode,
    required String registrationCode,
    required String deviceName,
    DeviceProfile profile = const DeviceProfile(),
  });

  /// Stored session, or `null` when the terminal is not paired.
  Future<DeviceSession?> currentSession();

  /// Signed `GET /devices/me`: proves the credentials and the signature work.
  Future<Result<DeviceStatus>> status();

  /// Forget the credentials on this terminal (re-pairing needs a new code).
  Future<void> unpair();
}
