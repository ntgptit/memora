import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/domain/entities/flashcard.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/composites/lists/app_list_item.dart';
import 'package:memora/presentation/shared/primitives/displays/app_chip.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';

enum _FlashcardAction { edit, delete }

class FlashcardListItem extends StatelessWidget {
  const FlashcardListItem({
    super.key,
    required this.flashcard,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final Flashcard flashcard;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return AppListItem(
      onTap: onTap,
      leading: Container(
        width: context.component.listItemLeadingSize,
        height: context.component.listItemLeadingSize,
        decoration: BoxDecoration(
          color: context.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(context.radius.md),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.style_rounded,
          color: context.colorScheme.onPrimaryContainer,
        ),
      ),
      title: Text(flashcard.frontText),
      subtitle: AppBodyText(
        text: flashcard.backText,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        isSecondary: true,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (flashcard.isBookmarked) ...[
            AppChip(label: Text(context.l10n.flashcardPinnedLabel)),
            SizedBox(width: context.spacing.xs),
          ],
          PopupMenuButton<_FlashcardAction>(
            tooltip: context.l10n.flashcardActionsTooltip,
            onSelected: (action) {
              switch (action) {
                case _FlashcardAction.edit:
                  onEdit();
                  break;
                case _FlashcardAction.delete:
                  onDelete();
                  break;
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: _FlashcardAction.edit,
                child: Text(context.l10n.flashcardEditAction),
              ),
              PopupMenuItem(
                value: _FlashcardAction.delete,
                child: Text(context.l10n.flashcardDeleteAction),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
