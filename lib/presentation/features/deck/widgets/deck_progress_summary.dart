import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/primitives/displays/app_chip.dart';

class DeckProgressSummary extends StatelessWidget {
  const DeckProgressSummary({
    super.key,
    required this.deckCount,
    required this.flashcardCount,
  });

  final int deckCount;
  final int flashcardCount;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: context.spacing.sm,
      runSpacing: context.spacing.sm,
      children: [
        AppChip(label: Text(context.l10n.deckSummaryDeckCount(deckCount))),
        AppChip(
          label: Text(context.l10n.deckSummaryFlashcardCount(flashcardCount)),
        ),
      ],
    );
  }
}
