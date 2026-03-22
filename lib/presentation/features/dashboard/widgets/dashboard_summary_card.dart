import 'package:flutter/material.dart';
import 'package:memora/core/config/app_strings.dart';
import 'package:memora/core/theme/extensions/screen_context_ext.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
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
    final metrics = [
      _MetricData(
        label: AppStrings.dashboardSummaryDueDecksLabel,
        value: AppStrings.dashboardDueDeckValue(dueDeckCount.toString()),
        subtitle: AppStrings.dashboardDueDeckChipLabel(dueDeckCount.toString()),
        icon: Icons.layers_rounded,
      ),
      _MetricData(
        label: AppStrings.dashboardSummaryDueCardsLabel,
        value: AppStrings.dashboardDueCardValue(dueCardCount.toString()),
        subtitle: AppStrings.dashboardDueCardChipLabel(dueCardCount.toString()),
        icon: Icons.style_rounded,
      ),
      _MetricData(
        label: AppStrings.dashboardSummaryReviewedLabel,
        value: AppStrings.dashboardReviewedValue(reviewedToday.toString()),
        subtitle: AppStrings.dashboardGoalProgressMessage(
          reviewedToday.toString(),
          dailyGoal.toString(),
        ),
        icon: Icons.check_circle_rounded,
      ),
      _MetricData(
        label: AppStrings.dashboardSummaryFocusTimeLabel,
        value: AppStrings.dashboardStudyMinutesValue(
          totalStudyMinutes.toString(),
        ),
        subtitle: AppStrings.dashboardGoalRemainingMessage(
          remaining.toString(),
        ),
        icon: Icons.schedule_rounded,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.dashboardSummaryTitle,
          style: context.textTheme.titleLarge,
        ),
        SizedBox(height: context.spacing.xxs),
        Text(
          AppStrings.dashboardSummarySubtitle,
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
