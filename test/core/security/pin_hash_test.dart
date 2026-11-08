import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/core/security/pin_hash.dart';

/// Hashes produced by PHP password_hash (what Laravel's Hash::make stores in users.pin_hash).
void main() {
  const argon = r'$argon2id$v=19$m=65536,t=4,p=1$OHJTRUxNczhUb3FVLkloaA$xvJPi8bOgJkQZn3Ao84SuBJovc5G5v3YvmLl8UBZmns';
  const bcrypt = r'$2y$10$Ucs/UZbky3AT4mFew8TLo.kfbvDor4e9kkf3daMNSO9kMLL68DR5W';

  test('argon2id hash from PHP', () {
    final sw = Stopwatch()..start();
    expect(PinHash.verify('1234', argon), isTrue);
    expect(PinHash.verify('1235', argon), isFalse);
    // ignore: avoid_print
    print('argon2id verify x2: ${sw.elapsedMilliseconds} ms');
  });

  test('bcrypt \$2y\$ hash from PHP', () {
    expect(PinHash.verify('1234', bcrypt), isTrue);
    expect(PinHash.verify('0000', bcrypt), isFalse);
  });

  test('unknown format is rejected', () => expect(PinHash.verify('1234', 'plain'), isFalse));
}
