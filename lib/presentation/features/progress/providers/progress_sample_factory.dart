import 'package:memora/l10n/app_localizations.dart';
import 'package:memora/presentation/features/progress/providers/progress_filter_provider.dart';
import 'package:memora/presentation/features/progress/providers/progress_sample_support.dart';
import 'package:memora/presentation/features/progress/providers/progress_state.dart';

ProgressState buildSampleProgressState({
  required ProgressPeriod period,
  required AppLocalizations l10n,
}) {
  final profile = switch (period) {
    ProgressPeriod.today => ProgressSampleProfile(
      dueCount: 12,
      overdueCount: 4,
      totalLearnedItems: 1248,
      passedAttempts: 82,
      failedAttempts: 11,
      escalationLevel: ProgressEscalationLevel.urgent,
      recommendation: ProgressRecommendation(
        folderId: 7,
        deckId: 42,
        deckName: l10n.dashboardTravelDeckTitle,
        dueCount: 12,
        overdueCount: 4,
        estimatedSessionMinutes: 14,
        recommendedSessionType: l10n.progressSessionReviewSprintLabel,
      ),
      reminderTypes: [
        l10n.progressReminderSrsReviewLabel,
        l10n.progressReminderOverdueCatchUpLabel,
      ],
      boxDistribution: buildProgressBoxDistribution(l10n, const [
        14,
        22,
        31,
        25,
        18,
      ]),
      history: [
        ProgressHistoryEntry(
          title: l10n.dashboardTravelDeckTitle,
          subtitle: l10n.progressHistoryCompletedAccuracy(18, 94),
          timestampLabel: l10n.progressTimestampTodayAt('08:20'),
          isPositive: true,
        ),
        ProgressHistoryEntry(
          title: l10n.dashboardMedicalDeckTitle,
          subtitle: l10n.progressHistoryMissedCards(3),
          timestampLabel: l10n.progressTimestampTodayAt('06:40'),
          isPositive: false,
        ),
        ProgressHistoryEntry(
          title: l10n.progressJapaneseBasicsDeckTitle,
          subtitle: l10n.progressHistoryScheduledTomorrow(12),
          timestampLabel: l10n.progressTimestampYesterdayAt('21:10'),
          isPositive: true,
        ),
      ],
      streakDays: buildProgressWeekdayStreak(l10n, const [
        true,
        true,
        true,
        true,
        true,
        false,
        true,
      ], todayIndex: 6),
    ),
    ProgressPeriod.week => ProgressSampleProfile(
      dueCount: 28,
      overdueCount: 8,
      totalLearnedItems: 1294,
      passedAttempts: 184,
      failedAttempts: 29,
      escalationLevel: ProgressEscalationLevel.watch,
      recommendation: ProgressRecommendation(
        folderId: 7,
        deckId: 42,
        deckName: l10n.dashboardTravelDeckTitle,
        dueCount: 28,
        overdueCount: 8,
        estimatedSessionMinutes: 18,
        recommendedSessionType: l10n.progressSessionFocusedReviewLabel,
      ),
      reminderTypes: [
        l10n.progressReminderMorningReviewLabel,
        l10n.progressReminderEveningReviewLabel,
        l10n.progressReminderOverdueCatchUpLabel,
      ],
      boxDistribution: buildProgressBoxDistribution(l10n, const [
        12,
        19,
        29,
        33,
        21,
      ]),
      history: [
        ProgressHistoryEntry(
          title: l10n.dashboardVerbsDeckTitle,
          subtitle: l10n.progressHistoryFinishedWeek(25),
          timestampLabel: l10n.progressTimestampTodayAt('18:25'),
          isPositive: true,
        ),
        ProgressHistoryEntry(
          title: l10n.dashboardTravelDeckTitle,
          subtitle: l10n.progressHistoryLeftForNextSprint(8),
          timestampLabel: l10n.progressTimestampYesterdayAt('20:05'),
          isPositive: true,
        ),
        ProgressHistoryEntry(
          title: l10n.progressExamPrepDeckTitle,
          subtitle: l10n.progressHistoryResetToBoxOne(2),
          timestampLabel: l10n.progressTimestampDayAt(
            l10n.progressDayMonShort,
            '07:15',
          ),
          isPositive: false,
        ),
      ],
      streakDays: buildProgressWeekdayStreak(l10n, const [
        true,
        true,
        true,
        true,
        true,
        true,
        false,
      ], todayIndex: 6),
    ),
    ProgressPeriod.month => ProgressSampleProfile(
      dueCount: 64,
      overdueCount: 13,
      totalLearnedItems: 1388,
      passedAttempts: 348,
      failedAttempts: 53,
      escalationLevel: ProgressEscalationLevel.critical,
      recommendation: ProgressRecommendation(
        folderId: 7,
        deckId: 42,
        deckName: l10n.dashboardTravelDeckTitle,
        dueCount: 64,
        overdueCount: 13,
        estimatedSessionMinutes: 24,
        recommendedSessionType: l10n.progressSessionDeepReviewLabel,
      ),
      reminderTypes: [
        l10n.progressReminderMorningReviewLabel,
        l10n.progressReminderAfternoonReviewLabel,
        l10n.progressReminderOverdueCatchUpLabel,
      ],
      boxDistribution: buildProgressBoxDistribution(l10n, const [
        8,
        15,
        27,
        38,
        24,
      ]),
      history: [
        ProgressHistoryEntry(
          title: l10n.dashboardMedicalDeckTitle,
          subtitle: l10n.progressHistoryMaintainedAccuracy(91),
          timestampLabel: l10n.progressTimestampHoursAgo(2),
          isPositive: true,
        ),
        ProgressHistoryEntry(
          title: l10n.dashboardTravelDeckTitle,
          subtitle: l10n.progressHistoryAccumulatedDueCards(64),
          timestampLabel: l10n.progressTimestampTodayAt('09:10'),
          isPositive: false,
        ),
        ProgressHistoryEntry(
          title: l10n.progressJapaneseBasicsDeckTitle,
          subtitle: l10n.progressHistoryStrongestGrowth(
            l10n.progressBoxLabel(4),
          ),
          timestampLabel: l10n.progressTimestampYesterdayAt('17:50'),
          isPositive: true,
        ),
      ],
      streakDays: buildProgressNumericStreak(
        const [1, 2, 3, 4, 5, 6, 7],
        const [true, true, true, false, true, true, true],
        todayIndex: 6,
      ),
    ),
  };

  return ProgressState(
    period: period,
    dueCount: profile.dueCount,
    overdueCount: profile.overdueCount,
    escalationLevel: profile.escalationLevel,
    reminderTypes: profile.reminderTypes,
    recommendation: profile.recommendation,
    totalLearnedItems: profile.totalLearnedItems,
    passedAttempts: profile.passedAttempts,
    failedAttempts: profile.failedAttempts,
    boxDistribution: profile.boxDistribution,
    history: profile.history,
    streakDays: profile.streakDays,
  );
}
