import 'package:flutter/material.dart';
import 'package:memora/core/config/app_icons.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/composites/states/app_empty_state.dart';
import 'package:memora/presentation/shared/layouts/app_scaffold.dart';

class LearningProgressScreen extends StatelessWidget {
  const LearningProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: context.l10n.progressTitle,
      body: AppEmptyState(
        title: context.l10n.progressPlaceholderTitle,
        message: context.l10n.progressPlaceholderMessage,
        icon: const Icon(AppIcons.progress, size: 48),
      ),
    );
  }
}
