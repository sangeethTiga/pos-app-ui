import 'dart:convert';
import 'dart:typed_data';

import 'package:bcrypt/bcrypt.dart';
import 'package:pointycastle/export.dart';

/// Verifies a cashier PIN against the `pin_hash` the backend replicates (PHP `password_hash`):
/// Argon2id (`$argon2id$v=19$m=..,t=..,p=..$salt$hash`, Laravel default) or bcrypt (`$2y$`).
abstract final class PinHash {
  static bool verify(String pin, String hash) {
    if (hash.startsWith(r'$argon2id$') || hash.startsWith(r'$argon2i$')) return _argon2(pin, hash);
    if (hash.startsWith(r'$2y$') || hash.startsWith(r'$2a$') || hash.startsWith(r'$2b$')) {
      return BCrypt.checkpw(pin, hash.replaceFirst(r'$2y$', r'$2a$'));
    }
    return false;
  }

  static bool _argon2(String pin, String encoded) {
    final parts = encoded.split(r'$'); // ['', 'argon2id', 'v=19', 'm=..,t=..,p=..', salt, hash]
    if (parts.length != 6) return false;
    final params = {for (final kv in parts[3].split(',')) kv.split('=')[0]: int.parse(kv.split('=')[1])};
    final salt = _b64(parts[4]);
    final expected = _b64(parts[5]);
    final gen = Argon2BytesGenerator()
      ..init(
        Argon2Parameters(
          parts[1] == 'argon2id' ? Argon2Parameters.ARGON2_id : Argon2Parameters.ARGON2_i,
          salt,
          desiredKeyLength: expected.length,
          iterations: params['t']!,
          memory: params['m']!,
          lanes: params['p']!,
          version: Argon2Parameters.ARGON2_VERSION_13,
        ),
      );
    final out = gen.process(Uint8List.fromList(utf8.encode(pin)));
    if (out.length != expected.length) return false;
    var diff = 0;
    for (var i = 0; i < out.length; i++) {
      diff |= out[i] ^ expected[i];
    }
    return diff == 0;
  }

  /// PHP uses unpadded standard base64.
  static Uint8List _b64(String s) => base64.decode(s.padRight((s.length + 3) ~/ 4 * 4, '='));
}
