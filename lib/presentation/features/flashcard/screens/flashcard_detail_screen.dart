import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/domain/entities/flashcard.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/flashcard/widgets/flashcard_card.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_danger_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_outline_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';

class FlashcardDetailScreen extends StatelessWidget {
  const FlashcardDetailScreen({
    super.key,
    required this.flashcard,
    required this.onEdit,
    required this.onDelete,
  });

  final Flashcard flashcard;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.spacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FlashcardCard(flashcard: flashcard),
              SizedBox(height: context.spacing.md),
              Row(
                children: [
                  Expanded(
                    child: AppOutlineButton(
                      text: context.l10n.cancelLabel,
                      onPressed: () => context.pop(),
                    ),
                  ),
                  SizedBox(width: context.spacing.sm),
                  Expanded(
                    child: AppPrimaryButton(
                      text: context.l10n.flashcardEditAction,
                      onPressed: onEdit,
                    ),
                  ),
                  SizedBox(width: context.spacing.sm),
                  Expanded(
                    child: AppDangerButton(
                      text: context.l10n.flashcardDeleteAction,
                      onPressed: onDelete,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
