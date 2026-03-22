import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'datasource_providers.g.dart';

@Riverpod(keepAlive: true)
DatasourceRegistry datasourceRegistry(Ref ref) {
  return const DatasourceRegistry();
}

@immutable
class DatasourceRegistry {
  const DatasourceRegistry({
    this.remote = const <String, Object>{},
    this.local = const <String, Object>{},
  });

  final Map<String, Object> remote;
  final Map<String, Object> local;

  bool get isEmpty => remote.isEmpty && local.isEmpty;
}
