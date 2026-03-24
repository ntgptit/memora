import 'dart:async';

import 'package:memora/core/di/repository_providers.dart';
import 'package:memora/core/errors/error_mapper.dart';
import 'package:memora/domain/entities/folder.dart';
import 'package:memora/domain/repositories/folder_repository.dart';
import 'package:memora/presentation/features/folder/providers/folder_filter_provider.dart';
import 'package:memora/presentation/features/folder/providers/folder_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'folder_provider.g.dart';

@Riverpod(keepAlive: false)
class FolderController extends _$FolderController {
  FolderRepository get _folderRepository => ref.read(folderRepositoryProvider);

  int? _folderId;

  @override
  FutureOr<FolderState> build(int? folderId) async {
    _folderId = folderId;
    final filter = ref.watch(folderFilterControllerProvider);
    return _loadState(folderId: folderId, filter: filter);
  }

  Future<void> refresh() async {
    await _reload();
  }

  Future<void> createFolder({required String name, String? description}) async {
    await _runMutation(() async {
      await _folderRepository.createFolder(
        name: name,
        description: description,
        parentId: _folderId,
      );
    });
  }

  Future<void> renameFolder({
    required int targetFolderId,
    required String name,
  }) async {
    await _runMutation(() async {
      await _folderRepository.renameFolder(
        folderId: targetFolderId,
        name: name,
      );
    });
  }

  Future<void> updateFolder({
    required int targetFolderId,
    required String name,
    String? description,
  }) async {
    await _runMutation(() async {
      final targetFolder = _findFolder(targetFolderId);
      await _folderRepository.updateFolder(
        folderId: targetFolderId,
        name: name,
        description: description,
        parentId: targetFolder?.parentId ?? _folderId,
      );
    });
  }

  Future<void> deleteFolder(int targetFolderId) async {
    await _runMutation(() async {
      await _folderRepository.deleteFolder(targetFolderId);
    });
  }

  Folder? _findFolder(int folderId) {
    final currentState = state.value;
    if (currentState == null) {
      return null;
    }

    final currentFolder = currentState.currentFolder;
    if (currentFolder != null && currentFolder.id == folderId) {
      return currentFolder;
    }

    for (final folder in currentState.folders) {
      if (folder.id == folderId) {
        return folder;
      }
    }

    return null;
  }

  Future<FolderState> _loadState({
    required int? folderId,
    required FolderFilterState filter,
    String? errorMessage,
  }) async {
    final currentFolder = folderId == null
        ? null
        : await _folderRepository.getFolder(folderId);
    final folders = await _folderRepository.getFolders(
      parentId: folderId,
      searchQuery: filter.searchQuery.isEmpty ? null : filter.searchQuery,
      sortBy: filter.sortBy,
      sortDirection: filter.sortDirection,
      page: 0,
      size: 20,
    );
    final breadcrumbFolders = await _loadBreadcrumbFolders(currentFolder);

    return FolderState(
      currentFolder: currentFolder,
      breadcrumbFolders: breadcrumbFolders,
      folders: folders,
      searchQuery: filter.searchQuery,
      sortBy: filter.sortBy,
      sortDirection: filter.sortDirection,
      errorMessage: errorMessage,
    );
  }

  Future<List<Folder>> _loadBreadcrumbFolders(Folder? currentFolder) async {
    if (currentFolder == null) {
      return const <Folder>[];
    }

    final breadcrumbs = <Folder>[currentFolder];
    var activeFolder = currentFolder;

    while (activeFolder.parentId != null) {
      activeFolder = await _folderRepository.getFolder(activeFolder.parentId!);
      breadcrumbs.add(activeFolder);
    }

    return breadcrumbs.reversed.toList(growable: false);
  }

  Future<void> _reload({String? errorMessage}) async {
    final folderId = _folderId;
    final filter = ref.read(folderFilterControllerProvider);
    state = const AsyncLoading<FolderState>();
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
