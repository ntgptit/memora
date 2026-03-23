import 'package:memora/core/enums/sort_direction.dart';
import 'package:memora/domain/entities/deck.dart';

abstract interface class DeckRepository {
  Future<List<Deck>> getDecks({
    required int folderId,
    String? searchQuery,
    DeckSortField sortBy = DeckSortField.name,
    SortDirection sortDirection = SortDirection.asc,
    int page = 0,
    int size = 20,
  });

  Future<Deck> getDeck({required int folderId, required int deckId});

  Future<Deck> createDeck({
    required int folderId,
    required String name,
    String? description,
  });

  Future<Deck> updateDeck({
    required int folderId,
    required int deckId,
    required String name,
    String? description,
  });

  Future<void> deleteDeck({required int folderId, required int deckId});
}
