import 'package:dio/dio.dart';

import '../models/device_registration_model.dart';
import '../models/device_status_model.dart';
import '../models/register_device_request.dart';

/// HTTP calls of the device_setup feature. Throws [DioException]; the repository maps it.
class DeviceRemoteDataSource {
  const DeviceRemoteDataSource(this._dio);

  final Dio _dio;

  Future<DeviceRegistrationModel> register(RegisterDeviceRequest request) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/devices/register',
      data: request.toJson(),
      options: Options(extra: {'public': true}), // no credentials yet
    );
    return DeviceRegistrationModel.fromJson(res.data!);
  }

  /// Signed by DeviceAuthInterceptor.
  Future<DeviceStatusModel> me() async {
    final res = await _dio.get<Map<String, dynamic>>('/devices/me');
    return DeviceStatusModel.fromJson(res.data!);
  }
}
