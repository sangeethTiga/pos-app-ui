// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_activation_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeviceActivationModel _$DeviceActivationModelFromJson(Map<String, dynamic> json) => _DeviceActivationModel(
  deviceId: json['device_id'] as String?,
  storeId: json['store_id'] as String?,
  status: json['status'] as String? ?? 'INACTIVE',
  valid: json['valid'] as bool? ?? false,
  startsAt: json['starts_at'] == null ? null : DateTime.parse(json['starts_at'] as String),
  expiresAt: json['expires_at'] == null ? null : DateTime.parse(json['expires_at'] as String),
  remainingDays: (json['remaining_days'] as num?)?.toInt(),
  activationId: json['activation_id'] as String?,
);

Map<String, dynamic> _$DeviceActivationModelToJson(_DeviceActivationModel instance) => <String, dynamic>{
  'device_id': ?instance.deviceId,
  'store_id': ?instance.storeId,
  'status': instance.status,
  'valid': instance.valid,
  'starts_at': ?instance.startsAt?.toIso8601String(),
  'expires_at': ?instance.expiresAt?.toIso8601String(),
  'remaining_days': ?instance.remainingDays,
  'activation_id': ?instance.activationId,
};

_ActivateDeviceResponseModel _$ActivateDeviceResponseModelFromJson(Map<String, dynamic> json) =>
    _ActivateDeviceResponseModel(
      deviceId: json['device_id'] as String?,
      activation: DeviceActivationModel.fromJson(json['activation'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ActivateDeviceResponseModelToJson(_ActivateDeviceResponseModel instance) => <String, dynamic>{
  'device_id': ?instance.deviceId,
  'activation': instance.activation.toJson(),
};

_ActivationSnapshotModel _$ActivationSnapshotModelFromJson(Map<String, dynamic> json) => _ActivationSnapshotModel(
  activation: DeviceActivationModel.fromJson(json['activation'] as Map<String, dynamic>),
  clockOffsetMs: (json['clock_offset_ms'] as num?)?.toInt() ?? 0,
  lastServerTime: json['last_server_time'] == null ? null : DateTime.parse(json['last_server_time'] as String),
  receivedAt: DateTime.parse(json['received_at'] as String),
);

Map<String, dynamic> _$ActivationSnapshotModelToJson(_ActivationSnapshotModel instance) => <String, dynamic>{
  'activation': instance.activation.toJson(),
  'clock_offset_ms': instance.clockOffsetMs,
  'last_server_time': ?instance.lastServerTime?.toIso8601String(),
  'received_at': instance.receivedAt.toIso8601String(),
};
