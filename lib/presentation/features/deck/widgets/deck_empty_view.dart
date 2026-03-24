import 'package:flutter/material.dart';
import 'package:memora/core/config/app_icons.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/composites/states/app_empty_state.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';

class DeckEmptyView extends StatelessWidget {
  const DeckEmptyView({super.key, this.onCreatePressed});

  final VoidCallback? onCreatePressed;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      title: context.l10n.deckEmptyTitle,
      message: context.l10n.deckEmptyMessage,
      icon: const Icon(AppIcons.decks),
      actions: [
        if (onCreatePressed != null)
          AppPrimaryButton(
            text: context.l10n.deckCreateAction,
            onPressed: onCreatePressed,
          ),
      ],
    );
  }
}
