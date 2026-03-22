import 'package:flutter/material.dart';
import 'package:memora/core/config/app_icons.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/composites/states/app_empty_state.dart';
import 'package:memora/presentation/shared/layouts/app_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: context.l10n.settingsTitle,
      body: AppEmptyState(
        title: context.l10n.settingsPlaceholderTitle,
        message: context.l10n.settingsPlaceholderMessage,
        icon: const Icon(AppIcons.settings, size: 48),
      ),
    );
  }
}
