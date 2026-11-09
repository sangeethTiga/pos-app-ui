import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/device_session.dart';

part 'device_setup_models.freezed.dart';
part 'device_setup_models.g.dart';

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

/// `device` of the preview: the terminal a re-pair code belongs to.
@freezed
abstract class PreviewDeviceModel with _$PreviewDeviceModel {
  const factory PreviewDeviceModel({required String id, String? code, String? name}) = _PreviewDeviceModel;

  factory PreviewDeviceModel.fromJson(Map<String, dynamic> json) => _$PreviewDeviceModelFromJson(json);
}

/// `200` body of `POST /devices/setup/preview`.
@freezed
abstract class SetupPreviewModel with _$SetupPreviewModel {
  const SetupPreviewModel._();

  const factory SetupPreviewModel({
    required PreviewStoreModel store,
    @Default(<KioskModel>[]) List<KioskModel> kiosks,
    @Default(<String>[]) List<String> deviceTypes,
    @Default(false) bool rePair,
    PreviewDeviceModel? device,
  }) = _SetupPreviewModel;

  factory SetupPreviewModel.fromJson(Map<String, dynamic> json) => _$SetupPreviewModelFromJson(json);

  SetupPreview toEntity() => SetupPreview(
    storeId: store.id,
    storeCode: store.code,
    storeName: store.name,
    kiosks: [for (final k in kiosks) KioskOption(id: k.id, name: k.name)],
    deviceTypes: [for (final t in deviceTypes) DeviceType.fromWire(t)],
    rePair: rePair,
    deviceCode: device?.code,
    deviceName: device?.name,
  );
}

/// Body of `POST /devices/setup`: pairs and activates the terminal with one activation code.
@freezed
abstract class SetupDeviceRequest with _$SetupDeviceRequest {
  const factory SetupDeviceRequest({
    /// Activation code, XXXX-XXXX-XXXX.
    required String code,
    required String deviceName,

    /// `windows` or `android`.
    required String platform,
    required String appVersion,

    /// `CASHIER` or `CAPTAIN`.
    String? deviceType,
    String? hardwareId,
    String? kioskId,

    /// kiosk_wise_order_listing, delivery_manager_pos, settle_assigned_orders_only.
    Map<String, bool>? settings,
  }) = _SetupDeviceRequest;

  factory SetupDeviceRequest.fromJson(Map<String, dynamic> json) => _$SetupDeviceRequestFromJson(json);
}
