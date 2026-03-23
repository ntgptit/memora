import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/study/modes/match/match_board.dart';
import 'package:memora/presentation/features/study/modes/match/match_mode_provider.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:memora/presentation/features/study/widgets/study_action_bar.dart';
import 'package:memora/presentation/shared/composites/study/app_answer_result_banner.dart';

class MatchModeScreen extends ConsumerWidget {
  const MatchModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(matchModeControllerProvider);
    if (state == null) {
      return const SizedBox.shrink();
    }

    final controller = ref.read(matchModeControllerProvider.notifier);
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        MatchBoard(
          state: state,
          onSelectLeft: controller.selectLeft,
          onSelectRight: controller.selectRight,
          onRemovePair: controller.removePair,
        ),
        SizedBox(height: context.spacing.lg),
        StudyActionBar(
          feedback: _feedbackBanner(state.feedback),
          actions: [
            if (state.canSubmit)
              StudyActionButton(
                label: l10n.studyMatchConfirmAction,
                onPressed: controller.submitPairs,
              ),
            if (state.canGoNext)
              StudyActionButton(
                label: l10n.studyNextAction,
                onPressed: controller.goNext,
              ),
          ],
        ),
      ],
    );
  }

  AppAnswerResultBanner? _feedbackBanner(StudyModeFeedback? feedback) {
    if (feedback == null) {
      return null;
    }

    return AppAnswerResultBanner(
      title: feedback.title,
      message: feedback.message,
      kind: switch (feedback.kind) {
        StudyFeedbackKind.correct => AppAnswerResultKind.correct,
        StudyFeedbackKind.incorrect => AppAnswerResultKind.incorrect,
        StudyFeedbackKind.neutral => AppAnswerResultKind.neutral,
      },
    );
  }
}
