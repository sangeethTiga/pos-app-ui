import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/features/device_setup/domain/activation_policy.dart';
import 'package:pos_app_ui/features/device_setup/domain/entities/device_activation.dart';

void main() {
  final start = DateTime.utc(2026, 11, 9, 10);
  final end = DateTime.utc(2026, 12, 9, 10);

  ActivationSnapshot snap(
    ActivationStatus status, {
    bool valid = false,
    DateTime? startsAt,
    DateTime? expiresAt,
    Duration offset = Duration.zero,
    DateTime? lastServerTime,
  }) => ActivationSnapshot(
    activation: DeviceActivation(status: status, valid: valid, startsAt: startsAt, expiresAt: expiresAt),
    clockOffset: offset,
    lastServerTime: lastServerTime,
    receivedAt: start,
  );

  final active = snap(ActivationStatus.active, valid: true, startsAt: start, expiresAt: end);

  group('ActivationPolicy.evaluate', () {
    test('nothing stored (fresh registration, offline): blocked as not activated', () {
      final v = ActivationPolicy.evaluate(null, start);
      expect(v.canSell, isFalse);
      expect(v.block, ActivationBlock.notActivated);
    });

    test('valid inside the window: may sell, remaining days rounded up', () {
      final v = ActivationPolicy.evaluate(active, DateTime.utc(2026, 12, 1, 12));
      expect(v.canSell, isTrue);
      expect(v.remainingDays, 8); // 7 days 22 h -> 8
      expect(v.expiresSoon, isFalse);
      expect(ActivationPolicy.evaluate(active, DateTime.utc(2026, 12, 2, 12)).expiresSoon, isTrue);
    });

    test('offline past expires_at: blocked as expired even though the stored state says valid', () {
      final v = ActivationPolicy.evaluate(active, end);
      expect(v.canSell, isFalse);
      expect(v.block, ActivationBlock.expired);
      expect(v.remainingDays, 0);
      expect(ActivationPolicy.evaluate(active, end.subtract(const Duration(seconds: 1))).canSell, isTrue);
    });

    test('before starts_at: blocked as scheduled; SCHEDULED may sell once the start has passed', () {
      expect(ActivationPolicy.evaluate(active, start.subtract(const Duration(minutes: 1))).block, ActivationBlock.scheduled);
      final scheduled = snap(ActivationStatus.scheduled, startsAt: start, expiresAt: end);
      expect(ActivationPolicy.evaluate(scheduled, start.subtract(const Duration(minutes: 1))).block, ActivationBlock.scheduled);
      expect(ActivationPolicy.evaluate(scheduled, start.add(const Duration(minutes: 1))).canSell, isTrue);
    });

    test('stored not valid: blocked with the status as reason', () {
      final now = start.add(const Duration(days: 1));
      expect(ActivationPolicy.evaluate(snap(ActivationStatus.inactive), now).block, ActivationBlock.notActivated);
      expect(
        ActivationPolicy.evaluate(snap(ActivationStatus.suspended, startsAt: start, expiresAt: end), now).block,
        ActivationBlock.suspended,
      );
      expect(ActivationPolicy.evaluate(snap(ActivationStatus.revoked), now).block, ActivationBlock.revoked);
      expect(ActivationPolicy.evaluate(snap(ActivationStatus.expired, expiresAt: end), now).block, ActivationBlock.expired);
      // ACTIVE but the server says not valid: trust the server
      expect(
        ActivationPolicy.evaluate(snap(ActivationStatus.active, startsAt: start, expiresAt: end), now).canSell,
        isFalse,
      );
    });

    test('server clock offset: a device clock 2 h slow still expires on server time', () {
      final slow = snap(
        ActivationStatus.active,
        valid: true,
        startsAt: start,
        expiresAt: end,
        offset: const Duration(hours: 2),
      );
      final deviceNow = end.subtract(const Duration(hours: 1)); // server: 1 h past the end
      expect(ActivationPolicy.evaluate(slow, deviceNow).block, ActivationBlock.expired);
      expect(ActivationPolicy.evaluate(active, deviceNow).canSell, isTrue);
    });

    test('device clock turned back: never earlier than the last server time seen', () {
      final s = snap(
        ActivationStatus.active,
        valid: true,
        startsAt: start,
        expiresAt: end,
        lastServerTime: end.add(const Duration(minutes: 5)),
      );
      expect(ActivationPolicy.evaluate(s, DateTime.utc(2026, 11, 20)).block, ActivationBlock.expired);
    });
  });

  group('ActivationCode', () {
    test('formats while typing: upper case, groups of 4, at most 12', () {
      expect(ActivationCode.format(''), '');
      expect(ActivationCode.format('abc'), 'ABC');
      expect(ActivationCode.format('abcd'), 'ABCD');
      expect(ActivationCode.format('abcde'), 'ABCD-E');
      expect(ActivationCode.format('ABCD-EFGH-JKLM'), 'ABCD-EFGH-JKLM');
      expect(ActivationCode.format('abcdefghjklmnpq'), 'ABCD-EFGH-JKLM');
      expect(ActivationCode.format(' ab cd - ef '), 'ABCD-EF');
    });

    test('drops characters outside the alphabet (0, 1, I, O)', () {
      expect(ActivationCode.normalize('a0b1-cIdO'), 'ABCD');
    });

    test('complete code: 12 alphabet characters, dashes optional, any case', () {
      expect(ActivationCode.isComplete('ABCD-EFGH-JKLM'), isTrue);
      expect(ActivationCode.isComplete('abcdefghjklm'), isTrue);
      expect(ActivationCode.isComplete('ABCD-EFGH-JKL'), isFalse);
      expect(ActivationCode.isComplete('ABCD-EFGH-JKL0'), isFalse);
    });
  });
}
