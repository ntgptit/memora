import 'package:memora/presentation/features/study/providers/study_session_machine.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'study_session_provider.g.dart';

@Riverpod(keepAlive: true)
class StudySessionController extends _$StudySessionController {
  late StudySessionMachine _machine;

  @override
  StudySessionState build() {
    _machine = StudySessionMachine(
      blueprint: buildStudySessionBlueprint(
        sessionType: StudySessionType.review,
      ),
    );
    return _machine.state;
  }

  void prepareFromSetup(StudySetupState setupState) {
    state = _machine.prepareFromSetup(setupState);
  }

  void toggleAudioEnabled() => state = _machine.toggleAudioEnabled();
  void markRemembered() => state = _machine.markRemembered();
  void retryItem() => state = _machine.retryItem();
  void revealAnswer() => state = _machine.revealAnswer();
  void submitGuess(String choiceId) => state = _machine.submitGuess(choiceId);
  void submitMatch(List<StudyMatchedPair> pairs) =>
      state = _machine.submitMatch(pairs);
  void submitFillAnswer(String answer) =>
      state = _machine.submitFillAnswer(answer);
  void goNext() => state = _machine.goNext();
  void resetCurrentMode() => state = _machine.resetCurrentMode();
}
