import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../../../../core/network/device_credentials_provider.dart';
import '../../../../core/storage/secure_store.dart';
import '../models/device_registration_model.dart';

/// Device credentials in secure storage (never SQLite, never logs).
///
/// Also the [DeviceCredentialsProvider] for the signing interceptor. It must not be the repository:
/// repository -> remote data source -> Dio -> interceptor -> repository would be a dependency cycle.
class DeviceLocalDataSource implements DeviceCredentialsProvider {
  DeviceLocalDataSource(this._store);

  static const _key = 'device_session_v1';
  static const _hardwareKey = 'terminal_hardware_id';

  final SecureStore _store;

  Future<DeviceRegistrationModel?> read() async {
    final raw = await _store.read(_key);
    if (raw == null) return null;
    try {
      return DeviceRegistrationModel.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      await _store.delete(_key); // unreadable (older format): pair again
      return null;
    }
  }

  Future<void> save(DeviceRegistrationModel model) => _store.write(_key, jsonEncode(model.toJson()));

  Future<void> clear() => _store.delete(_key);

  /// This terminal's own id: created once, kept across re-pairing (shown on the registration screen).
  Future<String> hardwareId() async {
    final existing = await _store.read(_hardwareKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final id = const Uuid().v4().toUpperCase();
    try {
      await _store.write(_hardwareKey, id);
    } on Object {
      // Storage refused: still usable for this registration; a new id is made next time.
    }
    return id;
  }

  @override
  Future<({String accessToken, String signingSecret})?> deviceCredentials() async {
    final m = await read();
    return m == null ? null : (accessToken: m.accessToken, signingSecret: m.signingSecret);
  }

  @override
  Future<bool> accessTokenExpiring() async {
    final m = await read();
    return m != null && DateTime.now().toUtc().isAfter(m.accessTokenExpiresAt.subtract(const Duration(minutes: 1)));
  }

  /// Set by DI: the refresh call itself must not go through the signing interceptor.
  Future<Map<String, dynamic>?> Function(DeviceRegistrationModel current)? refreshCall;

  @override
  Future<bool> refreshTokens() async {
    final current = await read();
    final call = refreshCall;
    if (current == null || call == null) return false;
    final tokens = await call(current);
    if (tokens == null) return false;
    await save(
      current.copyWith(
        accessToken: tokens['access_token'] as String,
        accessTokenExpiresAt: DateTime.parse(tokens['access_token_expires_at'] as String),
        refreshToken: tokens['refresh_token'] as String,
        refreshTokenExpiresAt: DateTime.parse(tokens['refresh_token_expires_at'] as String),
      ),
    );
    return true;
  }
}
