import 'package:flutter_test/flutter_test.dart';
import 'package:pos_app_ui/core/config/app_config.dart';

/// Kept from the project template; feature tests live under test/features and test/core.
void main() {
  test('default API base URL points at the local backend', () {
    expect(AppConfig.fromEnvironment().apiBaseUrl, 'http://localhost:8000/api/v1');
  });
}
