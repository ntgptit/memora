import 'package:memora/data/models/flashcard_model.dart';
import 'package:memora/data/models/flashcard_page_model.dart';
import 'package:memora/domain/entities/flashcard.dart';

abstract final class FlashcardMapper {
  static Flashcard toEntity(FlashcardModel model) {
    return Flashcard(
      id: model.id,
      deckId: model.deckId,
      frontText: model.frontText,
      backText: model.backText,
      frontLangCode: model.frontLangCode,
      backLangCode: model.backLangCode,
      pronunciation: model.pronunciation,
      note: model.note,
      isBookmarked: model.isBookmarked,
    );
  }

  static FlashcardPage toPageEntity(FlashcardPageModel model) {
    return FlashcardPage(
      items: model.items.map(toEntity).toList(growable: false),
      page: model.page,
      size: model.size,
      totalElements: model.totalElements,
      totalPages: model.totalPages,
      hasNext: model.hasNext,
      hasPrevious: model.hasPrevious,
    );
  }
}
