import 'entities/device_activation.dart';

/// Local (offline) enforcement of the platform activation. The server decides `valid`; this judges the
/// stored state against the clock so an expiry is enforced without a connection.
abstract final class ActivationPolicy {
  /// Best estimate of the server's "now": device clock corrected by the last known offset, never earlier
  /// than the latest server time seen (a device clock turned back does not extend the activation).
  static DateTime trustedNow(ActivationSnapshot? s, DateTime deviceNow) {
    final now = deviceNow.toUtc();
    if (s == null) return now;
    final corrected = now.add(s.clockOffset);
    final floor = s.lastServerTime?.toUtc();
    return floor != null && floor.isAfter(corrected) ? floor : corrected;
  }

  /// Blocked when the stored state is not valid, before `starts_at`, or at / after `expires_at`.
  ///
  /// SCHEDULED is the server's "ACTIVE, start still ahead": once `starts_at` has passed it may sell
  /// (the server reports ACTIVE then), so a terminal that is offline at the start is not locked out.
  static ActivationVerdict evaluate(ActivationSnapshot? s, DateTime deviceNow) {
    if (s == null) return ActivationVerdict.unknown;
    final a = s.activation;
    final now = trustedNow(s, deviceNow);
    final start = a.startsAt?.toUtc();
    final end = a.expiresAt?.toUtc();
    final remaining = end == null ? a.remainingDays : remainingDays(end, now);

    ActivationVerdict blocked(ActivationBlock b) =>
        ActivationVerdict(block: b, remainingDays: remaining, startsAt: start, expiresAt: end);

    switch (a.status) {
      case ActivationStatus.suspended:
        return blocked(ActivationBlock.suspended);
      case ActivationStatus.revoked:
        return blocked(ActivationBlock.revoked);
      case ActivationStatus.inactive:
        return blocked(ActivationBlock.notActivated);
      case ActivationStatus.expired:
        return blocked(ActivationBlock.expired);
      case ActivationStatus.active || ActivationStatus.scheduled:
        if (end != null && !now.isBefore(end)) return blocked(ActivationBlock.expired);
        if (start != null && now.isBefore(start)) return blocked(ActivationBlock.scheduled);
        if (a.status == ActivationStatus.scheduled && start == null) return blocked(ActivationBlock.scheduled);
        if (a.status == ActivationStatus.active && !a.valid) return blocked(ActivationBlock.notActivated);
        return ActivationVerdict(remainingDays: remaining, startsAt: start, expiresAt: end);
    }
  }

  /// Days left, rounded up (the server's `remaining_days`), never negative.
  static int remainingDays(DateTime expiresAt, DateTime now) {
    final seconds = expiresAt.difference(now).inSeconds;
    if (seconds <= 0) return 0;
    return (seconds + 86399) ~/ 86400;
  }
}

/// Activation codes: 12 characters of [alphabet], shown as XXXX-XXXX-XXXX; dashes optional, any case.
abstract final class ActivationCode {
  static const alphabet = '23456789ABCDEFGHJKLMNPQRSTUVWXYZ';
  static const length = 12;

  /// Upper-case code characters only (dashes, spaces and characters outside the alphabet dropped).
  static String normalize(String input) {
    final b = StringBuffer();
    for (final ch in input.toUpperCase().split('')) {
      if (alphabet.contains(ch)) b.write(ch);
    }
    return b.toString();
  }

  /// "abcd efgh-jk" -> "ABCD-EFGH-JK" (at most [length] characters).
  static String format(String input) {
    var raw = normalize(input);
    if (raw.length > length) raw = raw.substring(0, length);
    final groups = <String>[
      for (var i = 0; i < raw.length; i += 4) raw.substring(i, i + 4 > raw.length ? raw.length : i + 4),
    ];
    return groups.join('-');
  }

  /// A complete code: exactly [length] alphabet characters once dashes / spaces are removed.
  static bool isComplete(String input) {
    final stripped = input.toUpperCase().replaceAll(RegExp(r'[\s-]'), '');
    return stripped.length == length && stripped.split('').every(alphabet.contains);
  }
}
