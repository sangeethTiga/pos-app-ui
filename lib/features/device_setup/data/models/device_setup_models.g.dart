// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_setup_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PreviewStoreModel _$PreviewStoreModelFromJson(Map<String, dynamic> json) =>
    _PreviewStoreModel(id: json['id'] as String, code: json['code'] as String, name: json['name'] as String);

Map<String, dynamic> _$PreviewStoreModelToJson(_PreviewStoreModel instance) => <String, dynamic>{
  'id': instance.id,
  'code': instance.code,
  'name': instance.name,
};

_KioskModel _$KioskModelFromJson(Map<String, dynamic> json) =>
    _KioskModel(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$KioskModelToJson(_KioskModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};

_PreviewDeviceModel _$PreviewDeviceModelFromJson(Map<String, dynamic> json) =>
    _PreviewDeviceModel(id: json['id'] as String, code: json['code'] as String?, name: json['name'] as String?);

Map<String, dynamic> _$PreviewDeviceModelToJson(_PreviewDeviceModel instance) => <String, dynamic>{
  'id': instance.id,
  'code': ?instance.code,
  'name': ?instance.name,
};

_SetupPreviewModel _$SetupPreviewModelFromJson(Map<String, dynamic> json) => _SetupPreviewModel(
  store: PreviewStoreModel.fromJson(json['store'] as Map<String, dynamic>),
  kiosks:
      (json['kiosks'] as List<dynamic>?)?.map((e) => KioskModel.fromJson(e as Map<String, dynamic>)).toList() ??
      const <KioskModel>[],
  deviceTypes: (json['device_types'] as List<dynamic>?)?.map((e) => e as String).toList() ?? const <String>[],
  rePair: json['re_pair'] as bool? ?? false,
  device: json['device'] == null ? null : PreviewDeviceModel.fromJson(json['device'] as Map<String, dynamic>),
);

Map<String, dynamic> _$SetupPreviewModelToJson(_SetupPreviewModel instance) => <String, dynamic>{
  'store': instance.store.toJson(),
  'kiosks': instance.kiosks.map((e) => e.toJson()).toList(),
  'device_types': instance.deviceTypes,
  're_pair': instance.rePair,
  'device': ?instance.device?.toJson(),
};

_SetupDeviceRequest _$SetupDeviceRequestFromJson(Map<String, dynamic> json) => _SetupDeviceRequest(
  code: json['code'] as String,
  deviceName: json['device_name'] as String,
  platform: json['platform'] as String,
  appVersion: json['app_version'] as String,
  deviceType: json['device_type'] as String?,
  hardwareId: json['hardware_id'] as String?,
  kioskId: json['kiosk_id'] as String?,
  settings: (json['settings'] as Map<String, dynamic>?)?.map((k, e) => MapEntry(k, e as bool)),
);

Map<String, dynamic> _$SetupDeviceRequestToJson(_SetupDeviceRequest instance) => <String, dynamic>{
  'code': instance.code,
  'device_name': instance.deviceName,
  'platform': instance.platform,
  'app_version': instance.appVersion,
  'device_type': ?instance.deviceType,
  'hardware_id': ?instance.hardwareId,
  'kiosk_id': ?instance.kioskId,
  'settings': ?instance.settings,
};
