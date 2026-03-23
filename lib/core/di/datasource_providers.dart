import 'package:memora/core/di/core_providers.dart';
import 'package:memora/data/datasources/flashcard_api.dart';
import 'package:memora/data/datasources/deck_api.dart';
import 'package:memora/data/datasources/folder_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'datasource_providers.g.dart';

@Riverpod(keepAlive: true)
FolderApi folderApi(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return apiClient.createService(FolderApi.new);
}

@Riverpod(keepAlive: true)
DeckApi deckApi(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return apiClient.createService(DeckApi.new);
}

@Riverpod(keepAlive: true)
FlashcardApi flashcardApi(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return apiClient.createService(FlashcardApi.new);
}
