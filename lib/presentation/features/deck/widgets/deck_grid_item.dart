import 'package:flutter/widgets.dart';
import 'package:memora/domain/entities/deck.dart';
import 'package:memora/presentation/features/deck/widgets/deck_card.dart';

class DeckGridItem extends StatelessWidget {
  const DeckGridItem({
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
    return DeckCard(
      deck: deck,
      onTap: onTap,
      onEdit: onEdit,
      onDelete: onDelete,
    );
  }
}
