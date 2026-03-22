import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_providers.g.dart';

@Riverpod(keepAlive: true)
RepositoryRegistry repositoryRegistry(Ref ref) {
  return const RepositoryRegistry();
}

@immutable
class RepositoryRegistry {
  const RepositoryRegistry({this.repositories = const <String, Object>{}});

  final Map<String, Object> repositories;

  bool get isEmpty => repositories.isEmpty;
}
