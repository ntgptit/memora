import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/settings/providers/settings_provider.dart';
import 'package:memora/presentation/features/settings/widgets/settings_section.dart';
import 'package:memora/presentation/features/settings/widgets/settings_switch_tile.dart';
import 'package:memora/presentation/shared/layouts/app_scaffold.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_outline_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:memora/presentation/shared/primitives/layout/app_spacing.dart';

class BackupRestoreScreen extends ConsumerWidget {
  const BackupRestoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return AppScaffold(
      title: context.l10n.backupRestoreTitle,
      constrainBody: true,
      body: ListView(
        children: [
          SettingsSection(
            title: context.l10n.backupRestoreSectionTitle,
            subtitle: context.l10n.backupRestoreSectionSubtitle,
            children: [
              SettingsSwitchTile(
                title: context.l10n.backupCloudBackupTitle,
                subtitle: context.l10n.backupCloudBackupSubtitle,
                leading: const Icon(Icons.cloud_done_outlined),
                value: settingsState.cloudBackupEnabled,
                onChanged: controller.setCloudBackupEnabled,
              ),
            ],
          ),
          const AppSpacing(size: AppSpacingSize.lg),
          SettingsSection(
            title: context.l10n.backupSnapshotSectionTitle,
            subtitle: settingsState.lastBackupAt == null
                ? context.l10n.backupNoSnapshotLabel
                : context.l10n.backupLastBackupLabel(
                    DateFormat.yMMMd().add_jm().format(
                      settingsState.lastBackupAt!,
                    ),
                  ),
            children: [
              Row(
                children: [
                  Expanded(
                    child: AppPrimaryButton(
                      text: context.l10n.backupCreateAction,
                      onPressed: controller.createBackupSnapshot,
                    ),
                  ),
                  const AppSpacing(
                    size: AppSpacingSize.sm,
                    axis: Axis.horizontal,
                  ),
                  Expanded(
                    child: AppOutlineButton(
                      text: context.l10n.backupClearAction,
                      onPressed: settingsState.hasBackupSnapshot
                          ? controller.clearBackupSnapshot
                          : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
