// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_registration_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoreModel _$StoreModelFromJson(Map<String, dynamic> json) => _StoreModel(
  id: json['id'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
  currency: json['currency'] as String,
  currencyDecimals: (json['currency_decimals'] as num).toInt(),
  timezone: json['timezone'] as String,
  businessDayCutoff: json['business_day_cutoff'] as String,
  pricesIncludeTax: json['prices_include_tax'] as bool,
);

Map<String, dynamic> _$StoreModelToJson(_StoreModel instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
  'currency': instance.currency,
  'currency_decimals': instance.currencyDecimals,
  'timezone': instance.timezone,
  'business_day_cutoff': instance.businessDayCutoff,
  'prices_include_tax': instance.pricesIncludeTax,
};

_DeviceProfileModel _$DeviceProfileModelFromJson(Map<String, dynamic> json) => _DeviceProfileModel(
  deviceType: json['device_type'] as String? ?? 'CASHIER',
  hardwareId: json['hardware_id'] as String?,
  kioskId: json['kiosk_id'] as String?,
  kioskName: json['kiosk_name'] as String?,
  settings:
      (json['settings'] as Map<String, dynamic>?)?.map((k, e) => MapEntry(k, e as bool)) ?? const <String, bool>{},
);

Map<String, dynamic> _$DeviceProfileModelToJson(_DeviceProfileModel instance) => <String, dynamic>{
  'device_type': instance.deviceType,
  'hardware_id': ?instance.hardwareId,
  'kiosk_id': ?instance.kioskId,
  'kiosk_name': ?instance.kioskName,
  'settings': instance.settings,
};

_DeviceRegistrationModel _$DeviceRegistrationModelFromJson(Map<String, dynamic> json) => _DeviceRegistrationModel(
  deviceId: json['device_id'] as String,
  deviceCode: json['device_code'] as String,
  tokenLetter: json['token_letter'] as String,
  gatewayPriority: (json['gateway_priority'] as num).toInt(),
  store: StoreModel.fromJson(json['store'] as Map<String, dynamic>),
  signingSecret: json['signing_secret'] as String,
  accessToken: json['access_token'] as String,
  accessTokenExpiresAt: DateTime.parse(json['access_token_expires_at'] as String),
  refreshToken: json['refresh_token'] as String,
  refreshTokenExpiresAt: DateTime.parse(json['refresh_token_expires_at'] as String),
  serverTime: json['server_time'] == null ? null : DateTime.parse(json['server_time'] as String),
  profile: json['profile'] == null ? null : DeviceProfileModel.fromJson(json['profile'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DeviceRegistrationModelToJson(_DeviceRegistrationModel instance) => <String, dynamic>{
  'device_id': instance.deviceId,
  'device_code': instance.deviceCode,
  'token_letter': instance.tokenLetter,
  'gateway_priority': instance.gatewayPriority,
  'store': instance.store.toJson(),
  'signing_secret': instance.signingSecret,
  'access_token': instance.accessToken,
  'access_token_expires_at': instance.accessTokenExpiresAt.toIso8601String(),
  'refresh_token': instance.refreshToken,
  'refresh_token_expires_at': instance.refreshTokenExpiresAt.toIso8601String(),
  'server_time': ?instance.serverTime?.toIso8601String(),
  'profile': ?instance.profile?.toJson(),
};
