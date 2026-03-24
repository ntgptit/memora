import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/progress/providers/progress_state.dart';
import 'package:memora/presentation/shared/composites/cards/app_info_card.dart';
import 'package:memora/presentation/shared/composites/cards/app_stat_card.dart';
import 'package:memora/presentation/shared/primitives/displays/app_tag.dart';

const double _progressSummaryStatCardWidth = 168;

class ProgressSummaryCard extends StatelessWidget {
  const ProgressSummaryCard({super.key, required this.state});

  final ProgressState state;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final successRate = (state.successRate * 100).round();

    return AppInfoCard(
      title: l10n.progressSummaryTitle,
      subtitle: l10n.progressSummarySubtitle,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: context.spacing.md,
            runSpacing: context.spacing.md,
            children: [
              SizedBox(
                width: _progressSummaryStatCardWidth,
                child: AppStatCard(
                  label: l10n.progressDueLabel,
                  value: state.dueCount.toString(),
                  subtitle: l10n.progressReminderTypesLabel,
                ),
              ),
              SizedBox(
                width: _progressSummaryStatCardWidth,
                child: AppStatCard(
                  label: l10n.progressOverdueLabel,
                  value: state.overdueCount.toString(),
                  subtitle: escalationLabel(context, state.escalationLevel),
                ),
              ),
              SizedBox(
                width: _progressSummaryStatCardWidth,
                child: AppStatCard(
                  label: l10n.progressLearnedLabel,
                  value: state.totalLearnedItems.toString(),
                  subtitle: l10n.progressBoxDistributionLabel,
                ),
              ),
              SizedBox(
                width: _progressSummaryStatCardWidth,
                child: AppStatCard(
                  label: l10n.progressAccuracyLabel,
                  value: '$successRate%',
                  subtitle: l10n.progressPassedAttemptsLabel,
                ),
              ),
            ],
          ),
          if (state.reminderTypes.isNotEmpty) ...[
            SizedBox(height: context.spacing.md),
            Wrap(
              spacing: context.spacing.xs,
              runSpacing: context.spacing.xs,
              children: [
                AppTag(label: escalationLabel(context, state.escalationLevel)),
                for (final reminderType in state.reminderTypes)
                  AppTag(label: reminderType),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

String escalationLabel(BuildContext context, ProgressEscalationLevel level) {
  final l10n = context.l10n;
  return switch (level) {
    ProgressEscalationLevel.calm => l10n.progressEscalationCalmLabel,
    ProgressEscalationLevel.watch => l10n.progressEscalationWatchLabel,
    ProgressEscalationLevel.urgent => l10n.progressEscalationUrgentLabel,
    ProgressEscalationLevel.critical => l10n.progressEscalationCriticalLabel,
  };
}
