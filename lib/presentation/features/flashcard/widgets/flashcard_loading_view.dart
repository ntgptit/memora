import 'package:flutter/material.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/layouts/app_list_page_layout.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_circular_loader.dart';

class FlashcardLoadingView extends StatelessWidget {
  const FlashcardLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppListPageLayout(
      title: Text(context.l10n.flashcardsTitle),
      subtitle: Text(context.l10n.flashcardScreenSubtitle),
      body: const Center(child: AppCircularLoader()),
    );
  }
}
