import 'package:flutter/foundation.dart';
import 'package:memora/presentation/features/study/providers/study_session_provider.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'fill_mode_provider.g.dart';

@immutable
class FillModeState {
  const FillModeState({
    required this.item,
    required this.draftAnswer,
    required this.feedback,
    required this.answerRevealed,
    required this.canSubmit,
    required this.canReveal,
    required this.canGoNext,
  });

  final StudySessionItem item;
  final String draftAnswer;
  final StudyModeFeedback? feedback;
  final bool answerRevealed;
  final bool canSubmit;
  final bool canReveal;
  final bool canGoNext;
}

@Riverpod(keepAlive: false)
class FillModeController extends _$FillModeController {
  int? _lastInteractionId;
  String _draftAnswer = '';

  @override
  FillModeState? build() {
    final session = ref.watch(studySessionControllerProvider);
    if (session.sessionCompleted || session.activeMode != StudyMode.fill) {
      return null;
    }

    if (_lastInteractionId != session.interactionId) {
      _lastInteractionId = session.interactionId;
      _draftAnswer = '';
    }

    return _toState(session);
  }

  void updateDraft(String value) {
    _draftAnswer = value;
    state = _toState(ref.read(studySessionControllerProvider));
  }

  void revealAnswer() {
    ref.read(studySessionControllerProvider.notifier).revealAnswer();
  }

  void submitAnswer() {
    final current = state;
    if (current == null || !current.canSubmit) {
      return;
    }

    ref
        .read(studySessionControllerProvider.notifier)
        .submitFillAnswer(_draftAnswer);
  }

  void goNext() {
    ref.read(studySessionControllerProvider.notifier).goNext();
  }

  FillModeState _toState(StudySessionState session) {
    return FillModeState(
      item: session.currentItem,
      draftAnswer: _draftAnswer,
      feedback: session.feedback,
      answerRevealed: session.answerRevealed,
      canSubmit:
          _draftAnswer.trim().isNotEmpty &&
          session.allowedActions.contains(StudyActionType.submitAnswer),
      canReveal: session.allowedActions.contains(StudyActionType.revealAnswer),
      canGoNext: session.allowedActions.contains(StudyActionType.goNext),
    );
  }
}
