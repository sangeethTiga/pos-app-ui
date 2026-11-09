import '../../../../core/utils/result.dart';
import '../entities/device_activation.dart';
import '../entities/device_session.dart';

/// Platform activation of this terminal: server calls plus the copy kept on the device for offline
/// enforcement. Every activation received (any endpoint, WebSocket) goes through [record] and is
/// announced on [changes].
abstract interface class ActivationRepository {
  /// Every stored activation, whichever call or event brought it.
  Stream<ActivationSnapshot> get changes;

  /// Last stored activation, or null when none was ever received.
  Future<ActivationSnapshot?> cached();

  /// Signed `GET /devices/activation`.
  Future<Result<ActivationSnapshot>> fetch();

  /// Signed `POST /devices/activate` with a code (normalised to XXXX-XXXX-XXXX).
  Future<Result<ActivationSnapshot>> activate(String code);

  /// Signed `POST /devices/heartbeat`; stores the activation it reports.
  Future<Result<DeviceStatus>> heartbeat();

  /// `device.activation` WebSocket payload `{event_id, device_id, activation}`: stored when it is for
  /// [deviceId], otherwise ignored (null).
  Future<ActivationSnapshot?> recordPushed(Map<String, dynamic> payload, {required String deviceId});

  /// Stores [activation]; [serverTime] (when known) updates the clock offset.
  Future<ActivationSnapshot> record(DeviceActivation activation, {DateTime? serverTime});
}
