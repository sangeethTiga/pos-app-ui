// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_preview_model.dart';

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

_RegistrationPreviewModel _$RegistrationPreviewModelFromJson(Map<String, dynamic> json) => _RegistrationPreviewModel(
  store: PreviewStoreModel.fromJson(json['store'] as Map<String, dynamic>),
  kiosks:
      (json['kiosks'] as List<dynamic>?)?.map((e) => KioskModel.fromJson(e as Map<String, dynamic>)).toList() ??
      const <KioskModel>[],
  rePair: json['re_pair'] as bool? ?? false,
);

Map<String, dynamic> _$RegistrationPreviewModelToJson(_RegistrationPreviewModel instance) => <String, dynamic>{
  'store': instance.store.toJson(),
  'kiosks': instance.kiosks.map((e) => e.toJson()).toList(),
  're_pair': instance.rePair,
};
