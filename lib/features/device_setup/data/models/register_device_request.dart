import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_device_request.freezed.dart';
part 'register_device_request.g.dart';

/// Body of `POST /devices/register`.
@freezed
abstract class RegisterDeviceRequest with _$RegisterDeviceRequest {
  const factory RegisterDeviceRequest({
    required String storeCode,
    required String registrationCode,
    required String deviceName,

    /// `windows` or `android`.
    required String platform,
    required String appVersion,
    int? gatewayPriority,

    /// `CASHIER` or `CAPTAIN`.
    String? deviceType,
    String? hardwareId,
    String? kioskId,

    /// kiosk_wise_order_listing, delivery_manager_pos, settle_assigned_orders_only.
    Map<String, bool>? settings,
  }) = _RegisterDeviceRequest;

  factory RegisterDeviceRequest.fromJson(Map<String, dynamic> json) => _$RegisterDeviceRequestFromJson(json);
}
