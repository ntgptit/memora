import 'package:flutter/widgets.dart';
import 'package:memora/domain/entities/deck.dart';
import 'package:memora/presentation/features/deck/widgets/deck_list_item.dart';

class DeckCard extends StatelessWidget {
  const DeckCard({
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
    return DeckListItem(
      deck: deck,
      onTap: onTap,
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }
}
