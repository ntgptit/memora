import 'package:flutter/widgets.dart';
import 'package:memora/domain/entities/flashcard.dart';
import 'package:memora/l10n/l10n.dart';

String flashcardSortLabel(BuildContext context, FlashcardSortField sortBy) {
  switch (sortBy) {
    case FlashcardSortField.createdAt:
      return context.l10n.flashcardSortByCreatedAt;
    case FlashcardSortField.updatedAt:
      return context.l10n.flashcardSortByUpdatedAt;
    case FlashcardSortField.frontText:
      return context.l10n.flashcardSortByFrontText;
  }
}
