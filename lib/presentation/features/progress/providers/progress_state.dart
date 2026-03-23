import 'package:flutter/foundation.dart';
import 'package:memora/presentation/features/progress/providers/progress_filter_provider.dart';

enum ProgressEscalationLevel { calm, watch, urgent, critical }

@immutable
class ProgressRecommendation {
  const ProgressRecommendation({
    required this.folderId,
    required this.deckId,
    required this.deckName,
    required this.dueCount,
    required this.overdueCount,
    required this.estimatedSessionMinutes,
    required this.recommendedSessionType,
  });

  final int folderId;
  final int deckId;
  final String deckName;
  final int dueCount;
  final int overdueCount;
  final int estimatedSessionMinutes;
  final String recommendedSessionType;
}

@immutable
class ProgressDistributionBucket {
  const ProgressDistributionBucket({required this.label, required this.count});

  final String label;
  final int count;

  double get value => count / 100;
}

@immutable
class ProgressHistoryEntry {
  const ProgressHistoryEntry({
    required this.title,
    required this.subtitle,
    required this.timestampLabel,
    required this.isPositive,
  });

  final String title;
  final String subtitle;
  final String timestampLabel;
  final bool isPositive;
}

@immutable
class ProgressStreakDay {
  const ProgressStreakDay({
    required this.label,
    required this.completed,
    required this.isToday,
  });

  final String label;
  final bool completed;
  final bool isToday;
}

@immutable
class ProgressState {
  const ProgressState({
    required this.period,
    required this.dueCount,
    required this.overdueCount,
    required this.escalationLevel,
    required this.reminderTypes,
    required this.totalLearnedItems,
    required this.passedAttempts,
    required this.failedAttempts,
    required this.boxDistribution,
    required this.history,
    required this.streakDays,
    this.recommendation,
  });

  final ProgressPeriod period;
  final int dueCount;
  final int overdueCount;
  final ProgressEscalationLevel escalationLevel;
  final List<String> reminderTypes;
  final ProgressRecommendation? recommendation;
  final int totalLearnedItems;
  final int passedAttempts;
  final int failedAttempts;
  final List<ProgressDistributionBucket> boxDistribution;
  final List<ProgressHistoryEntry> history;
  final List<ProgressStreakDay> streakDays;

  int get totalAttempts => passedAttempts + failedAttempts;

  double get successRate =>
      totalAttempts == 0 ? 0 : passedAttempts / totalAttempts;

  bool get hasRecommendation => recommendation != null;
}
