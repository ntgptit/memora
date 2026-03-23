import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/domain/entities/flashcard.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/flashcard/widgets/flashcard_meaning_view.dart';
import 'package:memora/presentation/features/flashcard/widgets/flashcard_term_view.dart';
import 'package:memora/presentation/shared/composites/study/app_flashcard_face.dart';
import 'package:memora/presentation/shared/primitives/displays/app_card.dart';
import 'package:memora/presentation/shared/primitives/displays/app_chip.dart';

class FlashcardCard extends StatefulWidget {
  const FlashcardCard({super.key, required this.flashcard, this.onTap});

  final Flashcard flashcard;
  final VoidCallback? onTap;

  @override
  State<FlashcardCard> createState() => _FlashcardCardState();
}

class _FlashcardCardState extends State<FlashcardCard> {
  bool _isRevealed = false;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              if (widget.flashcard.isBookmarked)
                AppChip(label: Text(context.l10n.flashcardPinnedLabel)),
              const Spacer(),
              if (widget.flashcard.hasFrontLangCode)
                AppChip(
                  label: Text(
                    widget.flashcard.frontLangCode!.trim().toUpperCase(),
                  ),
                ),
            ],
          ),
          SizedBox(height: context.spacing.sm),
          AppFlashcardFace(
            isRevealed: _isRevealed,
            onTap:
                widget.onTap ??
                () {
                  setState(() {
                    _isRevealed = !_isRevealed;
                  });
                },
            front: FlashcardTermView(
              frontText: widget.flashcard.frontText,
              frontLangCode: widget.flashcard.frontLangCode,
              pronunciation: widget.flashcard.pronunciation,
            ),
            back: FlashcardMeaningView(
              backText: widget.flashcard.backText,
              backLangCode: widget.flashcard.backLangCode,
              note: widget.flashcard.note,
              isBookmarked: widget.flashcard.isBookmarked,
            ),
          ),
        ],
      ),
    );
  }
}
