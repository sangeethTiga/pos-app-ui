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
