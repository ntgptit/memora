import 'package:flutter/material.dart';
import 'package:memora/domain/entities/deck.dart';
import 'package:memora/presentation/features/deck/widgets/deck_progress_summary.dart';
import 'package:memora/presentation/shared/layouts/app_detail_page_layout.dart';

class DeckStatisticsScreen extends StatelessWidget {
  const DeckStatisticsScreen({
    super.key,
    required this.deck,
  });

  final Deck deck;

  @override
  Widget build(BuildContext context) {
    return AppDetailPageLayout(
      title: Text(deck.name),
      body: DeckProgressSummary(
        deckCount: 1,
        flashcardCount: deck.flashcardCount,
      ),
    );
  }
}
