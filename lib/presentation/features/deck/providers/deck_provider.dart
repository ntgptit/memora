import 'dart:async';

import 'package:memora/core/di/repository_providers.dart';
import 'package:memora/core/errors/error_mapper.dart';
import 'package:memora/domain/entities/folder.dart';
import 'package:memora/domain/repositories/deck_repository.dart';
import 'package:memora/domain/repositories/folder_repository.dart';
import 'package:memora/presentation/features/deck/providers/deck_filter_provider.dart';
import 'package:memora/presentation/features/deck/providers/deck_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'deck_provider.g.dart';

@Riverpod(keepAlive: false)
class DeckController extends _$DeckController {
  DeckRepository get _deckRepository => ref.read(deckRepositoryProvider);
  FolderRepository get _folderRepository => ref.read(folderRepositoryProvider);

  int? _folderId;

  @override
  FutureOr<DeckState> build(int folderId) async {
    _folderId = folderId;
    final filter = ref.watch(deckFilterControllerProvider);
    return _loadState(folderId: folderId, filter: filter);
  }

  Future<void> refresh() async {
    await _reload();
  }

  Future<void> createDeck({required String name, String? description}) async {
    final folderId = _requireFolderId();
    await _runMutation(() async {
      await _deckRepository.createDeck(
        folderId: folderId,
        name: name,
        description: description,
      );
    });
  }

  Future<void> updateDeck({
    required int deckId,
    required String name,
    String? description,
  }) async {
    final folderId = _requireFolderId();
    await _runMutation(() async {
      await _deckRepository.updateDeck(
        folderId: folderId,
        deckId: deckId,
        name: name,
        description: description,
      );
    });
  }

  Future<void> deleteDeck(int deckId) async {
    final folderId = _requireFolderId();
    await _runMutation(() async {
      await _deckRepository.deleteDeck(folderId: folderId, deckId: deckId);
    });
  }

  int _requireFolderId() {
    final folderId = _folderId;
    if (folderId == null) {
      throw StateError('DeckController folderId is not initialized.');
    }
    return folderId;
  }

  Future<DeckState> _loadState({
    required int folderId,
    required DeckFilterState filter,
    String? errorMessage,
  }) async {
    final currentFolder = await _folderRepository.getFolder(folderId);
    final decks = await _deckRepository.getDecks(
      folderId: folderId,
      searchQuery: filter.searchQuery.isEmpty ? null : filter.searchQuery,
      sortBy: filter.sortBy,
      sortDirection: filter.sortDirection,
      page: 0,
      size: 20,
    );
    final breadcrumbFolders = await _loadBreadcrumbFolders(currentFolder);

    return DeckState(
      currentFolder: currentFolder,
      breadcrumbFolders: breadcrumbFolders,
      decks: decks,
      searchQuery: filter.searchQuery,
      sortBy: filter.sortBy,
      sortDirection: filter.sortDirection,
      errorMessage: errorMessage,
    );
  }

  Future<List<Folder>> _loadBreadcrumbFolders(Folder currentFolder) async {
    final breadcrumbs = <Folder>[currentFolder];
    var activeFolder = currentFolder;

    while (activeFolder.parentId != null) {
      activeFolder = await _folderRepository.getFolder(activeFolder.parentId!);
      breadcrumbs.add(activeFolder);
    }

    return breadcrumbs.reversed.toList(growable: false);
  }

  Future<void> _reload({String? errorMessage}) async {
    final folderId = _requireFolderId();
    final filter = ref.read(deckFilterControllerProvider);
    state = const AsyncLoading<DeckState>();
    state = await AsyncValue.guard(
      () => _loadState(
        folderId: folderId,
        filter: filter,
        errorMessage: errorMessage,
      ),
    );
  }

  Future<void> _runMutation(Future<void> Function() action) async {
    try {
      await action();
      await _reload();
    } catch (error, stackTrace) {
      final failure = ErrorMapper.map(error, stackTrace: stackTrace);
      await _reload(errorMessage: failure.message);
    }
  }
}
