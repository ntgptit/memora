// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appName => 'Memora';

  @override
  String get splashTitle => 'Preparing your learning workspace';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get navigationDashboardLabel => 'Dashboard';

  @override
  String get navigationFoldersLabel => 'Folders';

  @override
  String get navigationDecksLabel => 'Decks';

  @override
  String get navigationProgressLabel => 'Progress';

  @override
  String get navigationSettingsLabel => 'Settings';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardHeadlineSubtitle =>
      'Stay on pace with today\'s study plan and clear the next useful review block.';

  @override
  String get dashboardSummaryTitle => 'Today\'s overview';

  @override
  String get dashboardSummarySubtitle =>
      'A quick read on workload, cadence, and study momentum.';

  @override
  String get dashboardSummaryDueDecksLabel => 'Due decks';

  @override
  String get dashboardSummaryDueCardsLabel => 'Cards today';

  @override
  String get dashboardSummaryReviewedLabel => 'Reviewed';

  @override
  String get dashboardSummaryFocusTimeLabel => 'Focus time';

  @override
  String get dashboardStreakTitle => 'Study streak';

  @override
  String get dashboardStreakSubtitle =>
      'Consistency compounds when you keep short sessions moving.';

  @override
  String get dashboardDailyGoalLabel => 'Daily goal';

  @override
  String get dashboardQuickActionsTitle => 'Quick actions';

  @override
  String get dashboardQuickActionsSubtitle =>
      'Jump straight into the next useful move.';

  @override
  String get dashboardDueDecksTitle => 'Due decks';

  @override
  String get dashboardDueDecksSubtitle =>
      'Start with the decks carrying the heaviest review debt.';

  @override
  String get dashboardRefreshTooltip => 'Refresh dashboard';

  @override
  String get dashboardStartActionLabel => 'Start';

  @override
  String get dashboardOpenActionLabel => 'Open';

  @override
  String get dashboardLaterActionLabel => 'Later';

  @override
  String get dashboardReviewActionTitle => 'Start review';

  @override
  String get dashboardReviewActionSubtitle =>
      'Focus on the decks with the highest due volume first.';

  @override
  String get dashboardCreateDeckActionTitle => 'Create deck';

  @override
  String get dashboardCreateDeckActionSubtitle =>
      'Capture a new topic while the idea is still fresh.';

  @override
  String get dashboardImportCardsActionTitle => 'Import cards';

  @override
  String get dashboardImportCardsActionSubtitle =>
      'Bring in prepared content and queue it for practice.';

  @override
  String get dashboardReviewFocusLabel => 'Review sprint';

  @override
  String get dashboardCaptureFocusLabel => 'Capture mode';

  @override
  String get dashboardImportFocusLabel => 'Import queue';

  @override
  String get dashboardCompleteFocusLabel => 'Inbox clear';

  @override
  String get dashboardLaterFocusLabel => 'Later queue';

  @override
  String get dashboardNoDueDecksSubtitle =>
      'You have cleared every due deck in the current queue.';

  @override
  String get dashboardQuickActionsEmptyTitle => 'No quick actions right now';

  @override
  String get dashboardQuickActionsEmptySubtitle =>
      'The current queue is stable, so you can stay with the active study flow.';

  @override
  String get dashboardTravelDeckTitle => 'Travel phrases';

  @override
  String get dashboardMedicalDeckTitle => 'Medical terminology';

  @override
  String get dashboardVerbsDeckTitle => 'Korean verbs';

  @override
  String get dashboardLanguageLabFolder => 'Language Lab';

  @override
  String get dashboardExamPrepFolder => 'Exam Prep';

  @override
  String get dashboardDailyPracticeFolder => 'Daily Practice';

  @override
  String get dashboardRecallModeLabel => 'Recall';

  @override
  String get dashboardReviewModeLabel => 'Review';

  @override
  String get dashboardSpeedModeLabel => 'Speed drill';

  @override
  String get foldersTitle => 'Folders';

  @override
  String get foldersPlaceholderTitle => 'Folder hub is ready';

  @override
  String get foldersPlaceholderMessage =>
      'This root tab is wired into the shared app navigation. Folder-specific content can expand here next.';

  @override
  String get decksTitle => 'Decks';

  @override
  String get decksPlaceholderTitle => 'Deck library is ready';

  @override
  String get decksPlaceholderMessage =>
      'This tab is now part of the common shell, so deck listing and filtering can grow without changing app navigation.';

  @override
  String get progressTitle => 'Progress';

  @override
  String get progressPlaceholderTitle => 'Progress workspace is ready';

  @override
  String get progressPlaceholderMessage =>
      'Charts, streaks, and history can plug into this shared navigation slot when the feature slice is implemented.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsPlaceholderTitle => 'Settings center is ready';

  @override
  String get settingsPlaceholderMessage =>
      'App preferences already have a dedicated root tab, ready for theme, language, audio, and backup settings.';

  @override
  String get offlineTitle => 'You are offline';

  @override
  String get offlineMessage => 'Check your internet connection and try again.';

  @override
  String get offlineRetryLabel => 'Retry';

  @override
  String get maintenanceTitle => 'Maintenance';

  @override
  String get maintenanceMessage => 'The system is temporarily unavailable.';

  @override
  String get notFoundTitle => 'Page not found';

  @override
  String get notFoundMessage => 'The requested page does not exist.';

  @override
  String get clearSelectionTooltip => 'Clear selection';

  @override
  String get filterTooltip => 'Filter';

  @override
  String get sortTooltip => 'Sort';

  @override
  String get noResultsTitle => 'No results found';

  @override
  String get noResultsMessage => 'Try adjusting your filters or search terms.';

  @override
  String get accessRequiredTitle => 'Access required';

  @override
  String get signInMessage => 'Sign in to continue.';

  @override
  String get signInLabel => 'Sign in';

  @override
  String get clearDateTooltip => 'Clear date';

  @override
  String get clearTimeTooltip => 'Clear time';

  @override
  String get clearSearchTooltip => 'Clear search';

  @override
  String get selectDateLabel => 'Select date';

  @override
  String get selectTimeLabel => 'Select time';

  @override
  String get searchLabel => 'Search';

  @override
  String get requiredFieldMark => ' *';

  @override
  String selectionCountLabel(int count) {
    return '$count selected';
  }

  @override
  String dashboardFocusChipLabel(Object focusLabel) {
    return 'Focus: $focusLabel';
  }

  @override
  String dashboardDueDeckChipLabel(Object dueDeckCount) {
    return '$dueDeckCount decks due';
  }

  @override
  String dashboardDueCardChipLabel(Object dueCardCount) {
    return '$dueCardCount cards today';
  }

  @override
  String dashboardDueDeckValue(Object dueDeckCount) {
    return '$dueDeckCount decks';
  }

  @override
  String dashboardDueCardValue(Object dueCardCount) {
    return '$dueCardCount cards';
  }

  @override
  String dashboardReviewedValue(Object reviewedCount) {
    return '$reviewedCount cards';
  }

  @override
  String dashboardStudyMinutesValue(Object minutes) {
    return '$minutes min';
  }

  @override
  String dashboardStreakValue(Object days) {
    return '$days days';
  }

  @override
  String dashboardGoalProgressMessage(Object reviewed, Object goal) {
    return '$reviewed / $goal cards reviewed today';
  }

  @override
  String dashboardGoalRemainingMessage(Object remaining) {
    return '$remaining cards left to hit today\'s goal';
  }

  @override
  String dashboardDeckStatusMessage(
    Object folderName,
    Object modeLabel,
    Object mastery,
  ) {
    return '$folderName • $modeLabel • $mastery% mastered';
  }

  @override
  String dashboardDueCountLabel(Object dueCount) {
    return '$dueCount due';
  }
}
