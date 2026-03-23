import 'package:flutter_test/flutter_test.dart';
import 'package:memora/data/mappers/flashcard_mapper.dart';
import 'package:memora/data/models/flashcard_page_model.dart';

void main() {
  test('FlashcardMapper maps paged api payload to domain entities', () {
    final pageModel = FlashcardPageModel.fromJson(<String, Object?>{
      'items': [
        <String, Object?>{
          'id': 1,
          'deckId': 10,
          'frontText': 'Front',
          'backText': 'Back',
          'frontLangCode': 'en',
          'backLangCode': 'vi',
          'pronunciation': 'pron',
          'note': 'note',
          'isBookmarked': true,
          'audit': <String, Object?>{
            'createdAt': '2025-01-01T00:00:00Z',
            'updatedAt': '2025-01-02T00:00:00Z',
            'version': 1,
          },
        },
      ],
      'page': 0,
      'size': 20,
      'totalElements': 1,
      'totalPages': 1,
      'hasNext': false,
      'hasPrevious': false,
    });

    final page = FlashcardMapper.toPageEntity(pageModel);

    expect(page.items, hasLength(1));
    final flashcard = page.items.single;
    expect(flashcard.frontText, 'Front');
    expect(flashcard.backText, 'Back');
    expect(flashcard.frontLangCode, 'en');
    expect(flashcard.backLangCode, 'vi');
    expect(flashcard.pronunciation, 'pron');
    expect(flashcard.note, 'note');
    expect(flashcard.isBookmarked, isTrue);
    expect(page.hasNext, isFalse);
  });
}
