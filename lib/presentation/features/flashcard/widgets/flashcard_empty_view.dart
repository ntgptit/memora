import 'package:flutter/material.dart';
import 'package:memora/core/config/app_icons.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/composites/states/app_empty_state.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';

class FlashcardEmptyView extends StatelessWidget {
  const FlashcardEmptyView({
    super.key,
    required this.onCreatePressed,
    this.isSearching = false,
  });

  final VoidCallback onCreatePressed;
  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppEmptyState(
      title: isSearching ? l10n.noResultsTitle : l10n.flashcardEmptyTitle,
      message: isSearching ? l10n.noResultsMessage : l10n.flashcardEmptyMessage,
      icon: const Icon(AppIcons.flashcards, size: 48),
      actions: [
        AppPrimaryButton(
          text: l10n.flashcardCreateAction,
          onPressed: onCreatePressed,
        ),
      ],
    );
  }
}
