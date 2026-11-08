import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_session.freezed.dart';

/// The store this terminal is paired with.
@freezed
abstract class StoreInfo with _$StoreInfo {
  const factory StoreInfo({
    required String id,
    required String code,
    required String name,
    required String currency,
    required int currencyDecimals,
    required String timezone,
    required String businessDayCutoff,
    required bool pricesIncludeTax,
  }) = _StoreInfo;
}

/// Role of this terminal, chosen at registration.
enum DeviceType {
  /// Billing terminal: opens shifts, takes payments.
  cashier,

  /// Waiter device: takes orders, no cash drawer.
  captain;

  String get wire => name.toUpperCase();
  String get label => wire;

  static DeviceType fromWire(String? v) => v == 'CAPTAIN' ? captain : cashier;
}

/// Role and screen settings chosen on the registration screen.
@freezed
abstract class DeviceProfile with _$DeviceProfile {
  const factory DeviceProfile({
    @Default(DeviceType.cashier) DeviceType deviceType,

    /// This terminal's own id (shown with a copy button on the registration screen).
    String? hardwareId,
    String? kioskId,
    String? kioskName,
    @Default(false) bool kioskWiseOrderListing,
    @Default(false) bool deliveryManagerPos,
    @Default(false) bool settleAssignedOrdersOnly,
  }) = _DeviceProfile;
}

@freezed
abstract class KioskOption with _$KioskOption {
  const factory KioskOption({required String id, required String name}) = _KioskOption;
}

/// `POST /devices/register/preview`: the store behind the codes and its kiosks.
@freezed
abstract class RegistrationPreview with _$RegistrationPreview {
  const factory RegistrationPreview({
    required String storeId,
    required String storeCode,
    required String storeName,
    @Default(<KioskOption>[]) List<KioskOption> kiosks,

    /// The code re-pairs an existing terminal (same P-code).
    @Default(false) bool rePair,

    /// This terminal's own id.
    required String hardwareId,
  }) = _RegistrationPreview;
}

/// A paired terminal: identity, store and credentials.
@freezed
abstract class DeviceSession with _$DeviceSession {
  const DeviceSession._();

  const factory DeviceSession({
    required String deviceId,

    /// Origin of every change this terminal writes (P1, P2 ...) and its bill-number prefix.
    required String deviceCode,
    required String tokenLetter,
    required int gatewayPriority,
    required StoreInfo store,
    required String accessToken,
    required DateTime accessTokenExpiresAt,
    required String refreshToken,
    required DateTime refreshTokenExpiresAt,
    required String signingSecret,
    @Default(DeviceProfile()) DeviceProfile profile,
  }) = _DeviceSession;

  bool get accessTokenExpired =>
      DateTime.now().toUtc().isAfter(accessTokenExpiresAt.subtract(const Duration(minutes: 1)));
}

/// Live status returned by `GET /devices/me`.
@freezed
abstract class DeviceStatus with _$DeviceStatus {
  const factory DeviceStatus({
    required String deviceCode,
    required String status,
    required String storeStatus,
    required bool canSell,
    required bool isGateway,
    String? businessDate,
    DateTime? serverTime,
  }) = _DeviceStatus;
}
