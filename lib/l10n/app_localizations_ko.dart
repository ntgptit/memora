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
  String get folderLibraryTitle => 'Library folders';

  @override
  String get folderScreenSubtitle =>
      'Browse the library tree, reorganize branches, and jump into deck management when you reach a leaf folder.';

  @override
  String get folderRootBreadcrumbLabel => 'Library';

  @override
  String get folderSearchHint => 'Search folders';

  @override
  String get folderSortTitle => 'Sort folders';

  @override
  String get folderSortDirectionTooltip => 'Toggle folder sort direction';

  @override
  String get folderSortByName => 'Name';

  @override
  String get folderSortByCreatedAt => 'Created';

  @override
  String get folderSortByUpdatedAt => 'Updated';

  @override
  String get folderActionsTooltip => 'Folder actions';

  @override
  String get folderCreateAction => 'Create folder';

  @override
  String get folderRenameAction => 'Rename folder';

  @override
  String get folderEditAction => 'Edit folder';

  @override
  String get folderSaveAction => 'Save folder';

  @override
  String get folderDeleteAction => 'Delete folder';

  @override
  String get folderCancelAction => 'Cancel';

  @override
  String get folderLeafLabel => 'Leaf';

  @override
  String get folderErrorBannerTitle => 'Folder action failed';

  @override
  String get folderLoadErrorMessage =>
      'Unable to load folders right now. Try again.';

  @override
  String get folderCreateDialogTitle => 'Create a new folder';

  @override
  String get folderRenameDialogTitle => 'Rename folder';

  @override
  String get folderEditDialogTitle => 'Edit folder';

  @override
  String get folderDeleteDialogMessage =>
      'Deleting a folder also removes its child folders and every deck underneath it from the active workspace.';

  @override
  String get folderNameFieldLabel => 'Folder name';

  @override
  String get folderDescriptionFieldLabel => 'Description';

  @override
  String get folderNameRequiredMessage => 'Folder name is required.';

  @override
  String get folderRootEmptyTitle => 'Start your library structure';

  @override
  String get folderRootEmptyMessage =>
      'Create the first top-level folder to organize decks by topic, course, or project.';

  @override
  String get folderLevelEmptyTitle => 'This branch has no child folders';

  @override
  String get folderLevelEmptyMessage =>
      'Create a child folder here or return to the parent branch.';

  @override
  String folderChildCountValue(int count) {
    return '$count child folders';
  }

  @override
  String folderDeleteDialogTitle(Object folderName) {
    return 'Delete \"$folderName\"?';
  }

  @override
  String get foldersPlaceholderTitle => 'Folder hub is ready';

  @override
  String get foldersPlaceholderMessage =>
      'This root tab is wired into the shared app navigation. Folder-specific content can expand here next.';

  @override
  String get decksTitle => 'Decks';

  @override
  String get deckShellTitle => 'Decks live inside folders';

  @override
  String get deckShellSubtitle =>
      'Pick a leaf folder first, then manage the decks that belong to that branch.';

  @override
  String get deckShellMessage =>
      'Deck management now follows the folder tree, so use the folders tab to choose the branch you want to study or maintain.';

  @override
  String get deckShellBrowseFoldersAction => 'Browse folders';

  @override
  String get deckScreenSubtitle =>
      'Manage the decks stored inside the current leaf folder.';

  @override
  String get deckSearchHint => 'Search decks';

  @override
  String get deckSortTitle => 'Sort decks';

  @override
  String get deckSortDirectionTooltip => 'Toggle deck sort direction';

  @override
  String get deckSortByName => 'Name';

  @override
  String get deckSortByCreatedAt => 'Created';

  @override
  String get deckSortByUpdatedAt => 'Updated';

  @override
  String get deckActionsTooltip => 'Deck actions';

  @override
  String get deckCreateAction => 'Create deck';

  @override
  String get deckEditAction => 'Edit deck';

  @override
  String get deckSaveAction => 'Save deck';

  @override
  String get deckDeleteAction => 'Delete deck';

  @override
  String get deckCancelAction => 'Cancel';

  @override
  String get deckErrorBannerTitle => 'Deck action failed';

  @override
  String get deckLoadErrorMessage =>
      'Unable to load decks right now. Try again.';

  @override
  String get deckCreateDialogTitle => 'Create a new deck';

  @override
  String get deckEditDialogTitle => 'Edit deck';

  @override
  String get deckDeleteDialogMessage =>
      'Deleting a deck also removes its flashcards from the active workspace.';

  @override
  String get deckNameFieldLabel => 'Deck name';

  @override
  String get deckDescriptionFieldLabel => 'Description';

  @override
  String get deckNameRequiredMessage => 'Deck name is required.';

  @override
  String get deckEmptyTitle => 'No decks in this folder yet';

  @override
  String get deckEmptyMessage =>
      'Create the first deck in this branch to start adding flashcards.';

  @override
  String get deckDetailTitle => 'Deck details';

  @override
  String get deckDetailPlaceholderTitle => 'Flashcards are the next layer';

  @override
  String get deckDetailPlaceholderMessage =>
      'Flashcard workspace will be connected next.';

  @override
  String get deckBackToListAction => 'Back to deck list';

  @override
  String deckFlashcardCountValue(int count) {
    return '$count flashcards';
  }

  @override
  String deckFlashcardCountChipLabel(int count) {
    return '$count cards';
  }

  @override
  String deckSummaryDeckCount(int count) {
    return '$count decks';
  }

  @override
  String deckSummaryFlashcardCount(int count) {
    return '$count flashcards';
  }

  @override
  String deckDeleteDialogTitle(Object deckName) {
    return 'Delete \"$deckName\"?';
  }

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
  String get progressOverviewSubtitle =>
      'Track study cadence, due pressure, and the next recommended review block.';

  @override
  String get progressLoadingMessage =>
      'Loading study performance, streaks, and due recommendations.';

  @override
  String get progressErrorTitle => 'Unable to load progress';

  @override
  String get progressLoadErrorMessage =>
      'Refresh the current period or try again in a moment.';

  @override
  String get progressCalendarActionLabel => 'Study calendar';

  @override
  String get progressDeckProgressActionLabel => 'Deck progress';

  @override
  String get progressSummaryTitle => 'Study overview';

  @override
  String get progressSummarySubtitle =>
      'A quick read on review load, accuracy, and reminder pressure.';

  @override
  String get progressDueLabel => 'Due cards';

  @override
  String get progressReminderTypesLabel => 'Reminder mix';

  @override
  String get progressOverdueLabel => 'Overdue';

  @override
  String get progressLearnedLabel => 'Learned';

  @override
  String get progressBoxDistributionLabel => 'Box spread';

  @override
  String get progressAccuracyLabel => 'Accuracy';

  @override
  String get progressPassedAttemptsLabel => 'Passed attempts';

  @override
  String get progressFailedAttemptsLabel => 'Failed attempts';

  @override
  String get progressChartTitle => 'Distribution';

  @override
  String get progressChartSubtitle =>
      'See how cards are currently spread across the active review boxes.';

  @override
  String get progressFilterTitle => 'Progress period';

  @override
  String get progressRefreshTooltip => 'Refresh progress';

  @override
  String get progressPeriodTodayLabel => 'Today';

  @override
  String get progressPeriodWeekLabel => 'Week';

  @override
  String get progressPeriodMonthLabel => 'Month';

  @override
  String get progressRecommendationTitle => 'Recommended next review';

  @override
  String get progressRecommendationSubtitle =>
      'Use the heaviest due deck to decide the next useful session.';

  @override
  String get progressRecommendationEmptyMessage =>
      'No specific deck needs immediate follow-up right now.';

  @override
  String progressRecommendationMetaLabel(Object sessionType, int minutes) {
    return '$sessionType · $minutes min planned';
  }

  @override
  String get progressStudyNowActionLabel => 'Study now';

  @override
  String get progressViewDeckActionLabel => 'View deck progress';

  @override
  String progressDueCountChipLabel(int count) {
    return '$count due';
  }

  @override
  String progressOverdueCountChipLabel(int count) {
    return '$count overdue';
  }

  @override
  String get progressHistoryTitle => 'Recent activity';

  @override
  String get progressHistorySubtitle =>
      'A short log of study outcomes and scheduling changes.';

  @override
  String get progressCalendarTitle => 'Streak calendar';

  @override
  String get progressCalendarSubtitle =>
      'A compact view of recent study consistency.';

  @override
  String get progressEscalationCalmLabel => 'Calm';

  @override
  String get progressEscalationWatchLabel => 'Watch';

  @override
  String get progressEscalationUrgentLabel => 'Urgent';

  @override
  String get progressEscalationCriticalLabel => 'Critical';

  @override
  String get progressDeckScreenTitle => 'Deck progress';

  @override
  String get progressDeckScreenSubtitle =>
      'Review due pressure, accuracy, and recent activity for the selected deck.';

  @override
  String get progressDeckFocusTitle => 'Selected deck';

  @override
  String get progressDeckFocusSubtitle =>
      'A focused snapshot for the current deck under the active period filter.';

  @override
  String progressDeckIdLabel(int deckId) {
    return 'Deck #$deckId';
  }

  @override
  String progressDeckRecommendationLabel(Object sessionType, int minutes) {
    return '$sessionType · $minutes min recommended';
  }

  @override
  String get progressCalendarScreenTitle => 'Study calendar';

  @override
  String get progressCalendarScreenSubtitle =>
      'Track streak consistency and recent sessions across the active period.';

  @override
  String get progressJapaneseBasicsDeckTitle => 'Japanese basics';

  @override
  String get progressExamPrepDeckTitle => 'Exam prep';

  @override
  String get progressReminderSrsReviewLabel => 'SRS review';

  @override
  String get progressReminderOverdueCatchUpLabel => 'Overdue catch-up';

  @override
  String get progressReminderMorningReviewLabel => 'Morning review';

  @override
  String get progressReminderEveningReviewLabel => 'Evening review';

  @override
  String get progressReminderAfternoonReviewLabel => 'Afternoon review';

  @override
  String get progressSessionReviewSprintLabel => 'Review sprint';

  @override
  String get progressSessionFocusedReviewLabel => 'Focused review';

  @override
  String get progressSessionDeepReviewLabel => 'Deep review';

  @override
  String progressBoxLabel(int index) {
    return 'Box $index';
  }

  @override
  String progressHistoryCompletedAccuracy(int count, int accuracy) {
    return 'Completed $count cards with $accuracy% accuracy';
  }

  @override
  String progressHistoryMissedCards(int count) {
    return 'Missed $count cards in a review sprint';
  }

  @override
  String progressHistoryScheduledTomorrow(int count) {
    return 'Scheduled $count cards for tomorrow';
  }

  @override
  String progressHistoryFinishedWeek(int count) {
    return 'Finished $count cards this week';
  }

  @override
  String progressHistoryLeftForNextSprint(int count) {
    return 'Left $count cards for the next sprint';
  }

  @override
  String progressHistoryResetToBoxOne(int count) {
    return '$count cards scheduled back into box 1';
  }

  @override
  String progressHistoryMaintainedAccuracy(int accuracy) {
    return 'Maintained $accuracy% accuracy over the month';
  }

  @override
  String progressHistoryAccumulatedDueCards(int count) {
    return 'Accumulated $count due cards for review';
  }

  @override
  String progressHistoryStrongestGrowth(Object boxLabel) {
    return '$boxLabel has the strongest growth';
  }

  @override
  String progressTimestampTodayAt(Object time) {
    return 'Today • $time';
  }

  @override
  String progressTimestampYesterdayAt(Object time) {
    return 'Yesterday • $time';
  }

  @override
  String progressTimestampDayAt(Object day, Object time) {
    return '$day • $time';
  }

  @override
  String progressTimestampHoursAgo(int hours) {
    return '${hours}h ago';
  }

  @override
  String get progressDayMonShort => 'M';

  @override
  String get progressDayTueShort => 'T';

  @override
  String get progressDayWedShort => 'W';

  @override
  String get progressDayThuShort => 'T';

  @override
  String get progressDayFriShort => 'F';

  @override
  String get progressDaySatShort => 'S';

  @override
  String get progressDaySunShort => 'S';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsPlaceholderTitle => 'Settings center is ready';

  @override
  String get settingsPlaceholderMessage =>
      'App preferences already have a dedicated root tab, ready for theme, language, audio, and backup settings.';

  @override
  String get settingsSectionAppearanceTitle => 'Appearance';

  @override
  String get settingsSectionAppearanceSubtitle =>
      'Tune the app look and reading language.';

  @override
  String get settingsSectionAudioTitle => 'Audio and feedback';

  @override
  String get settingsSectionAudioSubtitle =>
      'Control playback, cues, and tactile feedback during study.';

  @override
  String get settingsSectionBackupTitle => 'Backup and reminders';

  @override
  String get settingsSectionBackupSubtitle =>
      'Keep study preferences recoverable and reminders discoverable.';

  @override
  String get settingsSectionAboutTitle => 'About';

  @override
  String get settingsSectionAboutSubtitle =>
      'Inspect the active app environment and client configuration.';

  @override
  String get settingsThemeTileTitle => 'Theme';

  @override
  String get settingsLanguageTileTitle => 'Language';

  @override
  String get settingsAudioTileTitle => 'Audio settings';

  @override
  String get settingsAudioTileSubtitle =>
      'Configure text-to-speech, sounds, and haptics.';

  @override
  String get settingsQuickHapticsTitle => 'Quick haptics';

  @override
  String get settingsQuickHapticsSubtitle =>
      'Keep short tactile feedback available in the main settings screen.';

  @override
  String get settingsBackupTileTitle => 'Backup and restore';

  @override
  String get settingsBackupTileSubtitle =>
      'Manage snapshots and sync readiness for the current device.';

  @override
  String get settingsReminderTileTitle => 'Reminder settings';

  @override
  String get settingsReminderTileSubtitle =>
      'Review study nudges, time slots, and reminder preview.';

  @override
  String get settingsAboutTileTitle => 'About this app';

  @override
  String get settingsAboutTileSubtitle =>
      'View runtime environment, language, theme, and API target.';

  @override
  String get themeSettingsTitle => 'Theme settings';

  @override
  String get themeSystemLabel => 'Follow system';

  @override
  String get themeSystemSubtitle =>
      'Match the current platform brightness automatically.';

  @override
  String get themeLightLabel => 'Light';

  @override
  String get themeLightSubtitle => 'Keep the interface bright across the app.';

  @override
  String get themeDarkLabel => 'Dark';

  @override
  String get themeDarkSubtitle =>
      'Use a darker surface palette for lower-light study.';

  @override
  String get languageSettingsTitle => 'Language settings';

  @override
  String get audioSettingsTitle => 'Audio settings';

  @override
  String get audioSettingsSectionTitle => 'Study audio controls';

  @override
  String get audioSettingsSectionSubtitle =>
      'Choose which supporting sounds stay active during study sessions.';

  @override
  String get audioTtsTitle => 'Text to speech';

  @override
  String get audioTtsSubtitle =>
      'Allow pronunciation playback for supported flashcards.';

  @override
  String get audioReviewSoundsTitle => 'Review sounds';

  @override
  String get audioReviewSoundsSubtitle =>
      'Play short success and error cues during study.';

  @override
  String get audioHapticsTitle => 'Haptic feedback';

  @override
  String get audioHapticsSubtitle =>
      'Use short vibrations to reinforce actions and results.';

  @override
  String get backupRestoreTitle => 'Backup and restore';

  @override
  String get backupRestoreSectionTitle => 'Backup preferences';

  @override
  String get backupRestoreSectionSubtitle =>
      'Control whether this device should keep sync-ready backup behavior enabled.';

  @override
  String get backupCloudBackupTitle => 'Cloud backup readiness';

  @override
  String get backupCloudBackupSubtitle =>
      'Keep backup-related preferences enabled for future sync support.';

  @override
  String get backupSnapshotSectionTitle => 'Local snapshot';

  @override
  String get backupNoSnapshotLabel =>
      'No backup snapshot has been created on this device yet.';

  @override
  String backupLastBackupLabel(Object timestamp) {
    return 'Last backup snapshot: $timestamp';
  }

  @override
  String get backupCreateAction => 'Create snapshot';

  @override
  String get backupClearAction => 'Clear snapshot';

  @override
  String get aboutTitle => 'About';

  @override
  String get aboutApplicationSectionTitle => 'Application details';

  @override
  String get aboutApplicationSectionSubtitle =>
      'This information reflects the active runtime configuration.';

  @override
  String get aboutAppNameLabel => 'App name';

  @override
  String get aboutEnvironmentLabel => 'Environment';

  @override
  String get aboutCurrentThemeLabel => 'Current theme';

  @override
  String get aboutCurrentLanguageLabel => 'Current language';

  @override
  String get aboutBaseUrlLabel => 'API base URL';

  @override
  String get createLabel => 'Create';

  @override
  String get saveLabel => 'Save';

  @override
  String get cancelLabel => 'Cancel';

  @override
  String get deleteLabel => 'Delete';

  @override
  String get editLabel => 'Edit';

  @override
  String get openFoldersLabel => 'Open folders';

  @override
  String get manageDecksLabel => 'Manage decks';

  @override
  String get createFolderLabel => 'Create folder';

  @override
  String get editFolderLabel => 'Edit folder';

  @override
  String get deleteFolderLabel => 'Delete folder';

  @override
  String get createDeckLabel => 'Create deck';

  @override
  String get editDeckLabel => 'Edit deck';

  @override
  String get deleteDeckLabel => 'Delete deck';

  @override
  String get folderNameLabel => 'Folder name';

  @override
  String get folderDescriptionLabel => 'Folder description';

  @override
  String get deckNameLabel => 'Deck name';

  @override
  String get deckDescriptionLabel => 'Deck description';

  @override
  String get sortByNameLabel => 'Name';

  @override
  String get sortByCreatedAtLabel => 'Created';

  @override
  String get sortByUpdatedAtLabel => 'Updated';

  @override
  String get ascendingLabel => 'Ascending';

  @override
  String get descendingLabel => 'Descending';

  @override
  String get foldersEmptyTitle => 'No folders yet';

  @override
  String get foldersEmptyMessage =>
      'Create the first folder in this branch to organize your study library.';

  @override
  String get folderLeafHint => 'This folder has no child folders.';

  @override
  String get folderBranchHint => 'This folder still has child folders.';

  @override
  String get decksShellTitle => 'Deck workspace';

  @override
  String get decksShellMessage =>
      'Open a leaf folder to manage the decks inside it.';

  @override
  String get decksEmptyTitle => 'No decks yet';

  @override
  String get decksEmptyMessage =>
      'Create the first deck in this folder to start studying.';

  @override
  String get deckSummaryTitle => 'Deck summary';

  @override
  String get flashcardsTitle => 'Flashcards';

  @override
  String get flashcardScreenSubtitle =>
      'Search, preview, and maintain the flashcards in the current deck.';

  @override
  String get flashcardSearchHint => 'Search flashcards';

  @override
  String get flashcardSortTitle => 'Sort flashcards';

  @override
  String get flashcardSortDirectionTooltip => 'Toggle flashcard sort direction';

  @override
  String get flashcardSortByCreatedAt => 'Created';

  @override
  String get flashcardSortByUpdatedAt => 'Updated';

  @override
  String get flashcardSortByFrontText => 'Front text';

  @override
  String get flashcardErrorBannerTitle => 'Flashcard action failed';

  @override
  String get flashcardCreateAction => 'Create flashcard';

  @override
  String get flashcardEditAction => 'Edit flashcard';

  @override
  String get flashcardSaveAction => 'Save flashcard';

  @override
  String get flashcardDeleteAction => 'Delete flashcard';

  @override
  String get flashcardCancelAction => 'Cancel';

  @override
  String get flashcardEmptyTitle => 'No flashcards in this deck yet';

  @override
  String get flashcardEmptyMessage =>
      'Create the first flashcard in this deck to start building study content.';

  @override
  String get flashcardFrontFieldLabel => 'Front text';

  @override
  String get flashcardBackFieldLabel => 'Back text';

  @override
  String get flashcardFrontLangFieldLabel => 'Front language code';

  @override
  String get flashcardBackLangFieldLabel => 'Back language code';

  @override
  String get flashcardFrontRequiredMessage => 'Front text is required.';

  @override
  String get flashcardBackRequiredMessage => 'Back text is required.';

  @override
  String flashcardDeleteDialogTitle(Object flashcardText) {
    return 'Delete \"$flashcardText\"?';
  }

  @override
  String get flashcardDeleteDialogMessage =>
      'Deleting a flashcard removes it from the active deck.';

  @override
  String flashcardPreviewCountLabel(int count) {
    return '$count preview cards';
  }

  @override
  String get flashcardBrowseModeLabel => 'Browse mode';

  @override
  String get flashcardSearchModeLabel => 'Search mode';

  @override
  String get flashcardPinnedLabel => 'Pinned';

  @override
  String get flashcardPreviewEmptyTitle => 'Flashcard preview is ready';

  @override
  String get flashcardPreviewEmptyMessage =>
      'Add flashcards to the deck to see preview cards here.';

  @override
  String get flashcardImportPlaceholderTitle => 'Flashcard import is ready';

  @override
  String get flashcardImportPlaceholderMessage =>
      'Bulk import can be connected here later without changing the deck workspace.';

  @override
  String flashcardImportCreatedLabel(int count) {
    return '$count created';
  }

  @override
  String flashcardImportFailedLabel(int count) {
    return '$count failed';
  }

  @override
  String get flashcardActionsTooltip => 'Flashcard actions';

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

  @override
  String get authLoginTitle => 'Welcome back';

  @override
  String get authRegisterTitle => 'Create your account';

  @override
  String get authLoginSubtitle =>
      'Sign in to continue organizing decks, tracking streaks, and reviewing what is due next.';

  @override
  String get authRegisterSubtitle =>
      'Create a study account so your folders, decks, and progress can stay in sync.';

  @override
  String get authModeLoginLabel => 'Login';

  @override
  String get authModeRegisterLabel => 'Register';

  @override
  String get authIdentifierLabel => 'Email or username';

  @override
  String get authIdentifierHint => 'you@example.com';

  @override
  String get authIdentifierRequiredError => 'Enter your email or username.';

  @override
  String get authUsernameLabel => 'Username';

  @override
  String get authUsernameHint => 'study_builder';

  @override
  String get authUsernameRequiredError =>
      'Enter a username with at least 3 characters.';

  @override
  String get authEmailLabel => 'Email';

  @override
  String get authEmailHint => 'learner@example.com';

  @override
  String get authEmailInvalidError => 'Enter a valid email address.';

  @override
  String get authPasswordLabel => 'Password';

  @override
  String get authPasswordHint => 'Use at least 8 characters';

  @override
  String get authPasswordInvalidError =>
      'Password must be at least 8 characters.';

  @override
  String get authForgotPasswordAction => 'Forgot password?';

  @override
  String get authSuccessBannerTitle => 'All set';

  @override
  String get authWarningBannerTitle => 'Check this first';

  @override
  String get authErrorBannerTitle => 'Authentication failed';

  @override
  String get authInfoBannerTitle => 'Heads up';

  @override
  String get authSocialSectionTitle => 'Or continue with';

  @override
  String get authContinueWithGoogle => 'Continue with Google';

  @override
  String get authContinueWithApple => 'Continue with Apple';

  @override
  String get authContinueWithKakao => 'Continue with Kakao';

  @override
  String get authBootstrapLoadingTitle => 'Checking your saved session';

  @override
  String get authBootstrapLoadingSubtitle =>
      'We are deciding whether to send you straight into the app or back to authentication.';

  @override
  String get authLoginSuccessMessage =>
      'You are signed in and ready to continue learning.';

  @override
  String get authRegisterSuccessMessage =>
      'Your account is ready and your first learning workspace is unlocked.';

  @override
  String get authSignOutSuccessMessage =>
      'Your current session has been cleared from this device.';

  @override
  String get authPasswordResetSuccessMessage =>
      'Password reset instructions have been sent to your email.';

  @override
  String get authInvalidCredentialsMessage =>
      'Your login details do not look right yet. Check the identifier and password.';

  @override
  String get authDuplicateAccountMessage =>
      'That username or email is already being used.';

  @override
  String get authInvalidResetRequestMessage =>
      'Enter a valid email before requesting a reset link.';

  @override
  String get authNetworkFailureMessage =>
      'We could not reach the server. Try again when the network is stable.';

  @override
  String get authSessionReadyTitle => 'Session is active';

  @override
  String authSessionReadyMessage(Object userLabel) {
    return 'You are currently signed in as $userLabel. Continue into the app or sign out to switch accounts.';
  }

  @override
  String get authContinueToAppAction => 'Stay signed in';

  @override
  String get authSignOutAction => 'Sign out';

  @override
  String get authForgotPasswordTitle => 'Reset your password';

  @override
  String get authForgotPasswordSubtitle =>
      'Enter your account email and we will prepare a reset instruction message.';

  @override
  String get authBackToLoginAction => 'Back to login';

  @override
  String get authSendResetAction => 'Send reset instructions';

  @override
  String get reminderTitle => 'Study reminders';

  @override
  String get reminderSubtitle =>
      'Shape when Memora nudges you back into the next useful review block.';

  @override
  String get reminderOverviewSectionTitle => 'Reminder health';

  @override
  String get reminderOverviewSectionSubtitle =>
      'Keep track of how much study debt is building and whether reminder cues are active.';

  @override
  String get reminderToggleTitle => 'Enable reminders';

  @override
  String get reminderToggleSubtitle =>
      'Turn learning reminders on when you want Memora to keep your study rhythm visible.';

  @override
  String reminderDueCountLabel(int count) {
    return '$count due now';
  }

  @override
  String reminderOverdueCountLabel(int count) {
    return '$count overdue';
  }

  @override
  String reminderActiveSlotsLabel(int count) {
    return '$count active slots';
  }

  @override
  String get reminderFrequencySectionTitle => 'Reminder cadence';

  @override
  String get reminderFrequencySectionSubtitle =>
      'Choose whether reminders should follow every day, only weekdays, or a custom pattern.';

  @override
  String get reminderFrequencyDailyLabel => 'Daily';

  @override
  String get reminderFrequencyWeekdaysLabel => 'Weekdays';

  @override
  String get reminderFrequencyCustomLabel => 'Custom';

  @override
  String get reminderSuggestedDeckSectionTitle => 'Suggested next deck';

  @override
  String get reminderSuggestedDeckSectionSubtitle =>
      'Use the reminder signal to jump directly into the branch that needs attention first.';

  @override
  String reminderSuggestedDeckMessage(Object dueCount, Object overdueCount) {
    return '$dueCount cards are due and $overdueCount are already overdue in the suggested deck.';
  }

  @override
  String get reminderPreviewAction => 'Preview reminder';

  @override
  String get reminderManageSlotsAction => 'Manage time slots';

  @override
  String get reminderTimeSlotsTitle => 'Reminder time slots';

  @override
  String get reminderTimeSlotsSubtitle =>
      'Adjust when reminder nudges can appear during the day.';

  @override
  String get reminderAddSlotAction => 'Add slot';

  @override
  String get reminderCustomDaysSectionTitle => 'Custom reminder days';

  @override
  String get reminderCustomDaysSectionSubtitle =>
      'Pick the specific days when reminders should stay active.';

  @override
  String get reminderWeekdayMonday => 'Mon';

  @override
  String get reminderWeekdayTuesday => 'Tue';

  @override
  String get reminderWeekdayWednesday => 'Wed';

  @override
  String get reminderWeekdayThursday => 'Thu';

  @override
  String get reminderWeekdayFriday => 'Fri';

  @override
  String get reminderWeekdaySaturday => 'Sat';

  @override
  String get reminderWeekdaySunday => 'Sun';

  @override
  String get reminderSlotMorningReviewLabel => 'Morning review';

  @override
  String get reminderSlotEveningResetLabel => 'Evening reset';

  @override
  String get reminderSlotStudyBlockLabel => 'Study block';

  @override
  String get reminderSlotEnabledLabel => 'Active';

  @override
  String get reminderSlotPausedLabel => 'Paused';

  @override
  String get reminderPreviewTitle => 'Reminder preview';

  @override
  String get reminderPreviewSubtitle =>
      'See how the next notification cue would look before you save it into habit.';

  @override
  String get reminderPreviewSummaryTitle => 'Next reminder snapshot';

  @override
  String get reminderPreviewSummarySubtitle =>
      'This preview combines your current cadence, active time slots, and suggested study deck.';

  @override
  String reminderPreviewScheduleMessage(Object timeLabel) {
    return 'The next reminder is scheduled for $timeLabel.';
  }

  @override
  String reminderPreviewCardTitle(Object deckName) {
    return 'Review $deckName next';
  }

  @override
  String reminderPreviewCardMessage(Object dueCount, Object overdueCount) {
    return '$dueCount cards are ready and $overdueCount need urgent attention.';
  }

  @override
  String get reminderOpenSuggestedDeckAction => 'Open suggested deck';

  @override
  String get reminderBackToSettingsAction => 'Back to settings';

  @override
  String get onboardingTitle => 'Get started';

  @override
  String get onboardingPageOrganizeTitle => 'Organize knowledge clearly';

  @override
  String get onboardingPageOrganizeDescription =>
      'Build a folder tree that matches the way you think about topics, courses, or daily practice.';

  @override
  String get onboardingPageOrganizeHighlight =>
      'Start small, then grow your library one clear branch at a time.';

  @override
  String get onboardingPageReviewTitle => 'Review with intent';

  @override
  String get onboardingPageReviewDescription =>
      'Move from folders to decks to flashcards without losing context or momentum.';

  @override
  String get onboardingPageReviewHighlight =>
      'Keep the next useful review block visible so it is easier to begin.';

  @override
  String get onboardingPageMomentumTitle => 'Protect your study rhythm';

  @override
  String get onboardingPageMomentumDescription =>
      'Use reminders, streaks, and daily targets to stay consistent without overloading a single session.';

  @override
  String get onboardingPageMomentumHighlight =>
      'Short, repeatable sessions compound faster than big bursts.';

  @override
  String get onboardingPermissionsAction => 'Set permissions';

  @override
  String get onboardingSkipAction => 'Skip for now';

  @override
  String get onboardingContinueAction => 'Continue';

  @override
  String get onboardingNextAction => 'Next';

  @override
  String get onboardingPermissionsTitle => 'Choose your helpful nudges';

  @override
  String get onboardingPermissionsSubtitle =>
      'Decide which app signals should be ready when you start building a routine.';

  @override
  String get onboardingPermissionNotificationsTitle => 'Study reminders';

  @override
  String get onboardingPermissionNotificationsDescription =>
      'Allow reminder prompts so due decks do not disappear behind a busy day.';

  @override
  String get onboardingPermissionNotificationsNote =>
      'You can fine-tune the exact cadence later from reminder settings.';

  @override
  String get onboardingPermissionAudioTitle => 'Audio prompts';

  @override
  String get onboardingPermissionAudioDescription =>
      'Keep pronunciation and listening cues ready when you begin study modes that use sound.';

  @override
  String get onboardingPermissionAudioNote =>
      'This simply prepares the preference; you can still change it whenever you want.';

  @override
  String get onboardingBackAction => 'Back';

  @override
  String get onboardingGoalSetupAction => 'Set study goal';

  @override
  String get onboardingGoalSetupTitle => 'Define your first study target';

  @override
  String get onboardingGoalSetupSubtitle =>
      'Pick a goal profile, then adjust the card target and session length that feel sustainable.';

  @override
  String onboardingGoalSetupCompletedMessage(
    Object dailyGoal,
    Object sessionMinutes,
  ) {
    return 'You are set for $dailyGoal cards per day across $sessionMinutes-minute sessions.';
  }

  @override
  String get onboardingGoalPresetSectionTitle => 'Goal profile';

  @override
  String get onboardingGoalPresetSectionSubtitle =>
      'Choose the pace that best matches your current routine.';

  @override
  String get onboardingGoalNumbersSectionTitle => 'Goal details';

  @override
  String get onboardingGoalNumbersSectionSubtitle =>
      'Adjust the daily study volume and ideal session length.';

  @override
  String get onboardingDailyGoalFieldLabel => 'Daily card goal';

  @override
  String get onboardingSessionLengthFieldLabel => 'Session length (minutes)';

  @override
  String get onboardingFinishAction => 'Finish setup';

  @override
  String get onboardingGoalSteadyLabel => 'Steady';

  @override
  String get onboardingGoalFocusedLabel => 'Focused';

  @override
  String get onboardingGoalIntensiveLabel => 'Intensive';

  @override
  String get studySessionTypeFirstLearning => 'First learning';

  @override
  String get studySessionTypeReview => 'Review';

  @override
  String get studySessionTypeFirstLearningSubtitle =>
      'Move through the full progression with more guided support and repetition.';

  @override
  String get studySessionTypeReviewSubtitle =>
      'Focus on due cards and keep the session fast, lean, and corrective.';

  @override
  String get studyModeReview => 'Review';

  @override
  String get studyModeRecall => 'Recall';

  @override
  String get studyModeGuess => 'Guess';

  @override
  String get studyModeMatch => 'Match';

  @override
  String get studyModeFill => 'Fill';

  @override
  String get studyModeReviewDescription =>
      'Skim quickly, make a confidence call, and keep the review queue moving.';

  @override
  String get studyModeRecallDescription =>
      'Pause first, reveal second, then decide whether the answer was really there.';

  @override
  String get studyModeGuessDescription =>
      'Pick from several close options to test recognition under light pressure.';

  @override
  String get studyModeMatchDescription =>
      'Line up both sides of a concept set before confirming the whole board.';

  @override
  String get studyModeFillDescription =>
      'Type the answer yourself so accuracy depends on recall instead of recognition.';

  @override
  String get studyLifecycleReady => 'Ready';

  @override
  String get studyLifecycleInProgress => 'In progress';

  @override
  String get studyLifecycleFeedback => 'Feedback ready';

  @override
  String get studyLifecycleRetryPending => 'Retry pending';

  @override
  String get studyLifecycleCompleted => 'Completed';

  @override
  String get studyHistoryCompleted => 'Completed';

  @override
  String get studyHistoryResumed => 'Resumed';

  @override
  String get studyHistoryInterrupted => 'Interrupted';

  @override
  String get studyAudioTitle => 'Audio support';

  @override
  String studyAudioSubtitle(Object voiceLabel) {
    return 'Pronunciation support is ready with $voiceLabel.';
  }

  @override
  String get studyAudioFallbackVoice => 'the default voice';

  @override
  String get studyAudioUnavailableMessage =>
      'This item does not include speech support, so the session stays visual.';

  @override
  String get studyAudioMuteAction => 'Mute audio';

  @override
  String get studyAudioEnableAction => 'Enable audio';

  @override
  String get studyAudioUnavailableAction => 'No audio';

  @override
  String get studyExitDialogTitle => 'Leave this study session?';

  @override
  String get studyExitConfirmAction => 'Leave session';

  @override
  String get studyExitCancelAction => 'Stay here';

  @override
  String get studyExitDialogMessage =>
      'You can resume this session later, but any unsaved momentum in the current step may feel more abrupt when you return.';

  @override
  String get studyFooterTitle => 'Session controls';

  @override
  String studyFooterSubtitle(Object modeLabel, Object lifecycleLabel) {
    return '$modeLabel is active and the session is currently $lifecycleLabel.';
  }

  @override
  String get studyResetModeAction => 'Reset current mode';

  @override
  String get studyExitAction => 'Exit study';

  @override
  String studyHeaderSubtitle(Object folderLabel, Object sessionType) {
    return '$folderLabel · $sessionType';
  }

  @override
  String studyDueCountLabel(int count) {
    return '$count due cards';
  }

  @override
  String get studyDueCountTitle => 'Due now';

  @override
  String get studyModeSequenceTitle => 'Mode sequence';

  @override
  String get studyModeSequenceSubtitle =>
      'Keep the whole study arc visible while you decide how to start.';

  @override
  String studyModeProgressLabel(int completed, int total) {
    return '$completed of $total';
  }

  @override
  String get studyProgressTitle => 'Session progress';

  @override
  String studyProgressSubtitle(
    Object modeLabel,
    int completedModes,
    int totalModes,
  ) {
    return '$modeLabel · $completedModes of $totalModes modes cleared';
  }

  @override
  String studyItemProgressLabel(int completed, int total) {
    return '$completed of $total items';
  }

  @override
  String get studyResultCompletionTitle => 'Completion';

  @override
  String get studyResultCompletionSubtitle =>
      'A quick read on how much of the session made it through the full cycle.';

  @override
  String get studyResultMasteredLabel => 'Mastered items';

  @override
  String get studyResultMasteredSubtitle =>
      'Items you moved forward without another retry pass.';

  @override
  String get studyResultRetryLabel => 'Retry items';

  @override
  String get studyResultRetrySubtitle =>
      'Items that still need another look in the next block.';

  @override
  String get studyResultFocusLabel => 'Focus time';

  @override
  String get studyResultFocusSubtitle =>
      'Total time budget reserved for this session shell.';

  @override
  String studyMinutesShortLabel(int minutes) {
    return '$minutes min';
  }

  @override
  String get studyModePickerTitle => 'Mode picker';

  @override
  String get studyModePickerSubtitle =>
      'Preview the mode chain before you jump into the live session.';

  @override
  String get studyModePickerSelectedAction => 'Selected';

  @override
  String get studyModePickerChooseAction => 'Focus here';

  @override
  String get studySetupTitle => 'Study setup';

  @override
  String get studySetupSubtitle =>
      'Prime the next session, decide whether to resume, and check how the mode chain will unfold.';

  @override
  String get studyDeckReadinessTitle => 'Deck readiness';

  @override
  String get studyDeckReadinessSubtitle =>
      'Current mastery gives a quick signal for how demanding this session should feel.';

  @override
  String get studySetupEstimateTitle => 'Estimated time';

  @override
  String get studySetupEstimateSubtitle =>
      'A short, sustainable block for the current due queue.';

  @override
  String get studySessionTypeSelectedAction => 'Selected';

  @override
  String get studySessionTypeChooseAction => 'Use this flow';

  @override
  String get studyResumeTitle => 'Resume where you stopped';

  @override
  String studyResumeSubtitle(Object modeLabel, int completed, int total) {
    return '$modeLabel was active with $completed of $total items already processed.';
  }

  @override
  String get studyResumeAction => 'Resume session';

  @override
  String get studyStartFreshAction => 'Start fresh';

  @override
  String get studyHistoryPreviewTitle => 'Recent study blocks';

  @override
  String get studyHistoryPreviewSubtitle =>
      'Use the recent trail to decide whether you need repetition or a fresh pass.';

  @override
  String studyHistoryEntrySubtitle(Object modeLabel, int mastered, int total) {
    return '$modeLabel · $mastered of $total held';
  }

  @override
  String get studyStartAction => 'Prepare session';

  @override
  String get studyHistoryTitle => 'Study history';

  @override
  String get studyHistorySubtitle =>
      'Look back at recent sessions to spot where momentum is stable and where drift starts.';

  @override
  String studyHistoryEntryDescription(
    Object statusLabel,
    Object modeLabel,
    Object dateLabel,
  ) {
    return '$statusLabel · $modeLabel · $dateLabel';
  }

  @override
  String get studyResultTitle => 'Study result';

  @override
  String get studyResultSubtitle =>
      'Close the session with a compact summary before you decide what to do next.';

  @override
  String get studyResultNextBlockTitle => 'Next useful move';

  @override
  String studyResultNextBlockSubtitle(Object modeLabel) {
    return 'The session shell is ready to loop back into $modeLabel if you want another pass.';
  }

  @override
  String get studyRestartSessionAction => 'Restart session';

  @override
  String get studyReturnToDeckAction => 'Return to deck';

  @override
  String get studySessionCompletedSubtitle =>
      'The current session has reached the result stage.';

  @override
  String get studySessionCompletedTitle => 'Session completed';

  @override
  String get studySessionCompletedMessage =>
      'Open the result summary or leave the study flow from here.';

  @override
  String get studyOpenResultAction => 'Open result';

  @override
  String get studyRememberedAction => 'Remembered';

  @override
  String get studyRetryItemAction => 'Study again';

  @override
  String get studyNextAction => 'Next item';

  @override
  String get studyCheckAnswerAction => 'Check answer';

  @override
  String get studyMatchConfirmAction => 'Confirm pairs';

  @override
  String get studyMatchLeftColumnTitle => 'Prompt side';

  @override
  String get studyMatchRightColumnTitle => 'Meaning side';

  @override
  String get studyMatchPairsTitle => 'Current pairs';

  @override
  String get studyMatchPairsSubtitle =>
      'Remove any pair if you want to rebuild it before submitting.';

  @override
  String get studyRevealAnswerAction => 'Reveal answer';

  @override
  String studyRetryCountLabel(int count) {
    return '$count retry';
  }

  @override
  String get studyRecallAnswerTitle => 'Answer revealed';

  @override
  String get studyRecallAnswerHiddenTitle => 'Answer stays hidden';

  @override
  String get studyRecallAnswerHiddenSubtitle =>
      'Try to recall it first, then reveal only when you are ready.';

  @override
  String get studyFillInputTitle => 'Type your answer';

  @override
  String get studyFillInputSubtitle =>
      'Use the field below to prove the answer from memory.';

  @override
  String studyFillAnswerReveal(Object answer) {
    return 'Expected answer: $answer';
  }

  @override
  String get studyResetModeDialogTitle => 'Reset this mode?';

  @override
  String get studyResetModeDialogMessage =>
      'This clears the current mode progress and sends you back to its first item.';
}
