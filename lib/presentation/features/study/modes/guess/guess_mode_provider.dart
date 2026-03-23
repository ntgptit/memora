import 'package:flutter/foundation.dart';
import 'package:memora/presentation/features/study/providers/study_session_provider.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'guess_mode_provider.g.dart';

@immutable
class GuessModeState {
  const GuessModeState({
    required this.item,
    required this.selectedChoiceId,
    required this.feedback,
    required this.canSubmit,
    required this.canGoNext,
  });

  final StudySessionItem item;
  final String? selectedChoiceId;
  final StudyModeFeedback? feedback;
  final bool canSubmit;
  final bool canGoNext;

  bool get hasSelection => selectedChoiceId != null;
}

@Riverpod(keepAlive: false)
class GuessModeController extends _$GuessModeController {
  int? _lastInteractionId;
  String? _selectedChoiceId;

  @override
  GuessModeState? build() {
    final session = ref.watch(studySessionControllerProvider);
    if (session.sessionCompleted || session.activeMode != StudyMode.guess) {
      return null;
    }

    if (_lastInteractionId != session.interactionId) {
      _lastInteractionId = session.interactionId;
      _selectedChoiceId = null;
    }

    return _toState(session);
  }

  void selectChoice(String choiceId) {
    final current = state;
    if (current == null || current.feedback != null) {
      return;
    }

    _selectedChoiceId = choiceId;
    state = _toState(ref.read(studySessionControllerProvider));
  }

  void submitSelection() {
    final selectedChoiceId = _selectedChoiceId;
    final current = state;
    if (selectedChoiceId == null || current == null || !current.canSubmit) {
      return;
    }

    ref
        .read(studySessionControllerProvider.notifier)
        .submitGuess(selectedChoiceId);
  }

  void goNext() {
    ref.read(studySessionControllerProvider.notifier).goNext();
  }

  GuessModeState _toState(StudySessionState session) {
    return GuessModeState(
      item: session.currentItem,
      selectedChoiceId: _selectedChoiceId,
      feedback: session.feedback,
      canSubmit:
          _selectedChoiceId != null &&
          session.allowedActions.contains(StudyActionType.submitAnswer),
      canGoNext: session.allowedActions.contains(StudyActionType.goNext),
    );
  }
}
