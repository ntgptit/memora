part of 'study_session_machine.dart';

extension StudySessionMachineActions on StudySessionMachine {
  StudySessionState markRemembered() {
    if (!_canAct(StudyActionType.markRemembered)) return state;
    _registerOutcome(mastered: true, retry: false);
    _feedback = const StudyModeFeedback(
      kind: StudyFeedbackKind.correct,
      copy: StudyFeedbackCopy.lockedIn,
    );
    return _buildState(lifecycle: StudySessionLifecycle.waitingFeedback);
  }

  StudySessionState retryItem() {
    if (!_canAct(StudyActionType.retryItem)) return state;
    _registerOutcome(mastered: false, retry: true);
    _feedback = const StudyModeFeedback(
      kind: StudyFeedbackKind.incorrect,
      copy: StudyFeedbackCopy.queued,
    );
    return _buildState(lifecycle: StudySessionLifecycle.retryPending);
  }

  StudySessionState revealAnswer() {
    if (!_canAct(StudyActionType.revealAnswer)) return state;
    _answerRevealed = true;
    _feedback = const StudyModeFeedback(
      kind: StudyFeedbackKind.neutral,
      copy: StudyFeedbackCopy.revealed,
    );
    return state;
  }

  StudySessionState submitGuess(String choiceId) {
    if (!_canAct(StudyActionType.submitAnswer) ||
        _currentMode.mode != StudyMode.guess) {
      return state;
    }
    final isCorrect = _currentItem.correctChoiceId == choiceId;
    _registerOutcome(mastered: isCorrect, retry: !isCorrect);
    _feedback = StudyModeFeedback(
      kind: isCorrect ? StudyFeedbackKind.correct : StudyFeedbackKind.incorrect,
      copy: isCorrect
          ? StudyFeedbackCopy.guessCorrect
          : StudyFeedbackCopy.guessIncorrect,
      answerText: isCorrect ? null : _currentItem.answer,
    );
    return _buildState(
      lifecycle: isCorrect
          ? StudySessionLifecycle.waitingFeedback
          : StudySessionLifecycle.retryPending,
    );
  }

  StudySessionState submitMatch(List<StudyMatchedPair> pairs) {
    if (!_canAct(StudyActionType.submitAnswer) ||
        _currentMode.mode != StudyMode.match) {
      return state;
    }
    final expected = {
      for (final pair in _currentItem.matchPairs) pair.left.id: pair.right.id,
    };
    final isCorrect =
        pairs.length == _currentItem.matchPairs.length &&
        pairs.every((pair) => expected[pair.leftId] == pair.rightId);
    _registerOutcome(mastered: isCorrect, retry: !isCorrect);
    _feedback = StudyModeFeedback(
      kind: isCorrect ? StudyFeedbackKind.correct : StudyFeedbackKind.incorrect,
      copy: isCorrect
          ? StudyFeedbackCopy.matchCorrect
          : StudyFeedbackCopy.matchIncorrect,
    );
    return _buildState(
      lifecycle: isCorrect
          ? StudySessionLifecycle.waitingFeedback
          : StudySessionLifecycle.retryPending,
    );
  }

  StudySessionState submitFillAnswer(String answer) {
    if (!_canAct(StudyActionType.submitAnswer) ||
        _currentMode.mode != StudyMode.fill) {
      return state;
    }
    final isCorrect = _normalize(answer) == _normalize(_currentItem.answer);
    if (isCorrect) {
      _registerOutcome(mastered: true, retry: false);
      _feedback = const StudyModeFeedback(
        kind: StudyFeedbackKind.correct,
        copy: StudyFeedbackCopy.exactRecall,
      );
      return _buildState(lifecycle: StudySessionLifecycle.waitingFeedback);
    }
    _retryMarkedItemIds.add(_currentItem.id);
    _feedback = StudyModeFeedback(
      kind: StudyFeedbackKind.incorrect,
      copy: StudyFeedbackCopy.keepWorking,
      answerText: _currentItem.answer,
    );
    return _buildState(lifecycle: StudySessionLifecycle.retryPending);
  }

  StudySessionState goNext() {
    if (!_canAct(StudyActionType.goNext)) return state;
    _feedback = null;
    _answerRevealed = false;
    _interactionId += 1;
    if (_itemIndex + 1 < _currentMode.items.length) {
      _itemIndex += 1;
      return state;
    }
    if (_modeIndex + 1 < _blueprint.modes.length) {
      _modeIndex += 1;
      _itemIndex = 0;
      return state;
    }
    return _buildState(lifecycle: StudySessionLifecycle.completed);
  }

  StudySessionState resetCurrentMode() {
    final mode = _currentMode.mode;
    _completedByMode[mode] = 0;
    _retryByMode[mode] = 0;
    _masteredByMode[mode] = 0;
    _resolvedItemIds.removeWhere((id) => id.startsWith('${mode.name}-'));
    _retryMarkedItemIds.removeWhere((id) => id.startsWith('${mode.name}-'));
    _itemIndex = 0;
    _answerRevealed = false;
    _feedback = null;
    _interactionId += 1;
    return state;
  }
}
