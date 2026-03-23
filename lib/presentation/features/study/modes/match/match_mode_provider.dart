import 'package:flutter/foundation.dart';
import 'package:memora/presentation/features/study/providers/study_session_provider.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'match_mode_provider.g.dart';

@immutable
class MatchModeState {
  const MatchModeState({
    required this.item,
    required this.selectedLeftId,
    required this.selectedRightId,
    required this.matchedPairs,
    required this.feedback,
    required this.canSubmit,
    required this.canGoNext,
  });

  final StudySessionItem item;
  final String? selectedLeftId;
  final String? selectedRightId;
  final List<StudyMatchedPair> matchedPairs;
  final StudyModeFeedback? feedback;
  final bool canSubmit;
  final bool canGoNext;
}

@Riverpod(keepAlive: false)
class MatchModeController extends _$MatchModeController {
  int? _lastInteractionId;
  String? _selectedLeftId;
  String? _selectedRightId;
  List<StudyMatchedPair> _matchedPairs = const <StudyMatchedPair>[];

  @override
  MatchModeState? build() {
    final session = ref.watch(studySessionControllerProvider);
    if (session.sessionCompleted || session.activeMode != StudyMode.match) {
      return null;
    }

    if (_lastInteractionId != session.interactionId) {
      _lastInteractionId = session.interactionId;
      _selectedLeftId = null;
      _selectedRightId = null;
      _matchedPairs = const <StudyMatchedPair>[];
    }

    return _toState(session);
  }

  void selectLeft(String leftId) {
    final current = state;
    if (current == null || current.feedback != null) {
      return;
    }

    _selectedLeftId = leftId;
    _tryCreatePair();
    state = _toState(ref.read(studySessionControllerProvider));
  }

  void selectRight(String rightId) {
    final current = state;
    if (current == null || current.feedback != null) {
      return;
    }

    _selectedRightId = rightId;
    _tryCreatePair();
    state = _toState(ref.read(studySessionControllerProvider));
  }

  void removePair(StudyMatchedPair pair) {
    _matchedPairs = _matchedPairs
        .where(
          (candidate) =>
              candidate.leftId != pair.leftId ||
              candidate.rightId != pair.rightId,
        )
        .toList(growable: false);
    state = _toState(ref.read(studySessionControllerProvider));
  }

  void submitPairs() {
    final current = state;
    if (current == null || !current.canSubmit) {
      return;
    }

    ref
        .read(studySessionControllerProvider.notifier)
        .submitMatch(_matchedPairs);
  }

  void goNext() {
    ref.read(studySessionControllerProvider.notifier).goNext();
  }

  void _tryCreatePair() {
    final leftId = _selectedLeftId;
    final rightId = _selectedRightId;
    if (leftId == null || rightId == null) {
      return;
    }

    final nextPairs = _matchedPairs
        .where((pair) => pair.leftId != leftId && pair.rightId != rightId)
        .toList(growable: true);
    nextPairs.add(StudyMatchedPair(leftId: leftId, rightId: rightId));
    _matchedPairs = nextPairs.toList(growable: false);
    _selectedLeftId = null;
    _selectedRightId = null;
  }

  MatchModeState _toState(StudySessionState session) {
    return MatchModeState(
      item: session.currentItem,
      selectedLeftId: _selectedLeftId,
      selectedRightId: _selectedRightId,
      matchedPairs: _matchedPairs,
      feedback: session.feedback,
      canSubmit:
          _matchedPairs.length == session.currentItem.matchPairs.length &&
          session.allowedActions.contains(StudyActionType.submitAnswer),
      canGoNext: session.allowedActions.contains(StudyActionType.goNext),
    );
  }
}
