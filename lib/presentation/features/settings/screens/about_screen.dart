import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memora/app/app_providers.dart';
import 'package:memora/core/di/core_providers.dart';
import 'package:memora/core/enums/app_theme_type.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/settings/widgets/settings_section.dart';
import 'package:memora/presentation/features/settings/widgets/settings_value_tile.dart';
import 'package:memora/presentation/shared/layouts/app_scaffold.dart';

class AboutScreen extends ConsumerWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final envConfig = ref.watch(envConfigProvider);
    final themeType = ref.watch(themeTypeControllerProvider);
    final locale = ref.watch(appLocaleControllerProvider);

    return AppScaffold(
      title: context.l10n.aboutTitle,
      constrainBody: true,
      body: ListView(
        children: [
          SettingsSection(
            title: context.l10n.aboutApplicationSectionTitle,
            subtitle: context.l10n.aboutApplicationSectionSubtitle,
            children: [
              SettingsValueTile(
                title: context.l10n.aboutAppNameLabel,
                value: envConfig.appName,
                leading: const Icon(Icons.apps_rounded),
              ),
              SettingsValueTile(
                title: context.l10n.aboutEnvironmentLabel,
                value: envConfig.environmentLabel,
                leading: const Icon(Icons.developer_mode_rounded),
              ),
              SettingsValueTile(
                title: context.l10n.aboutCurrentThemeLabel,
                value: _themeLabel(context, themeType),
                leading: const Icon(Icons.palette_outlined),
              ),
              SettingsValueTile(
                title: context.l10n.aboutCurrentLanguageLabel,
                value: locale.nativeName,
                leading: const Icon(Icons.translate_rounded),
              ),
              SettingsValueTile(
                title: context.l10n.aboutBaseUrlLabel,
                value: envConfig.baseUrl,
                leading: const Icon(Icons.link_rounded),
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
