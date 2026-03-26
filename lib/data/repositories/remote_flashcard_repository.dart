import 'package:memora/core/enums/sort_direction.dart';
import 'package:memora/data/datasources/flashcard_api.dart';
import 'package:memora/data/mappers/flashcard_mapper.dart';
import 'package:memora/data/models/flashcard_requests.dart';
import 'package:memora/domain/entities/flashcard.dart';
import 'package:memora/domain/repositories/flashcard_repository.dart';

class RemoteFlashcardRepository implements FlashcardRepository {
  const RemoteFlashcardRepository(this._flashcardApi);

  final FlashcardApi _flashcardApi;

  @override
  Future<Flashcard> createFlashcard({
    required int deckId,
    required String frontText,
    required String backText,
    String? frontLangCode,
    String? backLangCode,
  }) async {
    final flashcard = await _flashcardApi.createFlashcard(
      deckId,
      CreateFlashcardRequest(
        frontText: frontText,
        backText: backText,
        frontLangCode: frontLangCode,
        backLangCode: backLangCode,
      ),
    );
    return FlashcardMapper.toEntity(flashcard);
  }

  @override
  Future<void> deleteFlashcard({
    required int deckId,
    required int flashcardId,
  }) {
    return _flashcardApi.deleteFlashcard(deckId, flashcardId);
  }

  @override
  Future<FlashcardPage> getFlashcards({
    required int deckId,
    String? searchQuery,
    FlashcardSortField sortBy = FlashcardSortField.updatedAt,
    SortDirection sortDirection = SortDirection.desc,
    int page = 0,
    int size = 20,
  }) async {
    final result = await _flashcardApi.getFlashcards(
      deckId,
      searchQuery: searchQuery,
      sortBy: sortBy.apiValue,
      sortType: sortDirection.name.toUpperCase(),
      page: page,
      size: size,
    );
    return FlashcardMapper.toPageEntity(result);
  }

  @override
  Future<Flashcard> updateFlashcard({
    required int deckId,
    required int flashcardId,
    required String frontText,
    required String backText,
    String? frontLangCode,
    String? backLangCode,
  }) async {
    final flashcard = await _flashcardApi.updateFlashcard(
      deckId,
      flashcardId,
      UpdateFlashcardRequest(
        frontText: frontText,
        backText: backText,
        frontLangCode: frontLangCode,
        backLangCode: backLangCode,
      ),
    );
    return FlashcardMapper.toEntity(flashcard);
  }
}
