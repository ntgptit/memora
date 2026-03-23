import 'package:flutter/foundation.dart';

@immutable
class Flashcard {
  const Flashcard({
    required this.id,
    required this.deckId,
    required this.frontText,
    required this.backText,
    required this.frontLangCode,
    required this.backLangCode,
    required this.pronunciation,
    required this.note,
    required this.isBookmarked,
  });

  final int id;
  final int deckId;
  final String frontText;
  final String backText;
  final String? frontLangCode;
  final String? backLangCode;
  final String? pronunciation;
  final String? note;
  final bool isBookmarked;

  bool get hasFrontLangCode => frontLangCode?.trim().isNotEmpty == true;
  bool get hasBackLangCode => backLangCode?.trim().isNotEmpty == true;
  bool get hasPronunciation => pronunciation?.trim().isNotEmpty == true;
  bool get hasNote => note?.trim().isNotEmpty == true;
}

@immutable
class FlashcardPage {
  const FlashcardPage({
    required this.items,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  final List<Flashcard> items;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  bool get isEmpty => items.isEmpty;
}

enum FlashcardSortField {
  createdAt('CREATED_AT'),
  updatedAt('UPDATED_AT'),
  frontText('FRONT_TEXT');

  const FlashcardSortField(this.apiValue);

  final String apiValue;
}
