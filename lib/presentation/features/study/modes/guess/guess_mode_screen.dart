import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/study/modes/guess/guess_mode_provider.dart';
import 'package:memora/presentation/features/study/modes/guess/guess_option_list.dart';
import 'package:memora/presentation/features/study/modes/guess/guess_question_view.dart';
import 'package:memora/presentation/features/study/providers/study_l10n.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:memora/presentation/features/study/widgets/study_action_bar.dart';
import 'package:memora/presentation/shared/composites/study/app_answer_result_banner.dart';

class GuessModeScreen extends ConsumerWidget {
  const GuessModeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(guessModeControllerProvider);
    if (state == null) {
      return const SizedBox.shrink();
    }

    final controller = ref.read(guessModeControllerProvider.notifier);
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GuessQuestionView(item: state.item),
        SizedBox(height: context.spacing.lg),
        GuessOptionList(
          item: state.item,
          selectedChoiceId: state.selectedChoiceId,
          feedback: state.feedback,
          onSelectChoice: controller.selectChoice,
        ),
        SizedBox(height: context.spacing.lg),
        StudyActionBar(
          feedback: _feedbackBanner(context, state.feedback),
          actions: [
            if (state.canSubmit)
              StudyActionButton(
                label: l10n.studyCheckAnswerAction,
                onPressed: controller.submitSelection,
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

  AppAnswerResultBanner? _feedbackBanner(
    BuildContext context,
    StudyModeFeedback? feedback,
  ) {
    if (feedback == null) {
      return null;
    }

    return AppAnswerResultBanner(
      title: feedback.titleText(context.l10n),
      message: feedback.messageText(context.l10n),
      kind: switch (feedback.kind) {
        StudyFeedbackKind.correct => AppAnswerResultKind.correct,
        StudyFeedbackKind.incorrect => AppAnswerResultKind.incorrect,
        StudyFeedbackKind.neutral => AppAnswerResultKind.neutral,
      },
    );
  }
}
