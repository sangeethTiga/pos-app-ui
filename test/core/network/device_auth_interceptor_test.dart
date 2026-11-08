import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/core/config/app_config.dart';
import 'package:pos_app_ui/core/error/failure.dart';
import 'package:pos_app_ui/core/network/api_client.dart';
import 'package:pos_app_ui/core/network/device_auth_interceptor.dart';
import 'package:pos_app_ui/core/network/device_credentials_provider.dart';
import 'package:pos_app_ui/core/network/request_signer.dart';

class _Creds implements DeviceCredentialsProvider {
  _Creds(this.value);
  final ({String accessToken, String signingSecret})? value;
  @override
  Future<({String accessToken, String signingSecret})?> deviceCredentials() async => value;
}

/// Captures the outgoing request and answers with [status]/[body].
class _Adapter implements HttpClientAdapter {
  _Adapter({this.status = 200, this.body = '{}'});
  final int status;
  final String body;
  RequestOptions? options;
  List<int> sent = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    this.options = options;
    if (requestStream != null) {
      await for (final chunk in requestStream) {
        sent.addAll(chunk);
      }
    }
    return ResponseBody.fromString(
      body,
      status,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  const config = AppConfig(apiBaseUrl: 'http://pos.test/api/v1', appVersion: '1.0.0');

  test('signs the exact bytes it sends, with bearer token and sorted query', () async {
    final adapter = _Adapter();
    final dio = createDio(
      config,
      interceptors: [DeviceAuthInterceptor(_Creds((accessToken: 'tok', signingSecret: 'sec')), RequestSigner())],
    )..httpClientAdapter = adapter;

    await dio.post<dynamic>(
      '/sync/push',
      data: {'batch_id': 'b1', 'txs': <Object>[]},
      queryParameters: {'z': '1', 'a': '2'},
    );

    final h = adapter.options!.headers;
    expect(h['Authorization'], 'Bearer tok');
    expect(utf8.decode(adapter.sent), '{"batch_id":"b1","txs":[]}');
    final expected = RequestSigner.sign(
      secret: 'sec',
      method: 'POST',
      pathWithQuery: '/api/v1/sync/push?a=2&z=1',
      timestamp: h['X-Timestamp'] as String,
      nonce: h['X-Nonce'] as String,
      body: adapter.sent,
    );
    expect(h['X-Signature'], expected);
  });

  test('public requests are not signed', () async {
    final adapter = _Adapter(status: 201);
    final dio = createDio(config, interceptors: [DeviceAuthInterceptor(_Creds(null), RequestSigner())])
      ..httpClientAdapter = adapter;

    await dio.post<dynamic>(
      '/devices/register',
      data: {'a': 1},
      options: Options(extra: {'public': true}),
    );

    expect(adapter.options!.headers.containsKey('X-Signature'), isFalse);
    expect(adapter.options!.headers.containsKey('Authorization'), isFalse);
  });

  test('unpaired terminal fails fast with DEVICE_NOT_PAIRED', () async {
    final dio = createDio(config, interceptors: [DeviceAuthInterceptor(_Creds(null), RequestSigner())])
      ..httpClientAdapter = _Adapter();

    final failure = await dio.get<dynamic>('/devices/me').then<Failure?>((_) => null, onError: mapDioError);

    expect(failure, isA<UnauthorizedFailure>().having((f) => f.code, 'code', 'DEVICE_NOT_PAIRED'));
  });

  test('backend error envelope is mapped to ServerFailure', () async {
    final dio = createDio(config)
      ..httpClientAdapter = _Adapter(
        status: 409,
        body: '{"error":{"code":"NOT_GATEWAY","message":"Only the gateway may push.","details":{},"retryable":true}}',
      );

    final failure = await dio.get<dynamic>('/x').then<Failure?>((_) => null, onError: mapDioError);

    expect(
      failure,
      isA<ServerFailure>()
          .having((f) => f.code, 'code', 'NOT_GATEWAY')
          .having((f) => f.retryable, 'retryable', true)
          .having((f) => f.statusCode, 'status', 409),
    );
  });
}
