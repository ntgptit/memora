import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'study_setup_provider.g.dart';

@Riverpod(keepAlive: true)
class StudySetupController extends _$StudySetupController {
  late StudySessionBlueprint _blueprint;

  @override
  StudySetupState build() {
    _blueprint = buildStudySessionBlueprint(
      sessionType: StudySessionType.review,
    );
    return _buildState(
      preferResumeSession: _blueprint.resumeSummary != null,
      highlightedMode: _blueprint.modes.first.mode,
    );
  }

  void selectSessionType(StudySessionType sessionType) {
    if (_blueprint.sessionType == sessionType) {
      return;
    }

    _blueprint = buildStudySessionBlueprint(sessionType: sessionType);
    state = _buildState(
      preferResumeSession: false,
      highlightedMode: _blueprint.modes.first.mode,
    );
  }

  void setPreferResumeSession(bool value) {
    if (value && _blueprint.resumeSummary == null) {
      return;
    }

    state = state.copyWith(preferResumeSession: value);
  }

  void highlightMode(StudyMode mode) {
    state = state.copyWith(highlightedMode: mode);
  }

  StudySetupState _buildState({
    required bool preferResumeSession,
    required StudyMode highlightedMode,
  }) {
    return StudySetupState(
      deck: _blueprint.deck,
      selectedSessionType: _blueprint.sessionType,
      preferResumeSession: preferResumeSession,
      highlightedMode: highlightedMode,
      modePlan: [
        for (var index = 0; index < _blueprint.modes.length; index++)
          StudyModePlanEntry(
            mode: _blueprint.modes[index].mode,
            totalItems: _blueprint.modes[index].items.length,
            completedItems: index == 0 ? 1 : 0,
            retryItems: index == 0 ? 1 : 0,
            isCurrent: highlightedMode == _blueprint.modes[index].mode,
          ),
      ],
      resumeSummary: _blueprint.resumeSummary,
      recentSessions: _blueprint.historyEntries,
    );
  }
}
