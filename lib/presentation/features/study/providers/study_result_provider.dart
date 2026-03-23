import 'package:memora/presentation/features/study/providers/study_session_provider.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'study_result_provider.g.dart';

@Riverpod(keepAlive: true)
StudyResultState studyResultController(Ref ref) {
  final session = ref.watch(studySessionControllerProvider);
  final blueprint = buildStudySessionBlueprint(
    sessionType: session.sessionType,
  );
  return StudyResultState(
    deck: session.deck,
    sessionType: session.sessionType,
    progress: session.progress,
    modePlan: session.modePlan,
    masteredItems: session.masteredItems,
    retryItems: session.retryItems,
    focusMinutes: session.focusMinutes,
    sessionCompleted: session.sessionCompleted,
    recentSessions: blueprint.historyEntries,
  );
}
