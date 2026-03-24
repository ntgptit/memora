import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:memora/presentation/shared/composites/cards/app_progress_card.dart';
import 'package:memora/presentation/shared/composites/cards/app_stat_card.dart';

const double _studyResultStatCardWidth = 220;

class StudyResultSummary extends StatelessWidget {
  const StudyResultSummary({super.key, required this.result});

  final StudyResultState result;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppProgressCard(
          title: l10n.studyResultCompletionTitle,
          subtitle: l10n.studyResultCompletionSubtitle,
          value: result.progress.itemProgress,
          progressLabel: l10n.studyItemProgressLabel(
            result.progress.completedItems,
            result.progress.totalItems,
          ),
        ),
        SizedBox(height: context.spacing.lg),
        Wrap(
          spacing: context.spacing.md,
          runSpacing: context.spacing.md,
          children: [
            SizedBox(
              width: _studyResultStatCardWidth,
              child: AppStatCard(
                label: l10n.studyResultMasteredLabel,
                value: '${result.masteredItems}',
                subtitle: l10n.studyResultMasteredSubtitle,
              ),
            ),
            SizedBox(
              width: _studyResultStatCardWidth,
              child: AppStatCard(
                label: l10n.studyResultRetryLabel,
                value: '${result.retryItems}',
                subtitle: l10n.studyResultRetrySubtitle,
              ),
            ),
            SizedBox(
              width: _studyResultStatCardWidth,
              child: AppStatCard(
                label: l10n.studyResultFocusLabel,
                value: l10n.studyMinutesShortLabel(result.focusMinutes),
                subtitle: l10n.studyResultFocusSubtitle,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
