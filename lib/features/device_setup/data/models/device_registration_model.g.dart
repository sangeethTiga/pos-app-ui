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
};
