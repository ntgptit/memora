import 'package:memora/l10n/app_localizations.dart';
import 'package:memora/presentation/features/progress/providers/progress_state.dart';

class ProgressSampleProfile {
  const ProgressSampleProfile({
    required this.dueCount,
    required this.overdueCount,
    required this.totalLearnedItems,
    required this.passedAttempts,
    required this.failedAttempts,
    required this.escalationLevel,
    required this.recommendation,
    required this.reminderTypes,
    required this.boxDistribution,
    required this.history,
    required this.streakDays,
  });

  final int dueCount;
  final int overdueCount;
  final int totalLearnedItems;
  final int passedAttempts;
  final int failedAttempts;
  final ProgressEscalationLevel escalationLevel;
  final ProgressRecommendation recommendation;
  final List<String> reminderTypes;
  final List<ProgressDistributionBucket> boxDistribution;
  final List<ProgressHistoryEntry> history;
  final List<ProgressStreakDay> streakDays;
}

List<ProgressDistributionBucket> buildProgressBoxDistribution(
  AppLocalizations l10n,
  List<int> counts,
) {
  return [
    for (var index = 0; index < counts.length; index++)
      ProgressDistributionBucket(
        label: l10n.progressBoxLabel(index + 1),
        count: counts[index],
      ),
  ];
}

List<ProgressStreakDay> buildProgressWeekdayStreak(
  AppLocalizations l10n,
  List<bool> completed, {
  required int todayIndex,
}) {
  final labels = [
    l10n.progressDayMonShort,
    l10n.progressDayTueShort,
    l10n.progressDayWedShort,
    l10n.progressDayThuShort,
    l10n.progressDayFriShort,
    l10n.progressDaySatShort,
    l10n.progressDaySunShort,
  ];

  return [
    for (var index = 0; index < labels.length; index++)
      ProgressStreakDay(
        label: labels[index],
        completed: completed[index],
        isToday: index == todayIndex,
      ),
  ];
}

List<ProgressStreakDay> buildProgressNumericStreak(
  List<int> labels,
  List<bool> completed, {
  required int todayIndex,
}) {
  return [
    for (var index = 0; index < labels.length; index++)
      ProgressStreakDay(
        label: labels[index].toString(),
        completed: completed[index],
        isToday: index == todayIndex,
      ),
  ];
}
