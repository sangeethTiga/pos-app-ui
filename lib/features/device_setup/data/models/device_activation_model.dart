import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/device_activation.dart';

part 'device_activation_model.freezed.dart';
part 'device_activation_model.g.dart';

/// Activation block: body of `GET /devices/activation`, `activation` of `POST /devices/activate` and
/// `POST /devices/setup`,
/// heartbeat / `GET /devices/me` and the `device.activation` WebSocket event. Times are UTC ISO.
@freezed
abstract class DeviceActivationModel with _$DeviceActivationModel {
  const DeviceActivationModel._();

  const factory DeviceActivationModel({
    String? deviceId,
    String? storeId,
    @Default('INACTIVE') String status,
    @Default(false) bool valid,
    DateTime? startsAt,
    DateTime? expiresAt,
    int? remainingDays,
    String? activationId,
  }) = _DeviceActivationModel;

  factory DeviceActivationModel.fromJson(Map<String, dynamic> json) => _$DeviceActivationModelFromJson(json);

  factory DeviceActivationModel.fromEntity(DeviceActivation a) => DeviceActivationModel(
    deviceId: a.deviceId,
    storeId: a.storeId,
    status: a.status.wire,
    valid: a.valid,
    startsAt: a.startsAt,
    expiresAt: a.expiresAt,
    remainingDays: a.remainingDays,
    activationId: a.activationId,
  );

  DeviceActivation toEntity() => DeviceActivation(
    deviceId: deviceId,
    storeId: storeId,
    status: ActivationStatus.fromWire(status),
    valid: valid,
    startsAt: startsAt?.toUtc(),
    expiresAt: expiresAt?.toUtc(),
    remainingDays: remainingDays,
    activationId: activationId,
  );
}

/// `200` body of `POST /devices/activate`.
@freezed
abstract class ActivateDeviceResponseModel with _$ActivateDeviceResponseModel {
  const factory ActivateDeviceResponseModel({String? deviceId, required DeviceActivationModel activation}) =
      _ActivateDeviceResponseModel;

  factory ActivateDeviceResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ActivateDeviceResponseModelFromJson(json);
}

/// What is kept in secure storage so the activation is enforced offline.
@freezed
abstract class ActivationSnapshotModel with _$ActivationSnapshotModel {
  const ActivationSnapshotModel._();

  const factory ActivationSnapshotModel({
    required DeviceActivationModel activation,
    @Default(0) int clockOffsetMs,
    DateTime? lastServerTime,
    required DateTime receivedAt,
  }) = _ActivationSnapshotModel;

  factory ActivationSnapshotModel.fromJson(Map<String, dynamic> json) => _$ActivationSnapshotModelFromJson(json);

  factory ActivationSnapshotModel.fromEntity(ActivationSnapshot s) => ActivationSnapshotModel(
    activation: DeviceActivationModel.fromEntity(s.activation),
    clockOffsetMs: s.clockOffset.inMilliseconds,
    lastServerTime: s.lastServerTime,
    receivedAt: s.receivedAt,
  );

  ActivationSnapshot toEntity() => ActivationSnapshot(
    activation: activation.toEntity(),
    clockOffset: Duration(milliseconds: clockOffsetMs),
    lastServerTime: lastServerTime?.toUtc(),
    receivedAt: receivedAt.toUtc(),
  );
}
