import 'package:memora/core/enums/sort_direction.dart';
import 'package:memora/domain/entities/flashcard.dart';

abstract interface class FlashcardRepository {
  Future<FlashcardPage> getFlashcards({
    required int deckId,
    String? searchQuery,
    FlashcardSortField sortBy = FlashcardSortField.updatedAt,
    SortDirection sortDirection = SortDirection.desc,
    int page = 0,
    int size = 20,
  });

  Future<Flashcard> createFlashcard({
    required int deckId,
    required String frontText,
    required String backText,
    String? frontLangCode,
    String? backLangCode,
  });

  Future<Flashcard> updateFlashcard({
    required int deckId,
    required int flashcardId,
    required String frontText,
    required String backText,
    String? frontLangCode,
    String? backLangCode,
  });

  Future<void> deleteFlashcard({required int deckId, required int flashcardId});
}
