import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/app/app_providers.dart';
import 'package:memora/app/app_routes.dart';
import 'package:memora/core/enums/app_theme_type.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/settings/providers/settings_provider.dart';
import 'package:memora/presentation/features/settings/widgets/settings_navigation_tile.dart';
import 'package:memora/presentation/features/settings/widgets/settings_section.dart';
import 'package:memora/presentation/features/settings/widgets/settings_switch_tile.dart';
import 'package:memora/presentation/shared/layouts/app_scaffold.dart';
import 'package:memora/presentation/shared/primitives/layout/app_spacing.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeType = ref.watch(themeTypeControllerProvider);
    final locale = ref.watch(appLocaleControllerProvider);
    final settingsState = ref.watch(settingsControllerProvider);

    return AppScaffold(
      title: context.l10n.settingsTitle,
      constrainBody: true,
      body: ListView(
        children: [
          SettingsSection(
            title: context.l10n.settingsSectionAppearanceTitle,
            subtitle: context.l10n.settingsSectionAppearanceSubtitle,
            children: [
              SettingsNavigationTile(
                title: context.l10n.settingsThemeTileTitle,
                subtitle: _themeLabel(context, themeType),
                leading: const Icon(Icons.palette_outlined),
                onTap: () => context.push(AppRoutes.themeSettings),
              ),
              SettingsNavigationTile(
                title: context.l10n.settingsLanguageTileTitle,
                subtitle: locale.nativeName,
                leading: const Icon(Icons.translate_rounded),
                onTap: () => context.push(AppRoutes.languageSettings),
              ),
            ],
          ),
          const AppSpacing(size: AppSpacingSize.lg),
          SettingsSection(
            title: context.l10n.settingsSectionAudioTitle,
            subtitle: context.l10n.settingsSectionAudioSubtitle,
            children: [
              SettingsNavigationTile(
                title: context.l10n.settingsAudioTileTitle,
                subtitle: context.l10n.settingsAudioTileSubtitle,
                leading: const Icon(Icons.volume_up_rounded),
                onTap: () => context.push(AppRoutes.audioSettings),
              ),
              SettingsSwitchTile(
                title: context.l10n.settingsQuickHapticsTitle,
                subtitle: context.l10n.settingsQuickHapticsSubtitle,
                leading: const Icon(Icons.vibration_rounded),
                value: settingsState.hapticsEnabled,
                onChanged: ref
                    .read(settingsControllerProvider.notifier)
                    .setHapticsEnabled,
              ),
            ],
          ),
          const AppSpacing(size: AppSpacingSize.lg),
          SettingsSection(
            title: context.l10n.settingsSectionBackupTitle,
            subtitle: context.l10n.settingsSectionBackupSubtitle,
            children: [
              SettingsNavigationTile(
                title: context.l10n.settingsBackupTileTitle,
                subtitle: context.l10n.settingsBackupTileSubtitle,
                leading: const Icon(Icons.cloud_sync_outlined),
                onTap: () => context.push(AppRoutes.backupRestore),
              ),
              SettingsNavigationTile(
                title: context.l10n.settingsReminderTileTitle,
                subtitle: context.l10n.settingsReminderTileSubtitle,
                leading: const Icon(Icons.notifications_active_outlined),
                onTap: () => context.push(AppRoutes.reminders),
              ),
            ],
          ),
          const AppSpacing(size: AppSpacingSize.lg),
          SettingsSection(
            title: context.l10n.settingsSectionAboutTitle,
            subtitle: context.l10n.settingsSectionAboutSubtitle,
            children: [
              SettingsNavigationTile(
                title: context.l10n.settingsAboutTileTitle,
                subtitle: context.l10n.settingsAboutTileSubtitle,
                leading: const Icon(Icons.info_outline_rounded),
                onTap: () => context.push(AppRoutes.about),
              ),
            ],
          ),
        ],
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
