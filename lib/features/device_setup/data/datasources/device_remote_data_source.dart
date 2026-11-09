import 'dart:convert';
import 'dart:io' show HttpDate;
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../../../core/network/request_signer.dart';

import '../models/device_activation_model.dart';
import '../models/device_registration_model.dart';
import '../models/device_status_model.dart';
import '../models/register_device_request.dart';
import '../models/registration_preview_model.dart';

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

  /// Checks the codes without using them up; returns store name and kiosks.
  Future<RegistrationPreviewModel> preview({required String storeCode, required String registrationCode}) async {
    final res = await _dio.post<Map<String, dynamic>>(
      '/devices/register/preview',
      data: {'store_code': storeCode, 'registration_code': registrationCode},
      options: Options(extra: {'public': true}),
    );
    return RegistrationPreviewModel.fromJson(res.data!);
  }

  /// `POST /devices/token/refresh`: signed with the device secret, no bearer token.
  /// Returns null when the server refuses the refresh token (401).
  static Future<Map<String, dynamic>?> refreshTokens(
    Dio plainDio,
    RequestSigner signer, {
    required String deviceId,
    required String refreshToken,
    required String signingSecret,
  }) async {
    final body = utf8.encode(jsonEncode({'device_id': deviceId, 'refresh_token': refreshToken}));
    final uri = Uri.parse('${plainDio.options.baseUrl}/devices/token/refresh');
    try {
      final res = await plainDio.post<Map<String, dynamic>>(
        '/devices/token/refresh',
        data: Uint8List.fromList(body),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            ...signer.headers(secret: signingSecret, method: 'POST', uri: uri, body: body),
          },
        ),
      );
      return res.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) return null;
      rethrow;
    }
  }

  /// Signed by DeviceAuthInterceptor.
  Future<DeviceStatusModel> me() async {
    final res = await _dio.get<Map<String, dynamic>>('/devices/me');
    return DeviceStatusModel.fromJson(res.data!);
  }

  /// `POST /devices/heartbeat` (every terminal): same body as `GET /devices/me`.
  Future<DeviceStatusModel> heartbeat({String? appVersion}) async {
    final res = await _dio.post<Map<String, dynamic>>('/devices/heartbeat', data: {'app_version': ?appVersion});
    return DeviceStatusModel.fromJson(res.data!);
  }

  /// `GET /devices/activation`. [serverTime] comes from the HTTP `Date` header (the body has none).
  Future<({DeviceActivationModel activation, DateTime? serverTime})> activation() async {
    final res = await _dio.get<Map<String, dynamic>>('/devices/activation');
    return (activation: DeviceActivationModel.fromJson(res.data!), serverTime: _dateHeader(res));
  }

  /// `POST /devices/activate`. 422 INVALID_ACTIVATION_CODE / 429 throttled come back as [DioException].
  Future<({ActivateDeviceResponseModel result, DateTime? serverTime})> activate(String code) async {
    final res = await _dio.post<Map<String, dynamic>>('/devices/activate', data: {'code': code});
    return (result: ActivateDeviceResponseModel.fromJson(res.data!), serverTime: _dateHeader(res));
  }

  static DateTime? _dateHeader(Response<dynamic> res) {
    final v = res.headers.value('date');
    if (v == null) return null;
    try {
      return HttpDate.parse(v);
    } on Object {
      return null;
    }
  }
}
