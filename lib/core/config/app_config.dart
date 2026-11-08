/// Build-time configuration.
///
/// Override per environment:
/// `flutter run --dart-define=API_BASE_URL=https://api.example.com/api/v1`
class AppConfig {
  const AppConfig({required this.apiBaseUrl, required this.appVersion});

  factory AppConfig.fromEnvironment() => const AppConfig(
    apiBaseUrl: String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:8000/api/v1'),
    appVersion: String.fromEnvironment('APP_VERSION', defaultValue: '1.0.0'),
  );

  /// Base URL including `/api/v1`, no trailing slash.
  final String apiBaseUrl;
  final String appVersion;
}
