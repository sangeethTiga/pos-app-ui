import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_activation.freezed.dart';

/// Platform activation status of this terminal (`activation.status`).
enum ActivationStatus {
  inactive,
  active,
  scheduled,
  suspended,
  expired,
  revoked;

  String get wire => name.toUpperCase();

  /// Unknown values count as not activated.
  static ActivationStatus fromWire(String? v) =>
      values.firstWhere((s) => s.wire == v?.toUpperCase(), orElse: () => inactive);
}

/// Activation block of `GET /devices/activation`, `POST /devices/activate`, heartbeat / `GET /devices/me`
/// and the `device.activation` WebSocket event. Only [valid] lets the terminal take new orders.
@freezed
abstract class DeviceActivation with _$DeviceActivation {
  const factory DeviceActivation({
    String? deviceId,
    String? storeId,
    @Default(ActivationStatus.inactive) ActivationStatus status,
    @Default(false) bool valid,
    DateTime? startsAt,
    DateTime? expiresAt,
    int? remainingDays,
    String? activationId,
  }) = _DeviceActivation;
}

/// Last known activation plus what is needed to judge it offline.
@freezed
abstract class ActivationSnapshot with _$ActivationSnapshot {
  const factory ActivationSnapshot({
    required DeviceActivation activation,

    /// server clock - device clock, from the last response that carried the server time.
    @Default(Duration.zero) Duration clockOffset,

    /// Latest server time seen: "now" never goes back before it (device clock turned back).
    DateTime? lastServerTime,

    /// Device time when [activation] was received.
    required DateTime receivedAt,
  }) = _ActivationSnapshot;
}

/// Why new orders are blocked.
enum ActivationBlock { notActivated, scheduled, expired, suspended, revoked }

/// Result of judging an [ActivationSnapshot] at a moment.
@freezed
abstract class ActivationVerdict with _$ActivationVerdict {
  const ActivationVerdict._();

  const factory ActivationVerdict({
    /// null: the terminal may take new orders.
    ActivationBlock? block,

    /// Whole days left (rounded up, as the server counts them); null without an expiry.
    int? remainingDays,
    DateTime? startsAt,
    DateTime? expiresAt,
  }) = _ActivationVerdict;

  /// No activation known yet (fresh registration, nothing stored): blocked.
  static const unknown = ActivationVerdict(block: ActivationBlock.notActivated);

  bool get canSell => block == null;

  /// Valid but ending within a week: show the non-blocking warning.
  bool get expiresSoon => canSell && remainingDays != null && remainingDays! <= 7;
}
