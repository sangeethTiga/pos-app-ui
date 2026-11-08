import 'package:dio/dio.dart';

import '../config/app_config.dart';
import '../error/failure.dart';
import 'device_auth_interceptor.dart';

/// Single Dio instance for the backend. Device signing is added by [DeviceAuthInterceptor].
Dio createDio(AppConfig config, {List<Interceptor> interceptors = const []}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json'},
      responseType: ResponseType.json,
    ),
  );
  dio.interceptors.addAll(interceptors);
  return dio;
}

/// Maps any Dio error to a [Failure] using the backend error envelope.
Failure mapDioError(Object error) {
  if (error is! DioException) return Failure.unexpected(message: error.toString());
  if (error.error is DeviceNotPairedException) {
    return const Failure.unauthorized(code: 'DEVICE_NOT_PAIRED', message: 'This terminal is not paired with a store.');
  }

  final response = error.response;
  if (response == null) {
    return Failure.network(message: error.message ?? error.type.name);
  }

  final data = response.data;
  final envelope = data is Map && data['error'] is Map ? Map<String, dynamic>.from(data['error'] as Map) : null;
  final status = response.statusCode ?? 0;
  final code = envelope?['code'] as String? ?? 'HTTP_$status';
  final message = envelope?['message'] as String? ?? 'Request failed ($status).';

  if (status == 401) return Failure.unauthorized(code: code, message: message);
  return Failure.server(
    statusCode: status,
    code: code,
    message: message,
    retryable: envelope?['retryable'] as bool? ?? status >= 500,
    details: envelope?['details'] is Map ? Map<String, dynamic>.from(envelope!['details'] as Map) : const {},
  );
}
