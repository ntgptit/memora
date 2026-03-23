import 'package:flutter/material.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/composites/cards/app_action_card.dart';

class StudyAudioControls extends StatelessWidget {
  const StudyAudioControls({
    super.key,
    required this.supportsAudio,
    required this.audioEnabled,
    required this.speechLabel,
    required this.onToggleAudio,
  });

  final bool supportsAudio;
  final bool audioEnabled;
  final String? speechLabel;
  final VoidCallback onToggleAudio;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppActionCard(
      title: l10n.studyAudioTitle,
      subtitle: supportsAudio
          ? l10n.studyAudioSubtitle(
              speechLabel == null || speechLabel!.isEmpty
                  ? l10n.studyAudioFallbackVoice
                  : speechLabel!,
            )
          : l10n.studyAudioUnavailableMessage,
      leading: Icon(
        supportsAudio && audioEnabled
            ? Icons.volume_up_rounded
            : Icons.volume_off_rounded,
      ),
      primaryActionLabel: supportsAudio
          ? (audioEnabled
                ? l10n.studyAudioMuteAction
                : l10n.studyAudioEnableAction)
          : l10n.studyAudioUnavailableAction,
      onPrimaryAction: supportsAudio ? onToggleAudio : null,
    );
  }
}
