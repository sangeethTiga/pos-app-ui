import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/device_session.dart';

part 'registration_preview_model.freezed.dart';
part 'registration_preview_model.g.dart';

@freezed
abstract class PreviewStoreModel with _$PreviewStoreModel {
  const factory PreviewStoreModel({required String id, required String code, required String name}) =
      _PreviewStoreModel;

  factory PreviewStoreModel.fromJson(Map<String, dynamic> json) => _$PreviewStoreModelFromJson(json);
}

@freezed
abstract class KioskModel with _$KioskModel {
  const factory KioskModel({required String id, required String name}) = _KioskModel;

  factory KioskModel.fromJson(Map<String, dynamic> json) => _$KioskModelFromJson(json);
}

/// `200` body of `POST /devices/register/preview`.
@freezed
abstract class RegistrationPreviewModel with _$RegistrationPreviewModel {
  const RegistrationPreviewModel._();

  const factory RegistrationPreviewModel({
    required PreviewStoreModel store,
    @Default(<KioskModel>[]) List<KioskModel> kiosks,
    @Default(false) bool rePair,
  }) = _RegistrationPreviewModel;

  factory RegistrationPreviewModel.fromJson(Map<String, dynamic> json) => _$RegistrationPreviewModelFromJson(json);

  RegistrationPreview toEntity(String hardwareId) => RegistrationPreview(
    storeId: store.id,
    storeCode: store.code,
    storeName: store.name,
    kiosks: [for (final k in kiosks) KioskOption(id: k.id, name: k.name)],
    rePair: rePair,
    hardwareId: hardwareId,
  );
}
