import 'dart:convert';
import 'dart:isolate';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

import '../../../core/security/pin_hash.dart';
import '../../../core/storage/secure_store.dart';
import '../../../core/sync/local_store.dart';

/// A POS user as replicated by the backend (`user` entity: POS profile per store).
class StaffUser {
  const StaffUser({
    required this.id,
    required this.name,
    required this.pinHash,
    required this.permissions,
    required this.maxDiscountBp,
    this.username,
    this.email,
    this.passwordHash,
    this.roles = const {},
  });
  final String id;
  final String name;
  final String? username;

  /// Account email set by the admin (anucashier@gmail.com): the name picked on the login screen.
  final String? email;
  final String? pinHash;

  /// Same password as the admin panel (login screen checks it offline).
  final String? passwordHash;

  /// Role names in this store (Cashier, Captain ...). Empty in profiles synced before roles were sent.
  final Set<String> roles;
  final Set<String> permissions;
  final int maxDiscountBp;

  bool can(String permission) => permissions.contains(permission);

  /// Account for this terminal type: Cashier accounts on cashier devices, Captain accounts on
  /// captain devices. Old profiles without role names fall back to permissions.
  bool canLoginOn(String deviceType) {
    final role = deviceType == 'CAPTAIN' ? 'Captain' : 'Cashier';
    if (roles.isNotEmpty) return roles.contains(role);
    return deviceType == 'CAPTAIN'
        ? can('order.create') && !can('payment.take')
        : can('payment.take') && !can('role.manage') && !can('user.manage');
  }

  /// Shown in the login dropdown.
  String get loginName => email ?? username ?? name;
}

/// Who is logged in on this terminal right now.
class StaffSession extends ValueNotifier<StaffUser?> {
  StaffSession() : super(null);
  StaffUser get user => value ?? (throw StateError('No cashier logged in'));
}

class StaffRepository {
  StaffRepository(this._store, this._secure);

  final LocalStore _store;
  final SecureStore _secure;
  final Map<String, int> _failures = {};
  final Map<String, DateTime> _lockedUntil = {};

  static const maxAttempts = 5;
  static const lockout = Duration(minutes: 5);

  Future<List<StaffUser>> users() async {
    final rows = await _store.all('user');
    final list = [
      for (final r in rows)
        if (r.data['active'] == true && (r.data['pin_hash'] != null || r.data['password_hash'] != null))
          StaffUser(
            id: r.id,
            name: r.data['name'] as String? ?? '',
            username: r.data['username'] as String?,
            email: r.data['email'] as String?,
            pinHash: r.data['pin_hash'] as String?,
            passwordHash: r.data['password_hash'] as String?,
            permissions: {...((r.data['permissions'] as List?) ?? const []).cast<String>()},
            roles: {...((r.data['roles'] as List?) ?? const []).cast<String>()},
            maxDiscountBp: (r.data['max_discount_bp'] as num?)?.toInt() ?? 0,
          ),
    ];
    return list..sort((a, b) => a.name.compareTo(b.name));
  }

  bool isLocked(String userId) => _lockedUntil[userId]?.isAfter(DateTime.now()) ?? false;

  /// PIN check, offline. Argon2id from the server is slow by design (≈1–2 s), so it runs in an
  /// isolate once; afterwards a per-terminal HMAC of the PIN (bound to that pin_hash) is used.
  /// Locks the user for [lockout] after [maxAttempts] wrong PINs (SEC-05).
  Future<bool> verifyPin(StaffUser user, String pin) => _verify(user, pin, user.pinHash, 'pin_cache_');

  /// Password check on the login screen, offline, same rules and lockout as [verifyPin].
  Future<bool> verifyPassword(StaffUser user, String password) =>
      _verify(user, password, user.passwordHash, 'pwd_cache_');

  Future<bool> _verify(StaffUser user, String secret, String? hash, String cachePrefix) async {
    if (isLocked(user.id) || hash == null) return false;
    final key = await _localKey();
    final fast = Hmac(sha256, key).convert(utf8.encode('${user.id}|$hash|$secret')).toString();
    final cacheKey = '$cachePrefix${user.id}';
    var ok = await _secure.read(cacheKey) == fast;
    if (!ok) {
      ok = await Isolate.run(() => PinHash.verify(secret, hash));
      if (ok) await _secure.write(cacheKey, fast);
    }
    if (ok) {
      _failures.remove(user.id);
    } else {
      final n = (_failures[user.id] ?? 0) + 1;
      _failures[user.id] = n;
      if (n >= maxAttempts) {
        _lockedUntil[user.id] = DateTime.now().add(lockout);
        _failures.remove(user.id);
      }
    }
    return ok;
  }

  Future<List<int>> _localKey() async {
    var k = await _secure.read('pin_cache_key');
    if (k == null) {
      final rnd = Random.secure();
      k = base64.encode(List.generate(32, (_) => rnd.nextInt(256)));
      await _secure.write('pin_cache_key', k);
    }
    return base64.decode(k);
  }
}
