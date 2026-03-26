import 'package:dio/dio.dart';
import 'package:memora/data/models/folder_model.dart';
import 'package:memora/data/models/folder_requests.dart';
import 'package:retrofit/retrofit.dart';

part 'folder_api.g.dart';

@RestApi()
abstract class FolderApi {
  factory FolderApi(Dio dio, {String? baseUrl}) = _FolderApi;

  @GET('/api/v1/folders')
  Future<List<FolderModel>> getFolders({
    @Query('parentId') int? parentId,
    @Query('searchQuery') String? searchQuery,
    @Query('sortBy') String? sortBy,
    @Query('sortType') String? sortType,
    @Query('page') int? page,
    @Query('size') int? size,
  });

  @GET('/api/v1/folders/{folderId}')
  Future<FolderModel> getFolder(@Path('folderId') int folderId);

  @POST('/api/v1/folders')
  Future<FolderModel> createFolder(@Body() CreateFolderRequest body);

  @PATCH('/api/v1/folders/{folderId}/rename')
  Future<FolderModel> renameFolder(
    @Path('folderId') int folderId,
    @Body() RenameFolderRequest body,
  );

  @PUT('/api/v1/folders/{folderId}')
  Future<FolderModel> updateFolder(
    @Path('folderId') int folderId,
    @Body() UpdateFolderRequest body,
  );

  @DELETE('/api/v1/folders/{folderId}')
  Future<void> deleteFolder(@Path('folderId') int folderId);
}
