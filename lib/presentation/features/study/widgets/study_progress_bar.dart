import 'package:flutter/material.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/study/providers/study_l10n.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:memora/presentation/shared/composites/study/app_study_progress_header.dart';

class StudyProgressBar extends StatelessWidget {
  const StudyProgressBar({
    super.key,
    required this.progress,
    required this.activeMode,
  });

  final StudyProgressSnapshot progress;
  final StudyMode activeMode;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AppStudyProgressHeader(
      title: l10n.studyProgressTitle,
      subtitle: l10n.studyProgressSubtitle(
        activeMode.label(l10n),
        progress.completedModes,
        progress.totalModes,
      ),
      progress: progress.itemProgress,
      progressLabel: l10n.studyItemProgressLabel(
        progress.completedItems,
        progress.totalItems,
      ),
      trailing: Text(
        l10n.studyModeProgressLabel(
          progress.currentModeCompletedItems,
          progress.currentModeTotalItems,
        ),
      ),
    );
  }
}
