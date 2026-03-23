import 'package:memora/core/enums/sort_direction.dart';
import 'package:memora/domain/entities/deck.dart';
import 'package:memora/domain/repositories/deck_repository.dart';

class ListDecksUseCase {
  const ListDecksUseCase(this._repository);

  final DeckRepository _repository;

  Future<List<Deck>> call({
    required int folderId,
    String? searchQuery,
    required DeckSortField sortBy,
    required SortDirection sortDirection,
    required int page,
    required int size,
  }) {
    return _repository.getDecks(
      folderId: folderId,
      searchQuery: searchQuery,
      sortBy: sortBy,
      sortDirection: sortDirection,
      page: page,
      size: size,
    );
  }
}

class CreateDeckUseCase {
  const CreateDeckUseCase(this._repository);

  final DeckRepository _repository;

  Future<Deck> call({
    required int folderId,
    required String name,
    String? description,
  }) {
    return _repository.createDeck(
      folderId: folderId,
      name: name,
      description: description,
    );
  }
}

class UpdateDeckUseCase {
  const UpdateDeckUseCase(this._repository);

  final DeckRepository _repository;

  Future<Deck> call({
    required int folderId,
    required int deckId,
    required String name,
    String? description,
  }) {
    return _repository.updateDeck(
      folderId: folderId,
      deckId: deckId,
      name: name,
      description: description,
    );
  }
}

class DeleteDeckUseCase {
  const DeleteDeckUseCase(this._repository);

  final DeckRepository _repository;

  Future<void> call({required int folderId, required int deckId}) {
    return _repository.deleteDeck(folderId: folderId, deckId: deckId);
  }
}
