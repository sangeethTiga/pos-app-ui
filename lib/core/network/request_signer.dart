import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// HMAC request signature required on every device request
/// (backend: `App\Infrastructure\Auth\RequestSignature`).
///
/// ```
/// X-Signature = hex(HMAC_SHA256(signing_secret,
///   METHOD \n PATH_WITH_SORTED_QUERY \n TIMESTAMP \n NONCE \n hex(SHA256(body))))
/// ```
class RequestSigner {
  RequestSigner({Random? random, DateTime Function()? clock})
    : _random = random ?? Random.secure(),
      _clock = clock ?? DateTime.now;

  final Random _random;
  final DateTime Function() _clock;

  static const _nonceChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789_-';

  /// Server-side clock offset (server - device); updated from `server_time` / SIGNATURE_EXPIRED.
  Duration clockOffset = Duration.zero;

  /// Path plus query exactly as the server rebuilds it (Symfony `Request::normalizeQueryString`):
  /// keys sorted, last value wins for a repeated key, RFC 3986 encoding (space = `%20`).
  /// Array parameters (`a[]=1`) are not supported on signed device requests.
  static String canonicalPath(Uri uri) {
    final path = uri.path.isEmpty ? '/' : uri.path;
    if (uri.query.isEmpty) return path;
    final values = <String, String>{};
    for (final pair in uri.query.split('&')) {
      if (pair.isEmpty) continue;
      final i = pair.indexOf('=');
      final k = Uri.decodeQueryComponent(i < 0 ? pair : pair.substring(0, i));
      final v = i < 0 ? '' : Uri.decodeQueryComponent(pair.substring(i + 1));
      values[k] = v;
    }
    if (values.isEmpty) return path;
    final keys = values.keys.toList()..sort();
    return '$path?${keys.map((k) => '${_rfc3986(k)}=${_rfc3986(values[k]!)}').join('&')}';
  }

  /// PHP `rawurlencode`: everything except `A-Z a-z 0-9 - _ . ~` is percent-encoded.
  static String _rfc3986(String s) {
    final out = StringBuffer();
    for (final b in utf8.encode(s)) {
      final unreserved =
          (b >= 0x30 && b <= 0x39) ||
          (b >= 0x41 && b <= 0x5A) ||
          (b >= 0x61 && b <= 0x7A) ||
          b == 0x2D ||
          b == 0x2E ||
          b == 0x5F ||
          b == 0x7E;
      out.write(unreserved ? String.fromCharCode(b) : '%${b.toRadixString(16).toUpperCase().padLeft(2, '0')}');
    }
    return out.toString();
  }

  static String sign({
    required String secret,
    required String method,
    required String pathWithQuery,
    required String timestamp,
    required String nonce,
    required List<int> body,
  }) {
    final canonical = [
      method.toUpperCase(),
      pathWithQuery,
      timestamp,
      nonce,
      sha256.convert(body).toString(),
    ].join('\n');
    return Hmac(sha256, utf8.encode(secret)).convert(utf8.encode(canonical)).toString();
  }

  String nonce([int length = 24]) =>
      List.generate(length, (_) => _nonceChars[_random.nextInt(_nonceChars.length)]).join();

  /// Headers for one request. [body] must be the exact bytes that are sent.
  Map<String, String> headers({
    required String secret,
    required String method,
    required Uri uri,
    required List<int> body,
  }) {
    final ts = (_clock().add(clockOffset).millisecondsSinceEpoch ~/ 1000).toString();
    final n = nonce();
    return {
      'X-Timestamp': ts,
      'X-Nonce': n,
      'X-Signature': sign(
        secret: secret,
        method: method,
        pathWithQuery: canonicalPath(uri),
        timestamp: ts,
        nonce: n,
        body: body,
      ),
    };
  }
}
