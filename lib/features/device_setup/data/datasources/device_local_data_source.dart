import 'dart:convert';

import '../../../../core/network/device_credentials_provider.dart';
import '../../../../core/storage/secure_store.dart';
import '../models/device_registration_model.dart';

/// Device credentials in secure storage (never SQLite, never logs).
///
/// Also the [DeviceCredentialsProvider] for the signing interceptor. It must not be the repository:
/// repository -> remote data source -> Dio -> interceptor -> repository would be a dependency cycle.
class DeviceLocalDataSource implements DeviceCredentialsProvider {
  const DeviceLocalDataSource(this._store);

  static const _key = 'device_session_v1';

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

  @override
  Future<({String accessToken, String signingSecret})?> deviceCredentials() async {
    final m = await read();
    return m == null ? null : (accessToken: m.accessToken, signingSecret: m.signingSecret);
  }
}
