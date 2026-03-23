import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/domain/entities/flashcard.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/flashcard/widgets/flashcard_card.dart';
import 'package:memora/presentation/shared/composites/states/app_empty_state.dart';

class FlashcardPreviewScreen extends StatelessWidget {
  const FlashcardPreviewScreen({super.key, required this.flashcards});

  final List<Flashcard> flashcards;

  @override
  Widget build(BuildContext context) {
    if (flashcards.isEmpty) {
      return AppEmptyState(
        title: context.l10n.flashcardPreviewEmptyTitle,
        message: context.l10n.flashcardPreviewEmptyMessage,
      );
    }

    return ListView.separated(
      padding: EdgeInsets.all(context.spacing.lg),
      itemCount: flashcards.length,
      separatorBuilder: (context, index) =>
          SizedBox(height: context.spacing.md),
      itemBuilder: (context, index) {
        return FlashcardCard(flashcard: flashcards[index]);
      },
    );
  }
}
