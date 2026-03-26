import 'package:memora/core/enums/sort_direction.dart';
import 'package:memora/data/datasources/folder_api.dart';
import 'package:memora/data/mappers/folder_mapper.dart';
import 'package:memora/data/models/folder_requests.dart';
import 'package:memora/domain/entities/folder.dart';
import 'package:memora/domain/repositories/folder_repository.dart';

class FolderRepositoryImpl implements FolderRepository {
  FolderRepositoryImpl(this._api);

  final FolderApi _api;

  @override
  Future<List<Folder>> getFolders({
    int? parentId,
    String? searchQuery,
    FolderSortField sortBy = FolderSortField.name,
    SortDirection sortDirection = SortDirection.asc,
    int page = 0,
    int size = 20,
  }) async {
    final response = await _api.getFolders(
      parentId: parentId,
      searchQuery: searchQuery,
      sortBy: sortBy.apiValue,
      sortType: sortDirection.name.toUpperCase(),
      page: page,
      size: size,
    );

    return response.map(FolderMapper.toEntity).toList(growable: false);
  }

  @override
  Future<Folder> getFolder(int folderId) async {
    final response = await _api.getFolder(folderId);
    return FolderMapper.toEntity(response);
  }

  @override
  Future<Folder> createFolder({
    required String name,
    String? description,
    int? parentId,
  }) async {
    final response = await _api.createFolder(
      CreateFolderRequest(
        name: name,
        description: description,
        parentId: parentId,
      ),
    );
    return FolderMapper.toEntity(response);
  }

  @override
  Future<Folder> renameFolder({
    required int folderId,
    required String name,
  }) async {
    final response = await _api.renameFolder(
      folderId,
      RenameFolderRequest(name: name),
    );
    return FolderMapper.toEntity(response);
  }

  @override
  Future<Folder> updateFolder({
    required int folderId,
    required String name,
    String? description,
    int? parentId,
  }) async {
    final response = await _api.updateFolder(
      folderId,
      UpdateFolderRequest(
        name: name,
        description: description,
        parentId: parentId,
      ),
    );
    return FolderMapper.toEntity(response);
  }

  @override
  Future<void> deleteFolder(int folderId) {
    return _api.deleteFolder(folderId);
  }
}
