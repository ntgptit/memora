import 'package:flutter/material.dart';
import 'package:memora/presentation/features/flashcard/screens/flashcard_list_screen.dart';

class DeckDetailScreen extends StatelessWidget {
  const DeckDetailScreen({
    super.key,
    required this.folderId,
    required this.deckId,
  });

  final int folderId;
  final int deckId;

  @override
  Widget build(BuildContext context) {
    return FlashcardListScreen(folderId: folderId, deckId: deckId);
  }
}
