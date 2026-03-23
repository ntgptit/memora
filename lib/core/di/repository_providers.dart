import 'package:memora/core/di/datasource_providers.dart';
import 'package:memora/core/di/core_providers.dart';
import 'package:memora/data/repositories/remote_auth_repository.dart';
import 'package:memora/data/repositories/remote_deck_repository.dart';
import 'package:memora/data/repositories/remote_flashcard_repository.dart';
import 'package:memora/data/repositories/remote_folder_repository.dart';
import 'package:memora/domain/repositories/auth_repository.dart';
import 'package:memora/domain/repositories/deck_repository.dart';
import 'package:memora/domain/repositories/flashcard_repository.dart';
import 'package:memora/domain/repositories/folder_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_providers.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  final authApi = ref.watch(authApiProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return RemoteAuthRepository(authApi, secureStorage);
}

@Riverpod(keepAlive: true)
FolderRepository folderRepository(Ref ref) {
  final folderApi = ref.watch(folderApiProvider);
  return RemoteFolderRepository(folderApi);
}

@Riverpod(keepAlive: true)
DeckRepository deckRepository(Ref ref) {
  final deckApi = ref.watch(deckApiProvider);
  return RemoteDeckRepository(deckApi);
}

@Riverpod(keepAlive: true)
FlashcardRepository flashcardRepository(Ref ref) {
  final flashcardApi = ref.watch(flashcardApiProvider);
  return RemoteFlashcardRepository(flashcardApi);
}
