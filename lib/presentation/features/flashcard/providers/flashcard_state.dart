import 'package:flutter/foundation.dart';
import 'package:memora/core/enums/sort_direction.dart';
import 'package:memora/domain/entities/deck.dart';
import 'package:memora/domain/entities/flashcard.dart';

@immutable
class FlashcardRouteContext {
  const FlashcardRouteContext({required this.folderId, required this.deckId});

  final int folderId;
  final int deckId;

  @override
  bool operator ==(Object other) {
    return other is FlashcardRouteContext &&
        other.folderId == folderId &&
        other.deckId == deckId;
  }

  @override
  int get hashCode => Object.hash(folderId, deckId);
}

@immutable
class FlashcardState {
  const FlashcardState({
    required this.currentDeck,
    required this.flashcards,
    required this.searchQuery,
    required this.sortBy,
    required this.sortDirection,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
    required this.isLoadingMore,
    this.errorMessage,
  });

  final Deck currentDeck;
  final List<Flashcard> flashcards;
  final String searchQuery;
  final FlashcardSortField sortBy;
  final SortDirection sortDirection;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;
  final bool isLoadingMore;
  final String? errorMessage;

  bool get isEmpty => flashcards.isEmpty;

  bool get canLoadMore => hasNext && !isLoadingMore;

  FlashcardState copyWith({
    Deck? currentDeck,
    List<Flashcard>? flashcards,
    String? searchQuery,
    FlashcardSortField? sortBy,
    SortDirection? sortDirection,
    int? page,
    int? size,
    int? totalElements,
    int? totalPages,
    bool? hasNext,
    bool? hasPrevious,
    bool? isLoadingMore,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return FlashcardState(
      currentDeck: currentDeck ?? this.currentDeck,
      flashcards: flashcards ?? this.flashcards,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      sortDirection: sortDirection ?? this.sortDirection,
      page: page ?? this.page,
      size: size ?? this.size,
      totalElements: totalElements ?? this.totalElements,
      totalPages: totalPages ?? this.totalPages,
      hasNext: hasNext ?? this.hasNext,
      hasPrevious: hasPrevious ?? this.hasPrevious,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
    );
  }
}
