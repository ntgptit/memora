import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/screen_context_ext.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/composites/cards/app_stat_card.dart';

class DashboardSummaryCard extends StatelessWidget {
  const DashboardSummaryCard({
    super.key,
    required this.dueDeckCount,
    required this.dueCardCount,
    required this.reviewedToday,
    required this.dailyGoal,
    required this.totalStudyMinutes,
  });

  final int dueDeckCount;
  final int dueCardCount;
  final int reviewedToday;
  final int dailyGoal;
  final int totalStudyMinutes;

  @override
  Widget build(BuildContext context) {
    final gap = context.spacing.md;
    final remaining = (dailyGoal - reviewedToday).clamp(0, dailyGoal);
    final l10n = context.l10n;
    final metrics = [
      _MetricData(
        label: l10n.dashboardSummaryDueDecksLabel,
        value: l10n.dashboardDueDeckValue(dueDeckCount),
        subtitle: l10n.dashboardDueDeckChipLabel(dueDeckCount),
        icon: Icons.layers_rounded,
      ),
      _MetricData(
        label: l10n.dashboardSummaryDueCardsLabel,
        value: l10n.dashboardDueCardValue(dueCardCount),
        subtitle: l10n.dashboardDueCardChipLabel(dueCardCount),
        icon: Icons.style_rounded,
      ),
      _MetricData(
        label: l10n.dashboardSummaryReviewedLabel,
        value: l10n.dashboardReviewedValue(reviewedToday),
        subtitle: l10n.dashboardGoalProgressMessage(reviewedToday, dailyGoal),
        icon: Icons.check_circle_rounded,
      ),
      _MetricData(
        label: l10n.dashboardSummaryFocusTimeLabel,
        value: l10n.dashboardStudyMinutesValue(totalStudyMinutes),
        subtitle: l10n.dashboardGoalRemainingMessage(remaining),
        icon: Icons.schedule_rounded,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.dashboardSummaryTitle, style: context.textTheme.titleLarge),
        SizedBox(height: context.spacing.xxs),
        Text(
          l10n.dashboardSummarySubtitle,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: gap),
        LayoutBuilder(
          builder: (context, constraints) {
            final columns = context.screenClass.recommendedColumns.clamp(1, 2);
            final availableWidth = constraints.maxWidth.isFinite
                ? constraints.maxWidth
                : context.layout.contentMaxWidth;
            final itemWidth =
                (availableWidth - ((columns - 1) * gap)) / columns;

            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final metric in metrics)
                  SizedBox(
                    width: itemWidth,
                    child: AppStatCard(
                      label: metric.label,
                      value: metric.value,
                      subtitle: metric.subtitle,
                      leading: Icon(metric.icon),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _MetricData {
  const _MetricData({
    required this.label,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  final String label;
  final String value;
  final String subtitle;
  final IconData icon;
}
