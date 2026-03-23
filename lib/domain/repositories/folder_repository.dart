import 'package:memora/core/enums/sort_direction.dart';
import 'package:memora/domain/entities/folder.dart';

abstract interface class FolderRepository {
  Future<List<Folder>> getFolders({
    int? parentId,
    String? searchQuery,
    FolderSortField sortBy = FolderSortField.name,
    SortDirection sortDirection = SortDirection.asc,
    int page = 0,
    int size = 20,
  });

  Future<Folder> getFolder(int folderId);

  Future<Folder> createFolder({
    required String name,
    String? description,
    int? parentId,
  });

  Future<Folder> renameFolder({required int folderId, required String name});

  Future<Folder> updateFolder({
    required int folderId,
    required String name,
    String? description,
    int? parentId,
  });

  Future<void> deleteFolder(int folderId);
}
