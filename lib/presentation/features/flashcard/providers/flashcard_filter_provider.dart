import 'package:flutter/foundation.dart';
import 'package:memora/core/enums/sort_direction.dart';
import 'package:memora/domain/entities/flashcard.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'flashcard_filter_provider.g.dart';

@immutable
class FlashcardFilterState {
  const FlashcardFilterState({
    this.searchQuery = '',
    this.sortBy = FlashcardSortField.updatedAt,
    this.sortDirection = SortDirection.desc,
  });

  final String searchQuery;
  final FlashcardSortField sortBy;
  final SortDirection sortDirection;

  FlashcardFilterState copyWith({
    String? searchQuery,
    FlashcardSortField? sortBy,
    SortDirection? sortDirection,
  }) {
    return FlashcardFilterState(
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      sortDirection: sortDirection ?? this.sortDirection,
    );
  }
}

@Riverpod(keepAlive: false)
class FlashcardFilterController extends _$FlashcardFilterController {
  @override
  FlashcardFilterState build() {
    return const FlashcardFilterState();
  }

  void setSearchQuery(String value) {
    final normalized = value.trim();
    if (normalized == state.searchQuery) {
      return;
    }
    state = state.copyWith(searchQuery: normalized);
  }

  void setSortBy(FlashcardSortField sortBy) {
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
