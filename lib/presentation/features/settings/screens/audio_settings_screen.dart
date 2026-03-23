import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/settings/providers/settings_provider.dart';
import 'package:memora/presentation/features/settings/widgets/settings_section.dart';
import 'package:memora/presentation/features/settings/widgets/settings_switch_tile.dart';
import 'package:memora/presentation/shared/layouts/app_scaffold.dart';

class AudioSettingsScreen extends ConsumerWidget {
  const AudioSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsControllerProvider);
    final controller = ref.read(settingsControllerProvider.notifier);

    return AppScaffold(
      title: context.l10n.audioSettingsTitle,
      constrainBody: true,
      body: ListView(
        children: [
          SettingsSection(
            title: context.l10n.audioSettingsSectionTitle,
            subtitle: context.l10n.audioSettingsSectionSubtitle,
            children: [
              SettingsSwitchTile(
                title: context.l10n.audioTtsTitle,
                subtitle: context.l10n.audioTtsSubtitle,
                leading: const Icon(Icons.record_voice_over_rounded),
                value: settingsState.ttsEnabled,
                onChanged: controller.setTtsEnabled,
              ),
              SettingsSwitchTile(
                title: context.l10n.audioReviewSoundsTitle,
                subtitle: context.l10n.audioReviewSoundsSubtitle,
                leading: const Icon(Icons.music_note_rounded),
                value: settingsState.reviewSoundsEnabled,
                onChanged: controller.setReviewSoundsEnabled,
              ),
              SettingsSwitchTile(
                title: context.l10n.audioHapticsTitle,
                subtitle: context.l10n.audioHapticsSubtitle,
                leading: const Icon(Icons.vibration_rounded),
                value: settingsState.hapticsEnabled,
                onChanged: controller.setHapticsEnabled,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
