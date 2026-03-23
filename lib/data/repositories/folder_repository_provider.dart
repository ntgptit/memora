import 'package:memora/core/di/core_providers.dart';
import 'package:memora/data/datasources/folder_api.dart';
import 'package:memora/data/repositories/folder_repository_impl.dart';
import 'package:memora/domain/repositories/folder_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'folder_repository_provider.g.dart';

@Riverpod(keepAlive: true)
FolderRepository folderRepository(Ref ref) {
  final apiClient = ref.watch(apiClientProvider);
  return FolderRepositoryImpl(apiClient.createService(FolderApi.new));
}
