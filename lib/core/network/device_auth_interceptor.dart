import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'device_credentials_provider.dart';
import 'request_signer.dart';

/// Adds `Authorization: Bearer <device token>` and the HMAC headers to every request
/// unless `options.extra['public'] == true` (registration, token refresh).
///
/// The body is encoded here, once, and those exact bytes are both signed and sent.
class DeviceAuthInterceptor extends Interceptor {
  DeviceAuthInterceptor(this._credentials, this._signer);

  final DeviceCredentialsProvider _credentials;
  final RequestSigner _signer;

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.extra['public'] == true) return handler.next(options);

    final creds = await _credentials.deviceCredentials();
    if (creds == null) {
      return handler.reject(
        DioException(requestOptions: options, type: DioExceptionType.cancel, error: const DeviceNotPairedException()),
      );
    }

    final Uint8List body = switch (options.data) {
      null => Uint8List(0),
      final Uint8List bytes => bytes,
      final String s => Uint8List.fromList(utf8.encode(s)),
      final Object o => Uint8List.fromList(utf8.encode(jsonEncode(o))),
    };
    options.data = body.isEmpty ? null : body;
    options.headers['Content-Type'] = 'application/json';
    options.headers['Authorization'] = 'Bearer ${creds.accessToken}';
    options.headers.addAll(
      _signer.headers(secret: creds.signingSecret, method: options.method, uri: options.uri, body: body),
    );
    handler.next(options);
  }
}

class DeviceNotPairedException implements Exception {
  const DeviceNotPairedException();

  @override
  String toString() => 'This terminal is not paired with a store.';
}
