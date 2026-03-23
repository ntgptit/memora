import 'package:flutter/foundation.dart';
import 'package:memora/core/enums/sort_direction.dart';
import 'package:memora/domain/entities/folder.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'folder_filter_provider.g.dart';

@immutable
class FolderFilterState {
  const FolderFilterState({
    this.searchQuery = '',
    this.sortBy = FolderSortField.name,
    this.sortDirection = SortDirection.asc,
  });

  final String searchQuery;
  final FolderSortField sortBy;
  final SortDirection sortDirection;

  FolderFilterState copyWith({
    String? searchQuery,
    FolderSortField? sortBy,
    SortDirection? sortDirection,
  }) {
    return FolderFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      sortDirection: sortDirection ?? this.sortDirection,
    );
  }
}

@Riverpod(keepAlive: false)
class FolderFilterController extends _$FolderFilterController {
  @override
  FolderFilterState build() {
    return const FolderFilterState();
  }

  void setSearchQuery(String value) {
    final normalized = value.trim();
    if (normalized == state.searchQuery) {
      return;
    }
    state = state.copyWith(searchQuery: normalized);
  }

  void setSortBy(FolderSortField sortBy) {
    if (sortBy == state.sortBy) {
      return;
    }
    state = state.copyWith(sortBy: sortBy);
  }

  void toggleSortDirection() {
    state = state.copyWith(sortDirection: state.sortDirection.toggled);
  }

  void clearSearch() {
    if (state.searchQuery.isEmpty) {
      return;
    }
    state = state.copyWith(searchQuery: '');
  }
}
