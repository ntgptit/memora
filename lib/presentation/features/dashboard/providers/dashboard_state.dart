import 'package:flutter/material.dart';
import 'package:memora/core/config/app_strings.dart';

@immutable
class DashboardState {
  const DashboardState({
    required this.headlineTitle,
    required this.headlineSubtitle,
    required this.focusLabel,
    required this.reviewedToday,
    required this.dailyGoal,
    required this.totalStudyMinutes,
    required this.currentStreak,
    required this.dueDecks,
    required this.quickActions,
  });

  factory DashboardState.sample() {
    return DashboardState(
      headlineTitle: AppStrings.dashboardTitle,
      headlineSubtitle: AppStrings.dashboardHeadlineSubtitle,
      focusLabel: AppStrings.dashboardReviewFocusLabel,
      reviewedToday: 36,
      dailyGoal: 60,
      totalStudyMinutes: 48,
      currentStreak: 9,
      dueDecks: const [
        DashboardDueDeckItem(
          id: 'verbs',
          title: AppStrings.dashboardVerbsDeckTitle,
          folderName: AppStrings.dashboardLanguageLabFolder,
          modeLabel: AppStrings.dashboardRecallModeLabel,
          dueCardCount: 18,
          masteryProgress: 0.72,
          isPriority: true,
        ),
        DashboardDueDeckItem(
          id: 'medical',
          title: AppStrings.dashboardMedicalDeckTitle,
          folderName: AppStrings.dashboardExamPrepFolder,
          modeLabel: AppStrings.dashboardReviewModeLabel,
          dueCardCount: 14,
          masteryProgress: 0.61,
        ),
        DashboardDueDeckItem(
          id: 'travel',
          title: AppStrings.dashboardTravelDeckTitle,
          folderName: AppStrings.dashboardDailyPracticeFolder,
          modeLabel: AppStrings.dashboardSpeedModeLabel,
          dueCardCount: 10,
          masteryProgress: 0.84,
        ),
      ],
      quickActions: const [
        DashboardQuickActionItem(
          id: 'review',
          title: AppStrings.dashboardReviewActionTitle,
          subtitle: AppStrings.dashboardReviewActionSubtitle,
          primaryActionLabel: AppStrings.dashboardStartActionLabel,
          secondaryActionLabel: AppStrings.dashboardLaterActionLabel,
          focusLabel: AppStrings.dashboardReviewFocusLabel,
          icon: Icons.play_circle_fill_rounded,
        ),
        DashboardQuickActionItem(
          id: 'create',
          title: AppStrings.dashboardCreateDeckActionTitle,
          subtitle: AppStrings.dashboardCreateDeckActionSubtitle,
          primaryActionLabel: AppStrings.dashboardOpenActionLabel,
          secondaryActionLabel: AppStrings.dashboardLaterActionLabel,
          focusLabel: AppStrings.dashboardCaptureFocusLabel,
          icon: Icons.add_card_rounded,
        ),
        DashboardQuickActionItem(
          id: 'import',
          title: AppStrings.dashboardImportCardsActionTitle,
          subtitle: AppStrings.dashboardImportCardsActionSubtitle,
          primaryActionLabel: AppStrings.dashboardOpenActionLabel,
          secondaryActionLabel: AppStrings.dashboardLaterActionLabel,
          focusLabel: AppStrings.dashboardImportFocusLabel,
          icon: Icons.file_upload_outlined,
        ),
      ],
    );
  }

  final String headlineTitle;
  final String headlineSubtitle;
  final String focusLabel;
  final int reviewedToday;
  final int dailyGoal;
  final int totalStudyMinutes;
  final int currentStreak;
  final List<DashboardDueDeckItem> dueDecks;
  final List<DashboardQuickActionItem> quickActions;

  int get dueDeckCount => dueDecks.length;

  int get dueCardCount {
    return dueDecks.fold<int>(
      0,
      (total, deck) => total + deck.dueCardCount,
    );
  }

  double get dailyGoalProgress {
    if (dailyGoal == 0) {
      return 0;
    }
    return (reviewedToday / dailyGoal).clamp(0, 1).toDouble();
  }

  DashboardState copyWith({
    String? headlineTitle,
    String? headlineSubtitle,
    String? focusLabel,
    int? reviewedToday,
    int? dailyGoal,
    int? totalStudyMinutes,
    int? currentStreak,
    List<DashboardDueDeckItem>? dueDecks,
    List<DashboardQuickActionItem>? quickActions,
  }) {
    return DashboardState(
      headlineTitle: headlineTitle ?? this.headlineTitle,
      headlineSubtitle: headlineSubtitle ?? this.headlineSubtitle,
      focusLabel: focusLabel ?? this.focusLabel,
      reviewedToday: reviewedToday ?? this.reviewedToday,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      totalStudyMinutes: totalStudyMinutes ?? this.totalStudyMinutes,
      currentStreak: currentStreak ?? this.currentStreak,
      dueDecks: dueDecks ?? this.dueDecks,
      quickActions: quickActions ?? this.quickActions,
    );
  }
}

@immutable
class DashboardDueDeckItem {
  const DashboardDueDeckItem({
    required this.id,
    required this.title,
    required this.folderName,
    required this.modeLabel,
    required this.dueCardCount,
    required this.masteryProgress,
    this.isPriority = false,
  });

  final String id;
  final String title;
  final String folderName;
  final String modeLabel;
  final int dueCardCount;
  final double masteryProgress;
  final bool isPriority;

  DashboardDueDeckItem copyWith({
    String? id,
    String? title,
    String? folderName,
    String? modeLabel,
    int? dueCardCount,
    double? masteryProgress,
    bool? isPriority,
  }) {
    return DashboardDueDeckItem(
      id: id ?? this.id,
      title: title ?? this.title,
      folderName: folderName ?? this.folderName,
      modeLabel: modeLabel ?? this.modeLabel,
      dueCardCount: dueCardCount ?? this.dueCardCount,
      masteryProgress: masteryProgress ?? this.masteryProgress,
      isPriority: isPriority ?? this.isPriority,
    );
  }
}

@immutable
class DashboardQuickActionItem {
  const DashboardQuickActionItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.primaryActionLabel,
    required this.secondaryActionLabel,
    required this.focusLabel,
    required this.icon,
  });

  final String id;
  final String title;
  final String subtitle;
  final String primaryActionLabel;
  final String secondaryActionLabel;
  final String focusLabel;
  final IconData icon;

  DashboardQuickActionItem copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? primaryActionLabel,
    String? secondaryActionLabel,
    String? focusLabel,
    IconData? icon,
  }) {
    return DashboardQuickActionItem(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      primaryActionLabel: primaryActionLabel ?? this.primaryActionLabel,
      secondaryActionLabel:
          secondaryActionLabel ?? this.secondaryActionLabel,
      focusLabel: focusLabel ?? this.focusLabel,
      icon: icon ?? this.icon,
    );
  }
}
