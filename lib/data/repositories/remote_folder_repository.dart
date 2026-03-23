import 'package:memora/core/enums/sort_direction.dart';
import 'package:memora/data/datasources/folder_api.dart';
import 'package:memora/data/mappers/folder_mapper.dart';
import 'package:memora/domain/entities/folder.dart';
import 'package:memora/domain/repositories/folder_repository.dart';

class RemoteFolderRepository implements FolderRepository {
  const RemoteFolderRepository(this._folderApi);

  final FolderApi _folderApi;

  @override
  Future<Folder> createFolder({
    required String name,
    String? description,
    int? parentId,
  }) async {
    final folder = await _folderApi.createFolder(<String, Object?>{
      'name': name,
      'description': description,
      'parentId': parentId,
    });
    return FolderMapper.toEntity(folder);
  }

  @override
  Future<void> deleteFolder(int folderId) {
    return _folderApi.deleteFolder(folderId);
  }

  @override
  Future<Folder> getFolder(int folderId) async {
    final folder = await _folderApi.getFolder(folderId);
    return FolderMapper.toEntity(folder);
  }

  @override
  Future<List<Folder>> getFolders({
    int? parentId,
    String? searchQuery,
    FolderSortField sortBy = FolderSortField.name,
    SortDirection sortDirection = SortDirection.asc,
    int page = 0,
    int size = 20,
  }) async {
    final folders = await _folderApi.getFolders(
      parentId: parentId,
      searchQuery: searchQuery,
      sortBy: sortBy.apiValue,
      sortType: sortDirection.name.toUpperCase(),
      page: page,
      size: size,
    );
    return folders.map(FolderMapper.toEntity).toList(growable: false);
  }

  @override
  Future<Folder> renameFolder({
    required int folderId,
    required String name,
  }) async {
    final folder = await _folderApi.renameFolder(folderId, <String, Object?>{
      'name': name,
    });
    return FolderMapper.toEntity(folder);
  }

  @override
  Future<Folder> updateFolder({
    required int folderId,
    required String name,
    String? description,
    int? parentId,
  }) async {
    final folder = await _folderApi.updateFolder(folderId, <String, Object?>{
      'name': name,
      'description': description,
      'parentId': parentId,
    });
    return FolderMapper.toEntity(folder);
  }
}
