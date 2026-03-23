import 'package:flutter/material.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/composites/states/app_empty_state.dart';

class FlashcardImportScreen extends StatelessWidget {
  const FlashcardImportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      title: context.l10n.flashcardImportPlaceholderTitle,
      message: context.l10n.flashcardImportPlaceholderMessage,
    );
  }
}
