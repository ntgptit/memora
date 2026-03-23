import 'package:flutter/material.dart';
import 'package:memora/l10n/l10n.dart';

enum _DeckAction { edit, delete }

class DeckActionMenu extends StatelessWidget {
  const DeckActionMenu({
    super.key,
    required this.onEdit,
    required this.onDelete,
  });

  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_DeckAction>(
      tooltip: context.l10n.deckActionsTooltip,
      onSelected: (action) {
        switch (action) {
          case _DeckAction.edit:
            onEdit();
            break;
          case _DeckAction.delete:
            onDelete();
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: _DeckAction.edit,
          child: Text(context.l10n.deckEditAction),
        ),
        PopupMenuItem(
          value: _DeckAction.delete,
          child: Text(context.l10n.deckDeleteAction),
        ),
      ],
    );
  }
}
