import 'package:flutter/foundation.dart';
import 'package:memora/presentation/features/study/providers/study_blueprint_models.dart';
import 'package:memora/presentation/features/study/providers/study_core_models.dart';

@immutable
class StudyModePlanEntry {
  const StudyModePlanEntry({
    required this.mode,
    required this.totalItems,
    required this.completedItems,
    required this.retryItems,
    required this.isCurrent,
  });

  final StudyMode mode;
  final int totalItems;
  final int completedItems;
  final int retryItems;
  final bool isCurrent;

  bool get isCompleted => completedItems >= totalItems && totalItems > 0;

  double get progress => totalItems == 0 ? 0 : completedItems / totalItems;
}

@immutable
class StudyProgressSnapshot {
  const StudyProgressSnapshot({
    required this.completedItems,
    required this.totalItems,
    required this.completedModes,
    required this.totalModes,
    required this.currentModeCompletedItems,
    required this.currentModeTotalItems,
  });

  final int completedItems;
  final int totalItems;
  final int completedModes;
  final int totalModes;
  final int currentModeCompletedItems;
  final int currentModeTotalItems;

  double get itemProgress => totalItems == 0 ? 0 : completedItems / totalItems;
  double get modeProgress => totalModes == 0 ? 0 : completedModes / totalModes;

  double get currentModeProgress {
    return currentModeTotalItems == 0
        ? 0
        : currentModeCompletedItems / currentModeTotalItems;
  }
}

@immutable
class StudySetupState {
  const StudySetupState({
    required this.deck,
    required this.selectedSessionType,
    required this.preferResumeSession,
    required this.highlightedMode,
    required this.modePlan,
    required this.resumeSummary,
    required this.recentSessions,
  });

  final StudyDeckSummary deck;
  final StudySessionType selectedSessionType;
  final bool preferResumeSession;
  final StudyMode highlightedMode;
  final List<StudyModePlanEntry> modePlan;
  final StudyResumeSummary? resumeSummary;
  final List<StudyHistoryEntry> recentSessions;

  bool get hasResumeSession => resumeSummary != null;

  StudySetupState copyWith({
    StudyDeckSummary? deck,
    StudySessionType? selectedSessionType,
    bool? preferResumeSession,
    StudyMode? highlightedMode,
    List<StudyModePlanEntry>? modePlan,
    StudyResumeSummary? resumeSummary,
    List<StudyHistoryEntry>? recentSessions,
    bool clearResumeSummary = false,
  }) {
    return StudySetupState(
      deck: deck ?? this.deck,
      selectedSessionType: selectedSessionType ?? this.selectedSessionType,
      preferResumeSession: preferResumeSession ?? this.preferResumeSession,
      highlightedMode: highlightedMode ?? this.highlightedMode,
      modePlan: modePlan ?? this.modePlan,
      resumeSummary: clearResumeSummary
          ? null
          : resumeSummary ?? this.resumeSummary,
      recentSessions: recentSessions ?? this.recentSessions,
    );
  }
}

@immutable
class StudySessionState {
  const StudySessionState({
    required this.sessionId,
    required this.interactionId,
    required this.deck,
    required this.sessionType,
    required this.lifecycle,
    required this.activeMode,
    required this.modePlan,
    required this.progress,
    required this.currentItem,
    required this.allowedActions,
    required this.answerRevealed,
    required this.audioEnabled,
    required this.masteredItems,
    required this.retryItems,
    required this.focusMinutes,
    this.feedback,
  });

  final String sessionId;
  final int interactionId;
  final StudyDeckSummary deck;
  final StudySessionType sessionType;
  final StudySessionLifecycle lifecycle;
  final StudyMode activeMode;
  final List<StudyModePlanEntry> modePlan;
  final StudyProgressSnapshot progress;
  final StudySessionItem currentItem;
  final List<StudyActionType> allowedActions;
  final bool answerRevealed;
  final bool audioEnabled;
  final int masteredItems;
  final int retryItems;
  final int focusMinutes;
  final StudyModeFeedback? feedback;

  bool get sessionCompleted => lifecycle == StudySessionLifecycle.completed;
  bool get supportsAudio => currentItem.supportsAudio;
}

@immutable
class StudyResultState {
  const StudyResultState({
    required this.deck,
    required this.sessionType,
    required this.progress,
    required this.modePlan,
    required this.masteredItems,
    required this.retryItems,
    required this.focusMinutes,
    required this.sessionCompleted,
    required this.recentSessions,
  });

  final StudyDeckSummary deck;
  final StudySessionType sessionType;
  final StudyProgressSnapshot progress;
  final List<StudyModePlanEntry> modePlan;
  final int masteredItems;
  final int retryItems;
  final int focusMinutes;
  final bool sessionCompleted;
  final List<StudyHistoryEntry> recentSessions;

  double get masteryRatio =>
      progress.totalItems == 0 ? 0 : masteredItems / progress.totalItems;
}
