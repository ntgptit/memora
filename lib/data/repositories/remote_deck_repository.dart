import 'package:memora/core/enums/sort_direction.dart';
import 'package:memora/data/datasources/deck_api.dart';
import 'package:memora/data/mappers/deck_mapper.dart';
import 'package:memora/domain/entities/deck.dart';
import 'package:memora/domain/repositories/deck_repository.dart';

class RemoteDeckRepository implements DeckRepository {
  const RemoteDeckRepository(this._deckApi);

  final DeckApi _deckApi;

  @override
  Future<Deck> createDeck({
    required int folderId,
    required String name,
    String? description,
  }) async {
    final deck = await _deckApi.createDeck(folderId, <String, Object?>{
      'name': name,
      'description': description,
    });
    return DeckMapper.toEntity(deck);
  }

  @override
  Future<void> deleteDeck({required int folderId, required int deckId}) {
    return _deckApi.deleteDeck(folderId, deckId);
  }

  @override
  Future<Deck> getDeck({required int folderId, required int deckId}) async {
    final deck = await _deckApi.getDeck(folderId, deckId);
    return DeckMapper.toEntity(deck);
  }

  @override
  Future<List<Deck>> getDecks({
    required int folderId,
    String? searchQuery,
    DeckSortField sortBy = DeckSortField.name,
    SortDirection sortDirection = SortDirection.asc,
    int page = 0,
    int size = 20,
  }) async {
    final decks = await _deckApi.getDecks(
      folderId,
      searchQuery: searchQuery,
      sortBy: sortBy.apiValue,
      sortType: sortDirection.name.toUpperCase(),
      page: page,
      size: size,
    );
    return decks.map(DeckMapper.toEntity).toList(growable: false);
  }

  @override
  Future<Deck> updateDeck({
    required int folderId,
    required int deckId,
    required String name,
    String? description,
  }) async {
    final deck = await _deckApi.updateDeck(folderId, deckId, <String, Object?>{
      'name': name,
      'description': description,
    });
    return DeckMapper.toEntity(deck);
  }
}
