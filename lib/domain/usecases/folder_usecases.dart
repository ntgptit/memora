import 'package:memora/core/enums/sort_direction.dart';
import 'package:memora/domain/entities/folder.dart';
import 'package:memora/domain/repositories/folder_repository.dart';

class ListFoldersUseCase {
  const ListFoldersUseCase(this._repository);

  final FolderRepository _repository;

  Future<List<Folder>> call({
    int? parentId,
    String? searchQuery,
    required FolderSortField sortBy,
    required SortDirection sortDirection,
    required int page,
    required int size,
  }) {
    return _repository.getFolders(
      parentId: parentId,
      searchQuery: searchQuery,
      sortBy: sortBy,
      sortDirection: sortDirection,
      page: page,
      size: size,
    );
  }
}

class CreateFolderUseCase {
  const CreateFolderUseCase(this._repository);

  final FolderRepository _repository;

  Future<Folder> call({
    int? parentId,
    required String name,
    String? description,
  }) {
    return _repository.createFolder(
      parentId: parentId,
      name: name,
      description: description,
    );
  }
}

class RenameFolderUseCase {
  const RenameFolderUseCase(this._repository);

  final FolderRepository _repository;

  Future<Folder> call({required int folderId, required String name}) {
    return _repository.renameFolder(folderId: folderId, name: name);
  }
}

class UpdateFolderUseCase {
  const UpdateFolderUseCase(this._repository);

  final FolderRepository _repository;

  Future<Folder> call({
    required int folderId,
    required String name,
    String? description,
    int? parentId,
  }) {
    return _repository.updateFolder(
      folderId: folderId,
      name: name,
      description: description,
      parentId: parentId,
    );
  }
}

class DeleteFolderUseCase {
  const DeleteFolderUseCase(this._repository);

  final FolderRepository _repository;

  Future<void> call({required int folderId}) {
    return _repository.deleteFolder(folderId);
  }
}
