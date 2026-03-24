import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/domain/entities/deck.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/deck/widgets/deck_action_menu.dart';
import 'package:memora/presentation/shared/composites/lists/app_list_item.dart';
import 'package:memora/presentation/shared/primitives/displays/app_counter_badge.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';

class DeckListItem extends StatelessWidget {
  const DeckListItem({
    super.key,
    required this.deck,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  final Deck deck;
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
          color: context.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(context.radius.md),
        ),
        alignment: Alignment.center,
        child: Icon(
          Icons.layers_rounded,
          color: context.colorScheme.onSecondaryContainer,
        ),
      ),
      title: Text(deck.name),
      subtitle: AppBodyText(
        text: deck.hasDescription
            ? deck.description
            : context.l10n.deckFlashcardCountValue(deck.flashcardCount),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        isSecondary: true,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppCounterBadge(
            count: deck.flashcardCount,
            child: const Icon(Icons.style_rounded),
          ),
          SizedBox(width: context.spacing.xs),
          DeckActionMenu(onEdit: onEdit, onDelete: onDelete),
        ],
      ),
    );
  }
}
