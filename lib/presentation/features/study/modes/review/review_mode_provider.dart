import 'package:flutter/foundation.dart';
import 'package:memora/presentation/features/study/providers/study_session_provider.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'review_mode_provider.g.dart';

@immutable
class ReviewModeState {
  const ReviewModeState({
    required this.item,
    required this.feedback,
    required this.canRemember,
    required this.canRetry,
    required this.canGoNext,
  });

  final StudySessionItem item;
  final StudyModeFeedback? feedback;
  final bool canRemember;
  final bool canRetry;
  final bool canGoNext;
}

@Riverpod(keepAlive: false)
class ReviewModeController extends _$ReviewModeController {
  @override
  ReviewModeState? build() {
    final session = ref.watch(studySessionControllerProvider);
    if (session.sessionCompleted || session.activeMode != StudyMode.review) {
      return null;
    }

    return ReviewModeState(
      item: session.currentItem,
      feedback: session.feedback,
      canRemember: session.allowedActions.contains(
        StudyActionType.markRemembered,
      ),
      canRetry: session.allowedActions.contains(StudyActionType.retryItem),
      canGoNext: session.allowedActions.contains(StudyActionType.goNext),
    );
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
