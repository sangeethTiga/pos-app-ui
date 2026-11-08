import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'device_credentials_provider.dart';
import 'request_signer.dart';

/// Adds `Authorization: Bearer <device token>` and the HMAC headers to every request
/// unless `options.extra['public'] == true` (registration, token refresh).
///
/// The body is encoded here, once, and those exact bytes are both signed and sent.
/// An access token about to expire is refreshed first; a 401 is answered by one refresh + retry.
class DeviceAuthInterceptor extends QueuedInterceptor {
  DeviceAuthInterceptor(this._credentials, this._signer, {Dio? retryClient}) : _retry = retryClient;

  final DeviceCredentialsProvider _credentials;
  final RequestSigner _signer;
  final Dio? _retry;

  static const _retriedKey = 'auth_retried';
  static const _bodyKey = 'json_body';

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (options.extra['public'] == true) return handler.next(options);

    if (await _credentials.accessTokenExpiring()) await _credentials.refreshTokens();
    await _sign(options, handler.reject, () => handler.next(options));
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final o = err.requestOptions;
    final data = err.response?.data;
    final code = data is Map && data['error'] is Map ? (data['error'] as Map)['code'] : null;
    final retry = _retry;
    if (err.response?.statusCode != 401 ||
        o.extra['public'] == true ||
        o.extra[_retriedKey] == true ||
        code == 'DEVICE_REVOKED' ||
        retry == null) {
      return handler.next(err);
    }
    if (!await _credentials.refreshTokens()) return handler.next(err);
    o.extra[_retriedKey] = true;
    o.data = o.extra[_bodyKey]; // re-encode the original body
    await _sign(o, (e) => handler.next(e), () async {
      try {
        handler.resolve(await retry.fetch<dynamic>(o));
      } on DioException catch (e) {
        handler.next(e);
      }
    });
  }

  Future<void> _sign(RequestOptions options, void Function(DioException) reject, void Function() next) async {
    final creds = await _credentials.deviceCredentials();
    if (creds == null) {
      return reject(
        DioException(requestOptions: options, type: DioExceptionType.cancel, error: const DeviceNotPairedException()),
      );
    }
    options.extra[_bodyKey] ??= options.data;

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
    next();
  }
}

class DeviceNotPairedException implements Exception {
  const DeviceNotPairedException();

  @override
  String toString() => 'This terminal is not paired with a store.';
}
