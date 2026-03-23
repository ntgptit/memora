import 'package:flutter/material.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/study/providers/study_l10n.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:memora/presentation/shared/composites/cards/app_action_card.dart';

class StudyFooter extends StatelessWidget {
  const StudyFooter({
    super.key,
    required this.activeMode,
    required this.lifecycle,
    required this.canResetMode,
    required this.onResetMode,
    required this.onExit,
  });

  final StudyMode activeMode;
  final StudySessionLifecycle lifecycle;
  final bool canResetMode;
  final VoidCallback onResetMode;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppActionCard(
      title: l10n.studyFooterTitle,
      subtitle: l10n.studyFooterSubtitle(
        activeMode.label(l10n),
        lifecycle.label(l10n),
      ),
      primaryActionLabel: canResetMode ? l10n.studyResetModeAction : null,
      onPrimaryAction: canResetMode ? onResetMode : null,
      secondaryActionLabel: l10n.studyExitAction,
      onSecondaryAction: onExit,
      leading: const Icon(Icons.flag_circle_rounded),
    );
  }
}
