import 'package:flutter/foundation.dart';
import 'package:memora/presentation/features/study/providers/study_session_provider.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recall_mode_provider.g.dart';

@immutable
class RecallModeState {
  const RecallModeState({
    required this.item,
    required this.feedback,
    required this.answerRevealed,
    required this.canReveal,
    required this.canRemember,
    required this.canRetry,
    required this.canGoNext,
  });

  final StudySessionItem item;
  final StudyModeFeedback? feedback;
  final bool answerRevealed;
  final bool canReveal;
  final bool canRemember;
  final bool canRetry;
  final bool canGoNext;
}

@Riverpod(keepAlive: false)
class RecallModeController extends _$RecallModeController {
  @override
  RecallModeState? build() {
    final session = ref.watch(studySessionControllerProvider);
    if (session.sessionCompleted || session.activeMode != StudyMode.recall) {
      return null;
    }

    return RecallModeState(
      item: session.currentItem,
      feedback: session.feedback,
      answerRevealed: session.answerRevealed,
      canReveal: session.allowedActions.contains(StudyActionType.revealAnswer),
      canRemember: session.allowedActions.contains(
        StudyActionType.markRemembered,
      ),
      canRetry: session.allowedActions.contains(StudyActionType.retryItem),
      canGoNext: session.allowedActions.contains(StudyActionType.goNext),
    );
  }

  void revealAnswer() {
    ref.read(studySessionControllerProvider.notifier).revealAnswer();
  }

  void markRemembered() {
    ref.read(studySessionControllerProvider.notifier).markRemembered();
  }

  void retryItem() {
    ref.read(studySessionControllerProvider.notifier).retryItem();
  }

  void goNext() {
    ref.read(studySessionControllerProvider.notifier).goNext();
  }
}
