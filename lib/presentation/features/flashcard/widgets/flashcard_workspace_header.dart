import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/flashcard/providers/flashcard_state.dart';
import 'package:memora/presentation/features/flashcard/widgets/flashcard_card.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_outline_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:memora/presentation/shared/primitives/displays/app_card.dart';
import 'package:memora/presentation/shared/primitives/displays/app_chip.dart';

const double _flashcardPreviewStripHeight = 240;
const double _flashcardPreviewCardWidth = 320;
const double _flashcardPreviewBreakpoint = 480;

class FlashcardWorkspaceHeader extends StatelessWidget {
  const FlashcardWorkspaceHeader({
    super.key,
    required this.state,
    required this.onOpenDecks,
    required this.onCreateFlashcard,
  });

  final FlashcardState state;
  final VoidCallback onOpenDecks;
  final VoidCallback onCreateFlashcard;

  @override
  Widget build(BuildContext context) {
    final previewCards = state.flashcards.take(3).toList(growable: false);

    return AppCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final showPreviewStrip =
              constraints.maxWidth >= _flashcardPreviewBreakpoint;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.layers_rounded,
                    color: context.colorScheme.primary,
                  ),
                  SizedBox(width: context.spacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.currentDeck.name,
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: context.spacing.xxs),
                        Text(
                          context.l10n.deckFlashcardCountValue(
                            state.currentDeck.flashcardCount,
                          ),
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: context.spacing.sm),
              Wrap(
                spacing: context.spacing.xs,
                runSpacing: context.spacing.xs,
                children: [
                  AppOutlineButton(
                    text: context.l10n.deckBackToListAction,
                    onPressed: onOpenDecks,
                  ),
                  AppPrimaryButton(
                    text: context.l10n.flashcardCreateAction,
                    onPressed: onCreateFlashcard,
                  ),
                ],
              ),
              if (showPreviewStrip && previewCards.isNotEmpty) ...[
                SizedBox(height: context.spacing.md),
                SizedBox(
                  height: _flashcardPreviewStripHeight,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: previewCards.length,
                    separatorBuilder: (context, index) =>
                        SizedBox(width: context.spacing.md),
                    itemBuilder: (context, index) {
                      final flashcard = previewCards[index];
                      return SizedBox(
                        width: _flashcardPreviewCardWidth,
                        child: FlashcardCard(flashcard: flashcard),
                      );
                    },
                  ),
                ),
              ],
              SizedBox(height: context.spacing.sm),
              Wrap(
                spacing: context.spacing.sm,
                runSpacing: context.spacing.sm,
                children: [
                  AppChip(
                    label: Text(
                      context.l10n.flashcardPreviewCountLabel(
                        state.flashcards.length,
                      ),
                    ),
                  ),
                  AppChip(
                    label: Text(
                      state.searchQuery.isEmpty
                          ? context.l10n.flashcardBrowseModeLabel
                          : context.l10n.flashcardSearchModeLabel,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
