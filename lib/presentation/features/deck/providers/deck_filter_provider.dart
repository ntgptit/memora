import 'package:flutter/foundation.dart';
import 'package:memora/core/enums/sort_direction.dart';
import 'package:memora/domain/entities/deck.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'deck_filter_provider.g.dart';

@immutable
class DeckFilterState {
  const DeckFilterState({
    this.searchQuery = '',
    this.sortBy = DeckSortField.name,
    this.sortDirection = SortDirection.asc,
  });

  final String searchQuery;
  final DeckSortField sortBy;
  final SortDirection sortDirection;

  DeckFilterState copyWith({
    String? searchQuery,
    DeckSortField? sortBy,
    SortDirection? sortDirection,
  }) {
    return DeckFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      sortDirection: sortDirection ?? this.sortDirection,
    );
  }
}

@Riverpod(keepAlive: false)
class DeckFilterController extends _$DeckFilterController {
  @override
  DeckFilterState build() {
    return const DeckFilterState();
  }

  void setSearchQuery(String value) {
    final normalized = value.trim();
    if (normalized == state.searchQuery) {
      return;
    }
    state = state.copyWith(searchQuery: normalized);
  }

  void setSortBy(DeckSortField sortBy) {
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
