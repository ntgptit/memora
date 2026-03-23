import 'package:flutter/foundation.dart';

@immutable
class Deck {
  const Deck({
    required this.id,
    required this.folderId,
    required this.name,
    required this.description,
    required this.flashcardCount,
  });

  final int id;
  final int folderId;
  final String name;
  final String description;
  final int flashcardCount;

  bool get hasDescription => description.trim().isNotEmpty;
}

enum DeckSortField {
  name('NAME'),
  createdAt('CREATED_AT'),
  updatedAt('UPDATED_AT');

  const DeckSortField(this.apiValue);

  final String apiValue;
}
