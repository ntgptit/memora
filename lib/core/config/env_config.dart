import 'package:flutter/foundation.dart';
import 'package:memora/core/config/app_strings.dart';

enum AppFlavor {
  development('development'),
  staging('staging'),
  production('production');

  const AppFlavor(this.value);

  final String value;

  static AppFlavor fromValue(String value) {
    switch (value.toLowerCase()) {
      case 'production':
        return AppFlavor.production;
      case 'staging':
        return AppFlavor.staging;
      default:
        return AppFlavor.development;
    }
  }
}

@immutable
class EnvConfig {
  const EnvConfig({
    required this.appName,
    required this.flavor,
    required this.baseUrl,
    required this.enableNetworkLogs,
  });

  factory EnvConfig.fromEnvironment() {
    final flavor = AppFlavor.fromValue(
      const String.fromEnvironment('APP_FLAVOR', defaultValue: 'development'),
    );

    return EnvConfig(
      appName: const String.fromEnvironment(
        'APP_NAME',
        defaultValue: AppStrings.appName,
      ),
      flavor: flavor,
      baseUrl: const String.fromEnvironment(
        'API_BASE_URL',
        defaultValue: 'http://localhost:8080',
      ),
      enableNetworkLogs: kDebugMode || flavor != AppFlavor.production,
    );
  }

  final String appName;
  final AppFlavor flavor;
  final String baseUrl;
  final bool enableNetworkLogs;

  bool get isProduction => flavor == AppFlavor.production;
}
