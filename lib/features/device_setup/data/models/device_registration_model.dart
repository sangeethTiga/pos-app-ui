import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/device_session.dart';

part 'device_registration_model.freezed.dart';
part 'device_registration_model.g.dart';

@freezed
abstract class StoreModel with _$StoreModel {
  const StoreModel._();

  const factory StoreModel({
    required String id,
    required String code,
    required String name,
    required String currency,
    required int currencyDecimals,
    required String timezone,
    required String businessDayCutoff,
    required bool pricesIncludeTax,
  }) = _StoreModel;

  factory StoreModel.fromJson(Map<String, dynamic> json) => _$StoreModelFromJson(json);

  StoreInfo toEntity() => StoreInfo(
    id: id,
    code: code,
    name: name,
    currency: currency,
    currencyDecimals: currencyDecimals,
    timezone: timezone,
    businessDayCutoff: businessDayCutoff,
    pricesIncludeTax: pricesIncludeTax,
  );
}

/// `profile` of `POST /devices/setup` and `GET /devices/me`.
@freezed
abstract class DeviceProfileModel with _$DeviceProfileModel {
  const DeviceProfileModel._();

  const factory DeviceProfileModel({
    @Default('CASHIER') String deviceType,
    String? hardwareId,
    String? kioskId,
    String? kioskName,
    @Default(<String, bool>{}) Map<String, bool> settings,
  }) = _DeviceProfileModel;

  factory DeviceProfileModel.fromJson(Map<String, dynamic> json) => _$DeviceProfileModelFromJson(json);

  DeviceProfile toEntity() => DeviceProfile(
    deviceType: DeviceType.fromWire(deviceType),
    hardwareId: hardwareId,
    kioskId: kioskId,
    kioskName: kioskName,
    kioskWiseOrderListing: settings['kiosk_wise_order_listing'] ?? false,
    deliveryManagerPos: settings['delivery_manager_pos'] ?? false,
    settleAssignedOrdersOnly: settings['settle_assigned_orders_only'] ?? false,
  );
}

/// `201` body of `POST /devices/setup` (its `activation` block is read separately). Also the format kept
/// in secure storage.
@freezed
abstract class DeviceRegistrationModel with _$DeviceRegistrationModel {
  const DeviceRegistrationModel._();

  const factory DeviceRegistrationModel({
    required String deviceId,
    required String deviceCode,
    required String tokenLetter,
    required int gatewayPriority,
    required StoreModel store,
    required String signingSecret,
    required String accessToken,
    required DateTime accessTokenExpiresAt,
    required String refreshToken,
    required DateTime refreshTokenExpiresAt,
    DateTime? serverTime,

    /// Missing in sessions stored before the setup screen had roles: cashier.
    DeviceProfileModel? profile,
  }) = _DeviceRegistrationModel;

  factory DeviceRegistrationModel.fromJson(Map<String, dynamic> json) => _$DeviceRegistrationModelFromJson(json);

  DeviceSession toEntity() => DeviceSession(
    deviceId: deviceId,
    deviceCode: deviceCode,
    tokenLetter: tokenLetter,
    gatewayPriority: gatewayPriority,
    store: store.toEntity(),
    accessToken: accessToken,
    accessTokenExpiresAt: accessTokenExpiresAt,
    refreshToken: refreshToken,
    refreshTokenExpiresAt: refreshTokenExpiresAt,
    signingSecret: signingSecret,
    profile: profile?.toEntity() ?? const DeviceProfile(),
  );
}
