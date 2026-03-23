import 'package:memora/presentation/features/study/providers/study_session_machine_support.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';

part 'study_session_machine_actions.dart';

class StudySessionMachine {
  StudySessionMachine({required StudySessionBlueprint blueprint}) {
    _prime(blueprint, startMode: null);
  }

  late StudySessionBlueprint _blueprint;
  int _modeIndex = 0;
  int _itemIndex = 0;
  int _interactionId = 0;
  bool _answerRevealed = false;
  bool _audioEnabled = true;
  int _focusMinutes = 12;
  StudyModeFeedback? _feedback;
  final _completedByMode = <StudyMode, int>{};
  final _retryByMode = <StudyMode, int>{};
  final _masteredByMode = <StudyMode, int>{};
  final _resolvedItemIds = <String>{};
  final _retryMarkedItemIds = <String>{};

  StudySessionState get state => _buildState();

  StudySessionState prepareFromSetup(StudySetupState setupState) {
    final blueprint = buildStudySessionBlueprint(
      sessionType: setupState.selectedSessionType,
    );
    _prime(
      blueprint,
      startMode: setupState.preferResumeSession
          ? blueprint.resumeSummary?.activeMode
          : setupState.highlightedMode,
    );
    return state;
  }

  StudySessionState toggleAudioEnabled() {
    _audioEnabled = !_audioEnabled;
    return state;
  }

  void _prime(
    StudySessionBlueprint blueprint, {
    required StudyMode? startMode,
  }) {
    _blueprint = blueprint;
    _completedByMode.clear();
    _retryByMode.clear();
    _masteredByMode.clear();
    _resolvedItemIds.clear();
    _retryMarkedItemIds.clear();
    _feedback = null;
    _answerRevealed = false;
    _audioEnabled = true;
    _focusMinutes = blueprint.deck.estimatedMinutes;
    _interactionId += 1;
    _modeIndex = 0;
    _itemIndex = 0;
    if (startMode != null) {
      final targetIndex = _blueprint.modes.indexWhere(
        (mode) => mode.mode == startMode,
      );
      if (targetIndex >= 0) {
        _modeIndex = targetIndex;
      }
    }
    if (startMode != null && blueprint.resumeSummary != null) {
      _seedResumeProgress(blueprint.resumeSummary!);
    }
  }

  void _seedResumeProgress(StudyResumeSummary resume) {
    var remainingCompleted = resume.completedItems;
    for (final mode in _blueprint.modes) {
      final completedForMode = remainingCompleted.clamp(0, mode.items.length);
      _completedByMode[mode.mode] = completedForMode;
      _masteredByMode[mode.mode] = completedForMode == 0
          ? 0
          : (completedForMode - 1).clamp(0, completedForMode);
      _retryByMode[mode.mode] = completedForMode == 0 ? 0 : 1;
      remainingCompleted -= completedForMode;
    }
    _itemIndex = (_completedByMode[_currentMode.mode] ?? 0).clamp(
      0,
      _currentMode.items.length - 1,
    );
  }

  StudyModeBlueprint get _currentMode => _blueprint.modes[_modeIndex];
  StudySessionItem get _currentItem => _currentMode.items[_itemIndex];
  bool _canAct(StudyActionType action) => state.allowedActions.contains(action);

  void _registerOutcome({required bool mastered, required bool retry}) {
    final currentMode = _currentMode.mode;
    if (_resolvedItemIds.add(_currentItem.id)) {
      _completedByMode[currentMode] = (_completedByMode[currentMode] ?? 0) + 1;
    }
    if (mastered) {
      _masteredByMode[currentMode] = (_masteredByMode[currentMode] ?? 0) + 1;
    }
    if (retry && _retryMarkedItemIds.add(_currentItem.id)) {
      _retryByMode[currentMode] = (_retryByMode[currentMode] ?? 0) + 1;
    }
    _interactionId += 1;
  }

  StudySessionState _buildState({StudySessionLifecycle? lifecycle}) {
    return buildStudySessionMachineState(
      blueprint: _blueprint,
      modeIndex: _modeIndex,
      itemIndex: _itemIndex,
      interactionId: _interactionId,
      answerRevealed: _answerRevealed,
      audioEnabled: _audioEnabled,
      focusMinutes: _focusMinutes,
      feedback: _feedback,
      completedByMode: _completedByMode,
      retryByMode: _retryByMode,
      masteredByMode: _masteredByMode,
      lifecycleOverride: lifecycle,
    );
  }

  String _normalize(String value) =>
      value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
}
