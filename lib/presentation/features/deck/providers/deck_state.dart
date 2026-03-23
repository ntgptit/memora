import 'package:flutter/foundation.dart';
import 'package:memora/core/enums/sort_direction.dart';
import 'package:memora/domain/entities/deck.dart';
import 'package:memora/domain/entities/folder.dart';

@immutable
class DeckState {
  const DeckState({
    required this.currentFolder,
    required this.breadcrumbFolders,
    required this.decks,
    required this.searchQuery,
    required this.sortBy,
    required this.sortDirection,
    this.errorMessage,
  });

  final Folder currentFolder;
  final List<Folder> breadcrumbFolders;
  final List<Deck> decks;
  final String searchQuery;
  final DeckSortField sortBy;
  final SortDirection sortDirection;
  final String? errorMessage;

  bool get isEmpty => decks.isEmpty;
  int get totalFlashcardCount {
    return decks.fold<int>(0, (sum, deck) => sum + deck.flashcardCount);
  }

  DeckState copyWith({
    Folder? currentFolder,
    List<Folder>? breadcrumbFolders,
    List<Deck>? decks,
    String? searchQuery,
    DeckSortField? sortBy,
    SortDirection? sortDirection,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return DeckState(
      currentFolder: currentFolder ?? this.currentFolder,
      breadcrumbFolders: breadcrumbFolders ?? this.breadcrumbFolders,
      decks: decks ?? this.decks,
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      sortDirection: sortDirection ?? this.sortDirection,
      errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }
}
