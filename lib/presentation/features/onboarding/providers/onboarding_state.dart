import 'package:flutter/foundation.dart';

enum StudyGoalPreset { steady, focused, intensive }

@immutable
class OnboardingState {
  const OnboardingState({
    required this.currentPageIndex,
    required this.notificationsEnabled,
    required this.audioPromptsEnabled,
    required this.selectedGoal,
    required this.dailyGoalCards,
    required this.sessionLengthMinutes,
    required this.isCompleted,
  });

  factory OnboardingState.initial() {
    return const OnboardingState(
      currentPageIndex: 0,
      notificationsEnabled: true,
      audioPromptsEnabled: true,
      selectedGoal: StudyGoalPreset.steady,
      dailyGoalCards: 20,
      sessionLengthMinutes: 15,
      isCompleted: false,
    );
  }

  final int currentPageIndex;
  final bool notificationsEnabled;
  final bool audioPromptsEnabled;
  final StudyGoalPreset selectedGoal;
  final int dailyGoalCards;
  final int sessionLengthMinutes;
  final bool isCompleted;

  OnboardingState copyWith({
    int? currentPageIndex,
    bool? notificationsEnabled,
    bool? audioPromptsEnabled,
    StudyGoalPreset? selectedGoal,
    int? dailyGoalCards,
    int? sessionLengthMinutes,
    bool? isCompleted,
  }) {
    return OnboardingState(
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      audioPromptsEnabled: audioPromptsEnabled ?? this.audioPromptsEnabled,
      selectedGoal: selectedGoal ?? this.selectedGoal,
      dailyGoalCards: dailyGoalCards ?? this.dailyGoalCards,
      sessionLengthMinutes: sessionLengthMinutes ?? this.sessionLengthMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
