import 'package:flutter/material.dart';
import 'package:memora/core/config/app_strings.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/presentation/shared/composites/cards/app_info_card.dart';
import 'package:memora/presentation/shared/primitives/displays/app_progress_bar.dart';
import 'package:memora/presentation/shared/primitives/displays/app_tag.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';
import 'package:memora/presentation/shared/primitives/text/app_title_text.dart';

class DashboardStreakCard extends StatelessWidget {
  const DashboardStreakCard({
    super.key,
    required this.currentStreak,
    required this.reviewedToday,
    required this.dailyGoal,
  });

  final int currentStreak;
  final int reviewedToday;
  final int dailyGoal;

  @override
  Widget build(BuildContext context) {
    final progress = dailyGoal == 0
        ? 0.0
        : (reviewedToday / dailyGoal).clamp(0, 1).toDouble();
    final remaining = (dailyGoal - reviewedToday).clamp(0, dailyGoal);

    return AppInfoCard(
      title: AppStrings.dashboardStreakTitle,
      subtitle: AppStrings.dashboardStreakSubtitle,
      leading: Icon(
        Icons.local_fire_department_rounded,
        color: context.colorScheme.error,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTag(
            label: AppStrings.dashboardStreakValue(currentStreak.toString()),
            icon: const Icon(Icons.whatshot_rounded, size: 14),
            backgroundColor: context.colorScheme.errorContainer,
            textColor: context.colorScheme.onErrorContainer,
          ),
          SizedBox(height: context.spacing.md),
          AppTitleText(text: AppStrings.dashboardDailyGoalLabel),
          SizedBox(height: context.spacing.xxs),
          AppBodyText(
            text: AppStrings.dashboardGoalProgressMessage(
              reviewedToday.toString(),
              dailyGoal.toString(),
            ),
            isSecondary: true,
          ),
          SizedBox(height: context.spacing.sm),
          AppProgressBar(value: progress),
          SizedBox(height: context.spacing.sm),
          AppBodyText(
            text: AppStrings.dashboardGoalRemainingMessage(
              remaining.toString(),
            ),
            isSecondary: true,
          ),
        ],
      ),
    );
  }
}
