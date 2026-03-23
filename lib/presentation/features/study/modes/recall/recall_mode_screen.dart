import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/study/modes/recall/recall_answer_view.dart';
import 'package:memora/presentation/features/study/modes/recall/recall_mode_provider.dart';
import 'package:memora/presentation/features/study/modes/recall/recall_prompt_view.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:memora/presentation/features/study/widgets/study_action_bar.dart';
import 'package:memora/presentation/shared/composites/study/app_answer_result_banner.dart';

class RecallModeScreen extends ConsumerWidget {
  const RecallModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(recallModeControllerProvider);
    if (state == null) {
      return const SizedBox.shrink();
    }

    final controller = ref.read(recallModeControllerProvider.notifier);
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RecallPromptView(
          item: state.item,
          answerRevealed: state.answerRevealed,
          onRevealRequested: state.canReveal ? controller.revealAnswer : null,
        ),
        SizedBox(height: context.spacing.lg),
        RecallAnswerView(
          item: state.item,
          answerRevealed: state.answerRevealed,
        ),
        SizedBox(height: context.spacing.lg),
        StudyActionBar(
          feedback: _feedbackBanner(state.feedback),
          actions: [
            if (state.canReveal)
              StudyActionButton(
                label: l10n.studyRevealAnswerAction,
                onPressed: controller.revealAnswer,
                variant: StudyActionButtonVariant.secondary,
              ),
            if (state.canRemember)
              StudyActionButton(
                label: l10n.studyRememberedAction,
                onPressed: controller.markRemembered,
              ),
            if (state.canRetry)
              StudyActionButton(
                label: l10n.studyRetryItemAction,
                onPressed: controller.retryItem,
                variant: StudyActionButtonVariant.secondary,
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
