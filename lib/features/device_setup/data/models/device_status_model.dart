import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/device_session.dart';

part 'device_status_model.freezed.dart';
part 'device_status_model.g.dart';

/// Body of `GET /devices/me`.
@freezed
abstract class DeviceStatusModel with _$DeviceStatusModel {
  const DeviceStatusModel._();

  const factory DeviceStatusModel({
    required String deviceId,
    required String deviceCode,
    required String status,
    required String storeStatus,
    required bool canSell,
    required bool isGateway,
    String? businessDate,
    DateTime? serverTime,
  }) = _DeviceStatusModel;

  factory DeviceStatusModel.fromJson(Map<String, dynamic> json) => _$DeviceStatusModelFromJson(json);

  DeviceStatus toEntity() => DeviceStatus(
    deviceCode: deviceCode,
    status: status,
    storeStatus: storeStatus,
    canSell: canSell,
    isGateway: isGateway,
    businessDate: businessDate,
    serverTime: serverTime,
  );
}
