import 'package:flutter/material.dart';
import 'package:memora/core/config/app_icons.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/composites/states/app_empty_state.dart';
import 'package:memora/presentation/shared/layouts/app_scaffold.dart';

class DeckListScreen extends StatelessWidget {
  const DeckListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: context.l10n.decksTitle,
      body: AppEmptyState(
        title: context.l10n.decksPlaceholderTitle,
        message: context.l10n.decksPlaceholderMessage,
        icon: const Icon(AppIcons.decks, size: 48),
      ),
    );
  }
}
