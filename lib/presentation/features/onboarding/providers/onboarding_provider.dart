import 'package:memora/presentation/features/onboarding/providers/onboarding_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_provider.g.dart';

@Riverpod(keepAlive: true)
class OnboardingController extends _$OnboardingController {
  @override
  OnboardingState build() {
    return OnboardingState.initial();
  }

  void setPage(int index) {
    state = state.copyWith(currentPageIndex: index);
  }

  void nextPage(int lastIndex) {
    if (state.currentPageIndex >= lastIndex) {
      return;
    }
    state = state.copyWith(currentPageIndex: state.currentPageIndex + 1);
  }

  void previousPage() {
    if (state.currentPageIndex <= 0) {
      return;
    }
    state = state.copyWith(currentPageIndex: state.currentPageIndex - 1);
  }

  void toggleNotifications(bool value) {
    state = state.copyWith(notificationsEnabled: value);
  }

  void toggleAudioPrompts(bool value) {
    state = state.copyWith(audioPromptsEnabled: value);
  }

  void setGoal(StudyGoalPreset goal) {
    final defaults = switch (goal) {
      StudyGoalPreset.steady => (20, 15),
      StudyGoalPreset.focused => (35, 20),
      StudyGoalPreset.intensive => (60, 30),
    };

    state = state.copyWith(
      selectedGoal: goal,
      dailyGoalCards: defaults.$1,
      sessionLengthMinutes: defaults.$2,
    );
  }

  void setDailyGoalCards(int value) {
    state = state.copyWith(dailyGoalCards: value.clamp(5, 200));
  }

  void setSessionLengthMinutes(int value) {
    state = state.copyWith(sessionLengthMinutes: value.clamp(5, 120));
  }

  void complete() {
    state = state.copyWith(isCompleted: true);
  }

  void reset() {
    state = OnboardingState.initial();
  }
}
