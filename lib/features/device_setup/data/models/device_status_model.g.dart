// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeviceStatusModel _$DeviceStatusModelFromJson(Map<String, dynamic> json) => _DeviceStatusModel(
  deviceId: json['device_id'] as String,
  deviceCode: json['device_code'] as String,
  status: json['status'] as String,
  storeStatus: json['store_status'] as String,
  canSell: json['can_sell'] as bool,
  isGateway: json['is_gateway'] as bool,
  businessDate: json['business_date'] as String?,
  serverTime: json['server_time'] == null ? null : DateTime.parse(json['server_time'] as String),
  activation: json['activation'] == null
      ? null
      : DeviceActivationModel.fromJson(json['activation'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DeviceStatusModelToJson(_DeviceStatusModel instance) => <String, dynamic>{
  'device_id': instance.deviceId,
  'device_code': instance.deviceCode,
  'status': instance.status,
  'store_status': instance.storeStatus,
  'can_sell': instance.canSell,
  'is_gateway': instance.isGateway,
  'business_date': ?instance.businessDate,
  'server_time': ?instance.serverTime?.toIso8601String(),
  'activation': ?instance.activation?.toJson(),
};
