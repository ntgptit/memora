import 'package:memora/core/config/env_config.dart';
import 'package:memora/core/network/api_client.dart';
import 'package:memora/core/network/network_info.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'core_providers.g.dart';

@Riverpod(keepAlive: true)
EnvConfig envConfig(Ref ref) {
  return EnvConfig.fromEnvironment();
}

@Riverpod(keepAlive: true)
ApiClient apiClient(Ref ref) {
  final envConfig = ref.watch(envConfigProvider);
  return ApiClient(
    baseUrl: envConfig.baseUrl,
    enableLogs: envConfig.enableNetworkLogs,
  );
}

@Riverpod(keepAlive: true)
NetworkInfo networkInfo(Ref ref) {
  return const AlwaysOnlineNetworkInfo();
}
