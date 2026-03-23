import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memora/app/app_providers.dart';
import 'package:memora/core/enums/app_locale.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/composites/lists/app_list_item.dart';
import 'package:memora/presentation/shared/layouts/app_scaffold.dart';
import 'package:memora/presentation/shared/primitives/layout/app_spacing.dart';

class LanguageSettingsScreen extends ConsumerWidget {
  const LanguageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocale = ref.watch(appLocaleControllerProvider);

    return AppScaffold(
      title: context.l10n.languageSettingsTitle,
      constrainBody: true,
      body: ListView.separated(
        itemCount: AppLocale.values.length,
        separatorBuilder: (context, index) =>
            const AppSpacing(size: AppSpacingSize.sm),
        itemBuilder: (context, index) {
          final locale = AppLocale.values[index];
          return AppListItem(
            onTap: () => ref
                .read(appLocaleControllerProvider.notifier)
                .setLocale(locale),
            selected: locale == selectedLocale,
            title: Text(locale.nativeName),
            subtitle: Text(locale.displayName),
            trailing: locale == selectedLocale
                ? const Icon(Icons.check_circle_rounded)
                : const Icon(Icons.circle_outlined),
          );
        },
      ),
    );
  }
}
