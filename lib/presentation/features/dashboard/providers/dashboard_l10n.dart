import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/dashboard/providers/dashboard_state.dart';

extension DashboardFocusL10n on DashboardFocus {
  String label(AppLocalizations l10n) {
    switch (this) {
      case DashboardFocus.reviewSprint:
        return l10n.dashboardReviewFocusLabel;
      case DashboardFocus.captureMode:
        return l10n.dashboardCaptureFocusLabel;
      case DashboardFocus.importQueue:
        return l10n.dashboardImportFocusLabel;
      case DashboardFocus.inboxClear:
        return l10n.dashboardCompleteFocusLabel;
      case DashboardFocus.laterQueue:
        return l10n.dashboardLaterFocusLabel;
    }
  }
}

extension DashboardDeckSeedL10n on DashboardDeckSeed {
  String label(AppLocalizations l10n) {
    switch (this) {
      case DashboardDeckSeed.verbs:
        return l10n.dashboardVerbsDeckTitle;
      case DashboardDeckSeed.medical:
        return l10n.dashboardMedicalDeckTitle;
      case DashboardDeckSeed.travel:
        return l10n.dashboardTravelDeckTitle;
    }
  }
}

extension DashboardFolderSeedL10n on DashboardFolderSeed {
  String label(AppLocalizations l10n) {
    switch (this) {
      case DashboardFolderSeed.languageLab:
        return l10n.dashboardLanguageLabFolder;
      case DashboardFolderSeed.examPrep:
        return l10n.dashboardExamPrepFolder;
      case DashboardFolderSeed.dailyPractice:
        return l10n.dashboardDailyPracticeFolder;
    }
  }
}

extension DashboardStudyModeL10n on DashboardStudyMode {
  String label(AppLocalizations l10n) {
    switch (this) {
      case DashboardStudyMode.recall:
        return l10n.dashboardRecallModeLabel;
      case DashboardStudyMode.review:
        return l10n.dashboardReviewModeLabel;
      case DashboardStudyMode.speedDrill:
        return l10n.dashboardSpeedModeLabel;
    }
  }
}

extension DashboardQuickActionTypeL10n on DashboardQuickActionType {
  DashboardFocus get focus {
    switch (this) {
      case DashboardQuickActionType.review:
        return DashboardFocus.reviewSprint;
      case DashboardQuickActionType.createDeck:
        return DashboardFocus.captureMode;
      case DashboardQuickActionType.importCards:
        return DashboardFocus.importQueue;
    }
  }

  String title(AppLocalizations l10n) {
    switch (this) {
      case DashboardQuickActionType.review:
        return l10n.dashboardReviewActionTitle;
      case DashboardQuickActionType.createDeck:
        return l10n.dashboardCreateDeckActionTitle;
      case DashboardQuickActionType.importCards:
        return l10n.dashboardImportCardsActionTitle;
    }
  }

  String subtitle(AppLocalizations l10n) {
    switch (this) {
      case DashboardQuickActionType.review:
        return l10n.dashboardReviewActionSubtitle;
      case DashboardQuickActionType.createDeck:
        return l10n.dashboardCreateDeckActionSubtitle;
      case DashboardQuickActionType.importCards:
        return l10n.dashboardImportCardsActionSubtitle;
    }
  }

  String primaryActionLabel(AppLocalizations l10n) {
    switch (this) {
      case DashboardQuickActionType.review:
        return l10n.dashboardStartActionLabel;
      case DashboardQuickActionType.createDeck:
      case DashboardQuickActionType.importCards:
        return l10n.dashboardOpenActionLabel;
    }
  }

  String secondaryActionLabel(AppLocalizations l10n) {
    return l10n.dashboardLaterActionLabel;
  }
}
