import 'package:flutter/material.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/primitives/displays/app_card.dart';
import 'package:memora/presentation/shared/primitives/displays/app_chip.dart';

class FlashcardImportResult extends StatelessWidget {
  const FlashcardImportResult({
    super.key,
    required this.createdCount,
    required this.failedCount,
  });

  final int createdCount;
  final int failedCount;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          AppChip(
            label: Text(context.l10n.flashcardImportCreatedLabel(createdCount)),
          ),
          AppChip(
            label: Text(context.l10n.flashcardImportFailedLabel(failedCount)),
          ),
        ],
      ),
    );
  }
}
