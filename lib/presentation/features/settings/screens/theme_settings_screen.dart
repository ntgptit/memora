import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memora/app/app_providers.dart';
import 'package:memora/core/enums/app_theme_type.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/composites/lists/app_list_item.dart';
import 'package:memora/presentation/shared/layouts/app_scaffold.dart';
import 'package:memora/presentation/shared/primitives/layout/app_spacing.dart';

class ThemeSettingsScreen extends ConsumerWidget {
  const ThemeSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTheme = ref.watch(themeTypeControllerProvider);

    return AppScaffold(
      title: context.l10n.themeSettingsTitle,
      constrainBody: true,
      body: ListView.separated(
        itemCount: AppThemeType.values.length,
        separatorBuilder: (context, index) =>
            const AppSpacing(size: AppSpacingSize.sm),
        itemBuilder: (context, index) {
          final themeType = AppThemeType.values[index];
          return AppListItem(
            onTap: () => ref
                .read(themeTypeControllerProvider.notifier)
                .setTheme(themeType),
            selected: themeType == selectedTheme,
            title: Text(_themeLabel(context, themeType)),
            subtitle: Text(_themeSubtitle(context, themeType)),
            trailing: themeType == selectedTheme
                ? const Icon(Icons.check_circle_rounded)
                : const Icon(Icons.circle_outlined),
          );
        },
      ),
    );
  }
}

String _themeLabel(BuildContext context, AppThemeType themeType) {
  switch (themeType) {
    case AppThemeType.system:
      return context.l10n.themeSystemLabel;
    case AppThemeType.light:
      return context.l10n.themeLightLabel;
    case AppThemeType.dark:
      return context.l10n.themeDarkLabel;
  }
}

String _themeSubtitle(BuildContext context, AppThemeType themeType) {
  switch (themeType) {
    case AppThemeType.system:
      return context.l10n.themeSystemSubtitle;
    case AppThemeType.light:
      return context.l10n.themeLightSubtitle;
    case AppThemeType.dark:
      return context.l10n.themeDarkSubtitle;
  }
}
