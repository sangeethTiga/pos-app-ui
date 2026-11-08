import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/core/network/request_signer.dart';

/// Expected values were produced by the backend itself:
/// `App\Infrastructure\Auth\RequestSignature::sign(...)` and
/// `Symfony\Component\HttpFoundation\Request::normalizeQueryString(...)`.
void main() {
  test('signature matches the Laravel backend (POST with body)', () {
    final sig = RequestSigner.sign(
      secret: 'secret-123',
      method: 'post',
      pathWithQuery: '/api/v1/sync/push',
      timestamp: '1762585120',
      nonce: 'abcdefghijklmnop1234',
      body: utf8.encode('{"a":1}'),
    );
    expect(sig, '26ebd16290a63395a7908848ced718b387d17c2f16b250a7fbb1084a0edf7c72');
  });

  test('query is canonicalised like Symfony normalizeQueryString', () {
    final uri = Uri.parse('http://x/api/v1/sync/pull?limit=500&cursor=0&q=Cola%20Zero&name=caf%C3%A9+%26+co&z=1&z=2');
    final canonical = RequestSigner.canonicalPath(uri);
    expect(canonical, '/api/v1/sync/pull?cursor=0&limit=500&name=caf%C3%A9%20%26%20co&q=Cola%20Zero&z=2');

    final sig = RequestSigner.sign(
      secret: 'secret-123',
      method: 'GET',
      pathWithQuery: canonical,
      timestamp: '1762585120',
      nonce: 'abcdefghijklmnop1234',
      body: const [],
    );
    expect(sig, '4048de7368ed4084c5eb06efb7014cb388921474396bf51e4efc32b138c24713');
  });

  test('headers use unix seconds, a fresh 16-64 char nonce and the clock offset', () {
    final signer = RequestSigner(clock: () => DateTime.utc(2026, 11, 8, 7))..clockOffset = const Duration(seconds: 30);
    final a = signer.headers(secret: 's', method: 'GET', uri: Uri.parse('http://x/api/v1/devices/me'), body: const []);
    final b = signer.headers(secret: 's', method: 'GET', uri: Uri.parse('http://x/api/v1/devices/me'), body: const []);

    expect(a['X-Timestamp'], '${DateTime.utc(2026, 11, 8, 7, 0, 30).millisecondsSinceEpoch ~/ 1000}');
    expect(a['X-Nonce'], matches(RegExp(r'^[A-Za-z0-9_-]{16,64}$')));
    expect(a['X-Nonce'], isNot(b['X-Nonce']));
    expect(a['X-Signature'], hasLength(64));
  });
}
