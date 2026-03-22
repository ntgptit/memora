import 'package:flutter/foundation.dart';
import 'package:memora/core/config/app_strings.dart';

enum AppFlavor {
  development('development'),
  staging('staging'),
  production('production');

  const AppFlavor(this.value);

  final String value;

  static AppFlavor fromValue(String value) {
    switch (value.trim().toLowerCase()) {
      case 'dev':
      case 'development':
        return AppFlavor.development;
      case 'stage':
      case 'production':
      case 'staging':
        return value.trim().toLowerCase() == 'production'
            ? AppFlavor.production
            : AppFlavor.staging;
      case 'prod':
        return AppFlavor.production;
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
    required this.enableProviderLogs,
    required this.enableRouterLogs,
    required this.showEnvironmentBanner,
    required this.showPerformanceOverlay,
    required this.showDebugBanner,
  });

  factory EnvConfig.fromEnvironment() {
    const rawFlavor = String.fromEnvironment(
      'APP_FLAVOR',
      defaultValue: 'development',
    );
    final flavor = AppFlavor.fromValue(rawFlavor);

    return EnvConfig(
      appName: _readString('APP_NAME', fallback: AppStrings.appName),
      flavor: flavor,
      baseUrl: _readBaseUrl(),
      enableNetworkLogs: _readBool(
        'ENABLE_NETWORK_LOGS',
        fallback: kDebugMode || flavor != AppFlavor.production,
      ),
      enableProviderLogs: _readBool(
        'ENABLE_PROVIDER_LOGS',
        fallback: kDebugMode,
      ),
      enableRouterLogs: _readBool('ENABLE_ROUTER_LOGS', fallback: kDebugMode),
      showEnvironmentBanner: _readBool(
        'SHOW_ENV_BANNER',
        fallback: flavor != AppFlavor.production,
      ),
      showPerformanceOverlay: _readBool(
        'SHOW_PERFORMANCE_OVERLAY',
        fallback: false,
      ),
      showDebugBanner: _readBool('SHOW_DEBUG_BANNER', fallback: false),
    );
  }

  final String appName;
  final AppFlavor flavor;
  final String baseUrl;
  final bool enableNetworkLogs;
  final bool enableProviderLogs;
  final bool enableRouterLogs;
  final bool showEnvironmentBanner;
  final bool showPerformanceOverlay;
  final bool showDebugBanner;

  bool get isProduction => flavor == AppFlavor.production;
  bool get isDevelopment => flavor == AppFlavor.development;
  bool get isStaging => flavor == AppFlavor.staging;

  String get environmentLabel {
    switch (flavor) {
      case AppFlavor.development:
        return AppStrings.developmentLabel;
      case AppFlavor.staging:
        return AppStrings.stagingLabel;
      case AppFlavor.production:
        return AppStrings.productionLabel;
    }
  }

  Uri get baseUri => Uri.parse(baseUrl);

  @override
  String toString() {
    return 'EnvConfig(appName: $appName, flavor: ${flavor.value}, baseUrl: $baseUrl)';
  }
}

String _readString(String key, {required String fallback}) {
  final value = String.fromEnvironment(key, defaultValue: fallback).trim();
  if (value.isEmpty) {
    return fallback;
  }

  return value;
}

bool _readBool(String key, {required bool fallback}) {
  final raw = String.fromEnvironment(
    key,
    defaultValue: '',
  ).trim().toLowerCase();
  switch (raw) {
    case 'true':
    case '1':
    case 'yes':
    case 'y':
    case 'on':
      return true;
    case 'false':
    case '0':
    case 'no':
    case 'n':
    case 'off':
      return false;
    default:
      return fallback;
  }
}

String _readBaseUrl() {
  final value = _readString('API_BASE_URL', fallback: 'http://localhost:8080');
  final uri = Uri.tryParse(value);

  if (uri == null || !uri.hasScheme || uri.host.isEmpty) {
    throw FormatException('Invalid API_BASE_URL: $value');
  }

  return uri.replace(path: _normalizePath(uri.path)).toString();
}

String _normalizePath(String path) {
  if (path.isEmpty || path == '/') {
    return '';
  }

  return path.endsWith('/') ? path.substring(0, path.length - 1) : path;
}
