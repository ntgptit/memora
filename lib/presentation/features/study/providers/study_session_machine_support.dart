import 'package:memora/presentation/features/study/providers/study_session_state.dart';

const lockedInTitle = 'Locked in';
const lockedInMessage = 'This item is ready to leave the active review queue.';
const queuedTitle = 'Queued for another pass';
const queuedMessage = 'This item will stay visible in the weak-memory lane.';
const revealedTitle = 'Answer revealed';
const revealedMessage = 'Compare what you remembered before you move on.';
const exactRecallTitle = 'Exact recall';
const exactRecallMessage = 'You typed the full answer accurately.';
const keepWorkingTitle = 'Keep working this item';

StudySessionState buildStudySessionMachineState({
  required StudySessionBlueprint blueprint,
  required int modeIndex,
  required int itemIndex,
  required int interactionId,
  required bool answerRevealed,
  required bool audioEnabled,
  required int focusMinutes,
  required StudyModeFeedback? feedback,
  required Map<StudyMode, int> completedByMode,
  required Map<StudyMode, int> retryByMode,
  required Map<StudyMode, int> masteredByMode,
  required StudySessionLifecycle? lifecycleOverride,
}) {
  final currentMode = blueprint.modes[modeIndex];
  final completedItems = completedByMode.values.fold<int>(
    0,
    (sum, value) => sum + value,
  );
  final completedModes = blueprint.modes
      .where((mode) => (completedByMode[mode.mode] ?? 0) >= mode.items.length)
      .length;
  final lifecycle =
      lifecycleOverride ??
      (feedback == null
          ? StudySessionLifecycle.inProgress
          : StudySessionLifecycle.waitingFeedback);
  return StudySessionState(
    sessionId: 'study-${blueprint.sessionType.name}',
    interactionId: interactionId,
    deck: blueprint.deck,
    sessionType: blueprint.sessionType,
    lifecycle: lifecycle,
    activeMode: currentMode.mode,
    modePlan: [
      for (var index = 0; index < blueprint.modes.length; index++)
        StudyModePlanEntry(
          mode: blueprint.modes[index].mode,
          totalItems: blueprint.modes[index].items.length,
          completedItems: completedByMode[blueprint.modes[index].mode] ?? 0,
          retryItems: retryByMode[blueprint.modes[index].mode] ?? 0,
          isCurrent: index == modeIndex,
        ),
    ],
    progress: StudyProgressSnapshot(
      completedItems: completedItems,
      totalItems: blueprint.totalItems,
      completedModes: completedModes,
      totalModes: blueprint.modes.length,
      currentModeCompletedItems: completedByMode[currentMode.mode] ?? 0,
      currentModeTotalItems: currentMode.items.length,
    ),
    currentItem: currentMode.items[itemIndex],
    allowedActions: allowedActionsFor(
      mode: currentMode.mode,
      feedback: feedback,
      answerRevealed: answerRevealed,
      lifecycle: lifecycle,
    ),
    answerRevealed: answerRevealed,
    audioEnabled: audioEnabled,
    masteredItems: masteredByMode.values.fold<int>(
      0,
      (sum, value) => sum + value,
    ),
    retryItems: retryByMode.values.fold<int>(0, (sum, value) => sum + value),
    focusMinutes: focusMinutes,
    feedback: feedback,
  );
}

List<StudyActionType> allowedActionsFor({
  required StudyMode mode,
  required StudyModeFeedback? feedback,
  required bool answerRevealed,
  required StudySessionLifecycle lifecycle,
}) {
  if (lifecycle == StudySessionLifecycle.completed) {
    return const <StudyActionType>[];
  }
  if (feedback != null && mode != StudyMode.fill) {
    return const <StudyActionType>[
      StudyActionType.goNext,
      StudyActionType.resetCurrentMode,
    ];
  }
  switch (mode) {
    case StudyMode.review:
      return const <StudyActionType>[
        StudyActionType.markRemembered,
        StudyActionType.retryItem,
        StudyActionType.resetCurrentMode,
      ];
    case StudyMode.recall:
      if (!answerRevealed) {
        return const <StudyActionType>[
          StudyActionType.revealAnswer,
          StudyActionType.resetCurrentMode,
        ];
      }
      if (feedback != null) {
        return const <StudyActionType>[
          StudyActionType.goNext,
          StudyActionType.resetCurrentMode,
        ];
      }
      return const <StudyActionType>[
        StudyActionType.markRemembered,
        StudyActionType.retryItem,
        StudyActionType.resetCurrentMode,
      ];
    case StudyMode.guess:
    case StudyMode.match:
      return feedback == null
          ? const <StudyActionType>[
              StudyActionType.submitAnswer,
              StudyActionType.resetCurrentMode,
            ]
          : const <StudyActionType>[
              StudyActionType.goNext,
              StudyActionType.resetCurrentMode,
            ];
    case StudyMode.fill:
      if (feedback != null && feedback.kind == StudyFeedbackKind.correct) {
        return const <StudyActionType>[
          StudyActionType.goNext,
          StudyActionType.resetCurrentMode,
        ];
      }
      return const <StudyActionType>[
        StudyActionType.submitAnswer,
        StudyActionType.revealAnswer,
        StudyActionType.resetCurrentMode,
      ];
  }
}
