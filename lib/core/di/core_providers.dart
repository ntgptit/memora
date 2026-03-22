import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:memora/core/config/app_keys.dart';
import 'package:memora/core/config/env_config.dart';
import 'package:memora/core/network/api_client.dart';
import 'package:memora/core/network/network_info.dart';
import 'package:memora/core/network/interceptors/auth_interceptor.dart';
import 'package:memora/core/network/interceptors/connectivity_interceptor.dart';
import 'package:memora/core/network/interceptors/logging_interceptor.dart';
import 'package:memora/core/network/interceptors/retry_interceptor.dart';
import 'package:memora/core/storage/cache_manager.dart';
import 'package:memora/core/storage/preferences_storage.dart';
import 'package:memora/core/storage/secure_storage.dart';
import 'package:memora/core/storage/storage_keys.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'core_providers.g.dart';

@Riverpod(keepAlive: true)
GlobalKey<NavigatorState> rootNavigatorKey(Ref ref) {
  return GlobalKey<NavigatorState>(debugLabel: AppKeys.rootNavigatorKeyLabel);
}

@Riverpod(keepAlive: true)
GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey(Ref ref) {
  return GlobalKey<ScaffoldMessengerState>(
    debugLabel: AppKeys.rootScaffoldMessengerKeyLabel,
  );
}

@Riverpod(keepAlive: true)
EnvConfig envConfig(Ref ref) {
  return EnvConfig.fromEnvironment();
}

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  final envConfig = ref.watch(envConfigProvider);
  final networkInfo = ref.watch(networkInfoProvider);
  final secureStorage = ref.watch(secureStorageProvider);

  return ApiClient(
    baseUrl: envConfig.baseUrl,
    enableLogs: envConfig.enableNetworkLogs,
    interceptorFactories: <DioInterceptorFactory>[
      (_) => ConnectivityInterceptor(networkInfo),
      (_) => AuthInterceptor(
        tokenReader: () => secureStorage.read(StorageKeys.authToken),
      ),
      (dio) => RetryInterceptor(dio: dio),
      (_) => LoggingInterceptor(enabled: envConfig.enableNetworkLogs),
    ],
  );
}

@Riverpod(keepAlive: true)
NetworkInfo networkInfo(Ref ref) {
  return ConnectivityNetworkInfo(Connectivity());
}

@Riverpod(keepAlive: true)
PreferencesStorage preferencesStorage(Ref ref) {
  return PreferencesStorage(allowList: StorageKeys.all);
}

@Riverpod(keepAlive: true)
SecureStorage secureStorage(Ref ref) {
  return SecureStorage();
}

@Riverpod(keepAlive: true)
CacheManager cacheManager(Ref ref) {
  return CacheManager();
}
