import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/result.dart';
import '../../domain/activation_policy.dart';
import '../../domain/entities/device_session.dart';
import '../../domain/repositories/activation_repository.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/device_local_data_source.dart';
import '../datasources/device_remote_data_source.dart';
import '../models/device_setup_models.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  DeviceRepositoryImpl(this._remote, this._local, this._config, {String? platform, this._activations})
    : _platform = platform ?? (defaultTargetPlatform == TargetPlatform.android ? 'android' : 'windows');

  final DeviceRemoteDataSource _remote;
  final DeviceLocalDataSource _local;
  final AppConfig _config;
  final String _platform;

  /// Receives the `activation` block of `POST /devices/setup` and `GET /devices/me`.
  final ActivationRepository? _activations;

  @override
  Future<Result<SetupPreview>> preview(String code) async {
    try {
      return Success((await _remote.previewSetup(ActivationCode.format(code))).toEntity());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    }
  }

  @override
  Future<Result<DeviceSession>> setup({
    required String code,
    required String deviceName,
    DeviceProfile profile = const DeviceProfile(),
  }) async {
    try {
      final res = await _remote.setup(
        SetupDeviceRequest(
          code: ActivationCode.format(code),
          deviceName: deviceName,
          platform: _platform,
          appVersion: _config.appVersion,
          deviceType: profile.deviceType.wire,
          hardwareId: profile.hardwareId ?? await _local.hardwareId(),
          kioskId: profile.kioskId,
          settings: {
            'kiosk_wise_order_listing': profile.kioskId != null && profile.kioskWiseOrderListing,
            'delivery_manager_pos': profile.deliveryManagerPos,
            'settle_assigned_orders_only': profile.deliveryManagerPos && profile.settleAssignedOrdersOnly,
          },
        ),
      );
      try {
        await _local.save(res.device);
      } on Object catch (e) {
        // Paired on the server but the credentials could not be stored: the code is used up.
        return Err(Failure.unexpected(message: 'Could not save the terminal credentials ($e). Ask for a new code.'));
      }
      // Activated in the same call: stored now, so the sell gate needs no extra round trip.
      if (res.activation case final a?) {
        await _activations?.record(
          a.toEntity().copyWith(deviceId: a.deviceId ?? res.device.deviceId),
          serverTime: res.serverTime,
        );
      }
      return Success(res.device.toEntity());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    }
  }

  @override
  Future<String> hardwareId() => _local.hardwareId();

  @override
  Future<DeviceSession?> currentSession() async => (await _local.read())?.toEntity();

  @override
  Future<Result<DeviceStatus>> status() async {
    try {
      final status = (await _remote.me()).toEntity();
      if (status.activation case final a?) await _activations?.record(a, serverTime: status.serverTime);
      return Success(status);
    } on DioException catch (e) {
      return Err(mapDioError(e));
    }
  }

  @override
  Future<void> unpair() => _local.clear();
}
