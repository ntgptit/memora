import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/core/enums/dialog_type.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/study/modes/fill/fill_mode_screen.dart';
import 'package:memora/presentation/features/study/modes/guess/guess_mode_screen.dart';
import 'package:memora/presentation/features/study/modes/match/match_mode_screen.dart';
import 'package:memora/presentation/features/study/modes/recall/recall_mode_screen.dart';
import 'package:memora/presentation/features/study/modes/review/review_mode_screen.dart';
import 'package:memora/presentation/features/study/providers/study_session_provider.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:memora/presentation/features/study/widgets/study_audio_controls.dart';
import 'package:memora/presentation/features/study/widgets/study_exit_confirm_dialog.dart';
import 'package:memora/presentation/features/study/widgets/study_footer.dart';
import 'package:memora/presentation/features/study/widgets/study_header.dart';
import 'package:memora/presentation/features/study/widgets/study_mode_stepper.dart';
import 'package:memora/presentation/features/study/widgets/study_progress_bar.dart';
import 'package:memora/presentation/shared/composites/cards/app_action_card.dart';
import 'package:memora/presentation/shared/composites/dialogs/app_confirm_dialog.dart';
import 'package:memora/presentation/shared/layouts/app_list_page_layout.dart';
import 'package:memora/presentation/shared/layouts/app_study_layout.dart';

class StudySessionScreen extends ConsumerWidget {
  const StudySessionScreen({
    super.key,
    this.onOpenModePicker,
    this.onOpenResult,
    this.onExit,
  });

  final VoidCallback? onOpenModePicker;
  final VoidCallback? onOpenResult;
  final VoidCallback? onExit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(studySessionControllerProvider);
    final controller = ref.read(studySessionControllerProvider.notifier);
    final l10n = context.l10n;

    if (session.sessionCompleted) {
      return AppListPageLayout(
        title: Text(l10n.studyResultTitle),
        subtitle: Text(l10n.studySessionCompletedSubtitle),
        body: AppActionCard(
          title: l10n.studySessionCompletedTitle,
          subtitle: l10n.studySessionCompletedMessage,
          leading: const Icon(Icons.celebration_rounded),
          primaryActionLabel: l10n.studyOpenResultAction,
          onPrimaryAction: onOpenResult,
          secondaryActionLabel: l10n.studyExitAction,
          onSecondaryAction: onExit,
        ),
      );
    }

    return PopScope<void>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }

        final confirmed = await _confirmExit(context);
        if (!context.mounted || !confirmed) {
          return;
        }

        if (onExit != null) {
          onExit!.call();
        } else {
          context.pop();
        }
      },
      child: AppStudyLayout(
        header: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StudyHeader(
              deck: session.deck,
              activeMode: session.activeMode,
              sessionType: session.sessionType,
              lifecycle: session.lifecycle,
              onOpenModePicker: onOpenModePicker,
            ),
            SizedBox(height: context.spacing.lg),
            StudyProgressBar(
              progress: session.progress,
              activeMode: session.activeMode,
            ),
          ],
        ),
        flashcard: _buildModeContent(session.activeMode),
        sidePanel: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StudyModeStepper(modePlan: session.modePlan),
            SizedBox(height: context.spacing.lg),
            StudyAudioControls(
              supportsAudio: session.supportsAudio,
              audioEnabled: session.audioEnabled,
              speechLabel: session.currentItem.speechLabel,
              onToggleAudio: controller.toggleAudioEnabled,
            ),
          ],
        ),
        footer: StudyFooter(
          activeMode: session.activeMode,
          lifecycle: session.lifecycle,
          canResetMode: session.allowedActions.contains(
            StudyActionType.resetCurrentMode,
          ),
          onResetMode: () => _confirmResetMode(context, controller),
          onExit: () async {
            final confirmed = await _confirmExit(context);
            if (confirmed) {
              if (onExit != null) {
                onExit!.call();
              } else {
                if (context.mounted) {
                  context.pop();
                }
              }
            }
          },
        ),
      ),
    );
  }

  Widget _buildModeContent(StudyMode mode) {
    switch (mode) {
      case StudyMode.review:
        return const ReviewModeScreen();
      case StudyMode.recall:
        return const RecallModeScreen();
      case StudyMode.guess:
        return const GuessModeScreen();
      case StudyMode.match:
        return const MatchModeScreen();
      case StudyMode.fill:
        return const FillModeScreen();
    }
  }

  Future<void> _confirmResetMode(
    BuildContext context,
    StudySessionController controller,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AppConfirmDialog(
        title: l10n.studyResetModeDialogTitle,
        type: DialogType.warning,
        confirmLabel: l10n.studyResetModeAction,
        cancelLabel: l10n.studyExitCancelAction,
        content: Text(l10n.studyResetModeDialogMessage),
        onConfirm: () => context.pop(true),
        onCancel: () => context.pop(false),
      ),
    );

    if (confirmed == true) {
      controller.resetCurrentMode();
    }
  }

  Future<bool> _confirmExit(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const StudyExitConfirmDialog(),
    );
    return confirmed == true;
  }
}
