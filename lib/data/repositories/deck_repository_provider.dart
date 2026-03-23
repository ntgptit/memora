import 'package:memora/core/di/core_providers.dart';
import 'package:memora/data/datasources/deck_api.dart';
import 'package:memora/data/repositories/deck_repository_impl.dart';
import 'package:memora/domain/repositories/deck_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'deck_repository_provider.g.dart';

@Riverpod(keepAlive: true)
DeckRepository deckRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return DeckRepositoryImpl(apiClient.createService(DeckApi.new));
}
