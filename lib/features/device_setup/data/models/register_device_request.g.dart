// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_device_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RegisterDeviceRequest _$RegisterDeviceRequestFromJson(Map<String, dynamic> json) => _RegisterDeviceRequest(
  storeCode: json['store_code'] as String,
  registrationCode: json['registration_code'] as String,
  deviceName: json['device_name'] as String,
  platform: json['platform'] as String,
  appVersion: json['app_version'] as String,
  gatewayPriority: (json['gateway_priority'] as num?)?.toInt(),
);

Map<String, dynamic> _$RegisterDeviceRequestToJson(_RegisterDeviceRequest instance) => <String, dynamic>{
  'store_code': instance.storeCode,
  'registration_code': instance.registrationCode,
  'device_name': instance.deviceName,
  'platform': instance.platform,
  'app_version': instance.appVersion,
  'gateway_priority': ?instance.gatewayPriority,
};
