import 'package:flutter_test/flutter_test.dart';
import 'package:memora/core/config/app_strings.dart';
import 'package:memora/core/config/env_config.dart';

void main() {
  test('EnvConfig.fromEnvironment falls back to defaults without throwing', () {
    final config = EnvConfig.fromEnvironment();

    expect(config.appName, AppStrings.appName);
    expect(config.baseUrl, 'http://localhost:8080');
    expect(config.flavor, AppFlavor.development);
  });
}
