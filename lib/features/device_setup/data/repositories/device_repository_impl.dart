import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/device_session.dart';
import '../../domain/repositories/activation_repository.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/device_local_data_source.dart';
import '../datasources/device_remote_data_source.dart';
import '../models/register_device_request.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  DeviceRepositoryImpl(this._remote, this._local, this._config, {String? platform, this._activations})
    : _platform = platform ?? (defaultTargetPlatform == TargetPlatform.android ? 'android' : 'windows');

  final DeviceRemoteDataSource _remote;
  final DeviceLocalDataSource _local;
  final AppConfig _config;
  final String _platform;

  /// Receives the `activation` block of `GET /devices/me`.
  final ActivationRepository? _activations;

  @override
  Future<Result<RegistrationPreview>> preview({required String storeCode, required String registrationCode}) async {
    try {
      final model = await _remote.preview(storeCode: storeCode, registrationCode: registrationCode);
      return Success(model.toEntity(await _local.hardwareId()));
    } on DioException catch (e) {
      return Err(mapDioError(e));
    }
  }

  @override
  Future<Result<DeviceSession>> register({
    required String storeCode,
    required String registrationCode,
    required String deviceName,
    DeviceProfile profile = const DeviceProfile(),
  }) async {
    try {
      final model = await _remote.register(
        RegisterDeviceRequest(
          storeCode: storeCode,
          registrationCode: registrationCode,
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
        await _local.save(model);
      } on Object catch (e) {
        // Paired on the server but the credentials could not be stored: the code is used up.
        return Err(Failure.unexpected(message: 'Could not save the terminal credentials ($e). Ask for a new code.'));
      }
      return Success(model.toEntity());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    }
  }

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
