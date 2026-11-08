import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/device_session.dart';
import '../../domain/repositories/device_repository.dart';
import '../datasources/device_local_data_source.dart';
import '../datasources/device_remote_data_source.dart';
import '../models/register_device_request.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  DeviceRepositoryImpl(this._remote, this._local, this._config, {String? platform})
    : _platform = platform ?? (defaultTargetPlatform == TargetPlatform.android ? 'android' : 'windows');

  final DeviceRemoteDataSource _remote;
  final DeviceLocalDataSource _local;
  final AppConfig _config;
  final String _platform;

  @override
  Future<Result<DeviceSession>> register({
    required String storeCode,
    required String registrationCode,
    required String deviceName,
  }) async {
    try {
      final model = await _remote.register(
        RegisterDeviceRequest(
          storeCode: storeCode,
          registrationCode: registrationCode,
          deviceName: deviceName,
          platform: _platform,
          appVersion: _config.appVersion,
        ),
      );
      await _local.save(model);
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
      return Success((await _remote.me()).toEntity());
    } on DioException catch (e) {
      return Err(mapDioError(e));
    }
  }

  @override
  Future<void> unpair() => _local.clear();
}
