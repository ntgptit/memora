import 'package:flutter/material.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/study/modes/review/review_mode_provider.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:memora/presentation/features/study/widgets/study_action_bar.dart';
import 'package:memora/presentation/shared/composites/study/app_answer_result_banner.dart';

class ReviewScorePanel extends StatelessWidget {
  const ReviewScorePanel({
    super.key,
    required this.state,
    required this.onRemembered,
    required this.onRetry,
    required this.onNext,
  });

  final ReviewModeState state;
  final VoidCallback onRemembered;
  final VoidCallback onRetry;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return StudyActionBar(
      feedback: _buildFeedbackBanner(),
      actions: [
        if (state.canRemember)
          StudyActionButton(
            label: l10n.studyRememberedAction,
            onPressed: onRemembered,
          ),
        if (state.canRetry)
          StudyActionButton(
            label: l10n.studyRetryItemAction,
            onPressed: onRetry,
            variant: StudyActionButtonVariant.secondary,
          ),
        if (state.canGoNext)
          StudyActionButton(
            label: l10n.studyNextAction,
            onPressed: onNext,
            variant: StudyActionButtonVariant.primary,
          ),
      ],
    );
  }

  AppAnswerResultBanner? _buildFeedbackBanner() {
    final feedback = state.feedback;
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
