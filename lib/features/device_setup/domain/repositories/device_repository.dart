import '../../../../core/utils/result.dart';
import '../entities/device_session.dart';

abstract interface class DeviceRepository {
  /// Pair this terminal with a store using a one-time registration code from the admin panel.
  Future<Result<DeviceSession>> register({
    required String storeCode,
    required String registrationCode,
    required String deviceName,
  });

  /// Stored session, or `null` when the terminal is not paired.
  Future<DeviceSession?> currentSession();

  /// Signed `GET /devices/me`: proves the credentials and the signature work.
  Future<Result<DeviceStatus>> status();

  /// Forget the credentials on this terminal (re-pairing needs a new code).
  Future<void> unpair();
}
