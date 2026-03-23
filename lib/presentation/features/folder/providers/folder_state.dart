import 'package:flutter/foundation.dart';
import 'package:memora/core/enums/sort_direction.dart';
import 'package:memora/domain/entities/folder.dart';

@immutable
class FolderState {
  const FolderState({
    required this.currentFolder,
    required this.breadcrumbFolders,
    required this.folders,
    required this.searchQuery,
    required this.sortBy,
    required this.sortDirection,
    this.errorMessage,
  });

  final Folder? currentFolder;
  final List<Folder> breadcrumbFolders;
  final List<Folder> folders;
  final String searchQuery;
  final FolderSortField sortBy;
  final SortDirection sortDirection;
  final String? errorMessage;

  bool get isRoot => currentFolder == null;
  bool get isEmpty => folders.isEmpty;

  FolderState copyWith({
    Folder? currentFolder,
    List<Folder>? breadcrumbFolders,
    List<Folder>? folders,
    String? searchQuery,
    FolderSortField? sortBy,
    SortDirection? sortDirection,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return FolderState(
      currentFolder: currentFolder ?? this.currentFolder,
      breadcrumbFolders: breadcrumbFolders ?? this.breadcrumbFolders,
      folders: folders ?? this.folders,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      sortDirection: sortDirection ?? this.sortDirection,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }
}
