import 'package:memora/core/enums/sort_direction.dart';
import 'package:memora/data/datasources/deck_api.dart';
import 'package:memora/data/mappers/deck_mapper.dart';
import 'package:memora/data/models/deck_requests.dart';
import 'package:memora/domain/entities/deck.dart';
import 'package:memora/domain/repositories/deck_repository.dart';

class DeckRepositoryImpl implements DeckRepository {
  DeckRepositoryImpl(this._api);

  final DeckApi _api;

  @override
  Future<List<Deck>> getDecks({
    required int folderId,
    String? searchQuery,
    DeckSortField sortBy = DeckSortField.name,
    SortDirection sortDirection = SortDirection.asc,
    int page = 0,
    int size = 20,
  }) async {
    final response = await _api.getDecks(
      folderId,
      searchQuery: searchQuery,
      sortBy: sortBy.apiValue,
      sortType: sortDirection.name.toUpperCase(),
      page: page,
      size: size,
    );

    return response.map(DeckMapper.toEntity).toList(growable: false);
  }

  @override
  Future<Deck> getDeck({required int folderId, required int deckId}) async {
    final response = await _api.getDeck(folderId, deckId);
    return DeckMapper.toEntity(response);
  }

  @override
  Future<Deck> createDeck({
    required int folderId,
    required String name,
    String? description,
  }) async {
    final response = await _api.createDeck(
      folderId,
      CreateDeckRequest(name: name, description: description).toJson(),
    );
    return DeckMapper.toEntity(response);
  }

  @override
  Future<Deck> updateDeck({
    required int folderId,
    required int deckId,
    required String name,
    String? description,
  }) async {
    final response = await _api.updateDeck(
      folderId,
      deckId,
      UpdateDeckRequest(name: name, description: description).toJson(),
    );
    return DeckMapper.toEntity(response);
  }

  @override
  Future<void> deleteDeck({required int folderId, required int deckId}) {
    return _api.deleteDeck(folderId, deckId);
  }
}
