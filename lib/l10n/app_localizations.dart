import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
    Locale('vi'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Memora'**
  String get appName;

  /// No description provided for @splashTitle.
  ///
  /// In en, this message translates to:
  /// **'Preparing your learning workspace'**
  String get splashTitle;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @navigationDashboardLabel.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navigationDashboardLabel;

  /// No description provided for @navigationFoldersLabel.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get navigationFoldersLabel;

  /// No description provided for @navigationDecksLabel.
  ///
  /// In en, this message translates to:
  /// **'Decks'**
  String get navigationDecksLabel;

  /// No description provided for @navigationProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get navigationProgressLabel;

  /// No description provided for @navigationSettingsLabel.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navigationSettingsLabel;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardHeadlineSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Stay on pace with today\'s study plan and clear the next useful review block.'**
  String get dashboardHeadlineSubtitle;

  /// No description provided for @dashboardSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s overview'**
  String get dashboardSummaryTitle;

  /// No description provided for @dashboardSummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'A quick read on workload, cadence, and study momentum.'**
  String get dashboardSummarySubtitle;

  /// No description provided for @dashboardSummaryDueDecksLabel.
  ///
  /// In en, this message translates to:
  /// **'Due decks'**
  String get dashboardSummaryDueDecksLabel;

  /// No description provided for @dashboardSummaryDueCardsLabel.
  ///
  /// In en, this message translates to:
  /// **'Cards today'**
  String get dashboardSummaryDueCardsLabel;

  /// No description provided for @dashboardSummaryReviewedLabel.
  ///
  /// In en, this message translates to:
  /// **'Reviewed'**
  String get dashboardSummaryReviewedLabel;

  /// No description provided for @dashboardSummaryFocusTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Focus time'**
  String get dashboardSummaryFocusTimeLabel;

  /// No description provided for @dashboardStreakTitle.
  ///
  /// In en, this message translates to:
  /// **'Study streak'**
  String get dashboardStreakTitle;

  /// No description provided for @dashboardStreakSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Consistency compounds when you keep short sessions moving.'**
  String get dashboardStreakSubtitle;

  /// No description provided for @dashboardDailyGoalLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily goal'**
  String get dashboardDailyGoalLabel;

  /// No description provided for @dashboardQuickActionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick actions'**
  String get dashboardQuickActionsTitle;

  /// No description provided for @dashboardQuickActionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Jump straight into the next useful move.'**
  String get dashboardQuickActionsSubtitle;

  /// No description provided for @dashboardDueDecksTitle.
  ///
  /// In en, this message translates to:
  /// **'Due decks'**
  String get dashboardDueDecksTitle;

  /// No description provided for @dashboardDueDecksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start with the decks carrying the heaviest review debt.'**
  String get dashboardDueDecksSubtitle;

  /// No description provided for @dashboardRefreshTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh dashboard'**
  String get dashboardRefreshTooltip;

  /// No description provided for @dashboardStartActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get dashboardStartActionLabel;

  /// No description provided for @dashboardOpenActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get dashboardOpenActionLabel;

  /// No description provided for @dashboardLaterActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get dashboardLaterActionLabel;

  /// No description provided for @dashboardReviewActionTitle.
  ///
  /// In en, this message translates to:
  /// **'Start review'**
  String get dashboardReviewActionTitle;

  /// No description provided for @dashboardReviewActionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Focus on the decks with the highest due volume first.'**
  String get dashboardReviewActionSubtitle;

  /// No description provided for @dashboardCreateDeckActionTitle.
  ///
  /// In en, this message translates to:
  /// **'Create deck'**
  String get dashboardCreateDeckActionTitle;

  /// No description provided for @dashboardCreateDeckActionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Capture a new topic while the idea is still fresh.'**
  String get dashboardCreateDeckActionSubtitle;

  /// No description provided for @dashboardImportCardsActionTitle.
  ///
  /// In en, this message translates to:
  /// **'Import cards'**
  String get dashboardImportCardsActionTitle;

  /// No description provided for @dashboardImportCardsActionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Bring in prepared content and queue it for practice.'**
  String get dashboardImportCardsActionSubtitle;

  /// No description provided for @dashboardReviewFocusLabel.
  ///
  /// In en, this message translates to:
  /// **'Review sprint'**
  String get dashboardReviewFocusLabel;

  /// No description provided for @dashboardCaptureFocusLabel.
  ///
  /// In en, this message translates to:
  /// **'Capture mode'**
  String get dashboardCaptureFocusLabel;

  /// No description provided for @dashboardImportFocusLabel.
  ///
  /// In en, this message translates to:
  /// **'Import queue'**
  String get dashboardImportFocusLabel;

  /// No description provided for @dashboardCompleteFocusLabel.
  ///
  /// In en, this message translates to:
  /// **'Inbox clear'**
  String get dashboardCompleteFocusLabel;

  /// No description provided for @dashboardLaterFocusLabel.
  ///
  /// In en, this message translates to:
  /// **'Later queue'**
  String get dashboardLaterFocusLabel;

  /// No description provided for @dashboardNoDueDecksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'You have cleared every due deck in the current queue.'**
  String get dashboardNoDueDecksSubtitle;

  /// No description provided for @dashboardQuickActionsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No quick actions right now'**
  String get dashboardQuickActionsEmptyTitle;

  /// No description provided for @dashboardQuickActionsEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'The current queue is stable, so you can stay with the active study flow.'**
  String get dashboardQuickActionsEmptySubtitle;

  /// No description provided for @dashboardTravelDeckTitle.
  ///
  /// In en, this message translates to:
  /// **'Travel phrases'**
  String get dashboardTravelDeckTitle;

  /// No description provided for @dashboardMedicalDeckTitle.
  ///
  /// In en, this message translates to:
  /// **'Medical terminology'**
  String get dashboardMedicalDeckTitle;

  /// No description provided for @dashboardVerbsDeckTitle.
  ///
  /// In en, this message translates to:
  /// **'Korean verbs'**
  String get dashboardVerbsDeckTitle;

  /// No description provided for @dashboardLanguageLabFolder.
  ///
  /// In en, this message translates to:
  /// **'Language Lab'**
  String get dashboardLanguageLabFolder;

  /// No description provided for @dashboardExamPrepFolder.
  ///
  /// In en, this message translates to:
  /// **'Exam Prep'**
  String get dashboardExamPrepFolder;

  /// No description provided for @dashboardDailyPracticeFolder.
  ///
  /// In en, this message translates to:
  /// **'Daily Practice'**
  String get dashboardDailyPracticeFolder;

  /// No description provided for @dashboardRecallModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Recall'**
  String get dashboardRecallModeLabel;

  /// No description provided for @dashboardReviewModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get dashboardReviewModeLabel;

  /// No description provided for @dashboardSpeedModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Speed drill'**
  String get dashboardSpeedModeLabel;

  /// No description provided for @foldersTitle.
  ///
  /// In en, this message translates to:
  /// **'Folders'**
  String get foldersTitle;

  /// No description provided for @folderLibraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Library folders'**
  String get folderLibraryTitle;

  /// No description provided for @folderScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse the library tree, reorganize branches, and jump into deck management when you reach a leaf folder.'**
  String get folderScreenSubtitle;

  /// No description provided for @folderRootBreadcrumbLabel.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get folderRootBreadcrumbLabel;

  /// No description provided for @folderSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search folders'**
  String get folderSearchHint;

  /// No description provided for @folderSortTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort folders'**
  String get folderSortTitle;

  /// No description provided for @folderSortDirectionTooltip.
  ///
  /// In en, this message translates to:
  /// **'Toggle folder sort direction'**
  String get folderSortDirectionTooltip;

  /// No description provided for @folderSortByName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get folderSortByName;

  /// No description provided for @folderSortByCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get folderSortByCreatedAt;

  /// No description provided for @folderSortByUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get folderSortByUpdatedAt;

  /// No description provided for @folderActionsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Folder actions'**
  String get folderActionsTooltip;

  /// No description provided for @folderCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Create folder'**
  String get folderCreateAction;

  /// No description provided for @folderRenameAction.
  ///
  /// In en, this message translates to:
  /// **'Rename folder'**
  String get folderRenameAction;

  /// No description provided for @folderEditAction.
  ///
  /// In en, this message translates to:
  /// **'Edit folder'**
  String get folderEditAction;

  /// No description provided for @folderSaveAction.
  ///
  /// In en, this message translates to:
  /// **'Save folder'**
  String get folderSaveAction;

  /// No description provided for @folderDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete folder'**
  String get folderDeleteAction;

  /// No description provided for @folderCancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get folderCancelAction;

  /// No description provided for @folderLeafLabel.
  ///
  /// In en, this message translates to:
  /// **'Leaf'**
  String get folderLeafLabel;

  /// No description provided for @folderErrorBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Folder action failed'**
  String get folderErrorBannerTitle;

  /// No description provided for @folderLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Unable to load folders right now. Try again.'**
  String get folderLoadErrorMessage;

  /// No description provided for @folderCreateDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new folder'**
  String get folderCreateDialogTitle;

  /// No description provided for @folderRenameDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Rename folder'**
  String get folderRenameDialogTitle;

  /// No description provided for @folderEditDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit folder'**
  String get folderEditDialogTitle;

  /// No description provided for @folderDeleteDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Deleting a folder also removes its child folders and every deck underneath it from the active workspace.'**
  String get folderDeleteDialogMessage;

  /// No description provided for @folderNameFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Folder name'**
  String get folderNameFieldLabel;

  /// No description provided for @folderDescriptionFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get folderDescriptionFieldLabel;

  /// No description provided for @folderNameRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Folder name is required.'**
  String get folderNameRequiredMessage;

  /// No description provided for @folderRootEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Start your library structure'**
  String get folderRootEmptyTitle;

  /// No description provided for @folderRootEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Create the first top-level folder to organize decks by topic, course, or project.'**
  String get folderRootEmptyMessage;

  /// No description provided for @folderLevelEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'This branch has no child folders'**
  String get folderLevelEmptyTitle;

  /// No description provided for @folderLevelEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Create a child folder here or return to the parent branch.'**
  String get folderLevelEmptyMessage;

  /// No description provided for @folderChildCountValue.
  ///
  /// In en, this message translates to:
  /// **'{count} child folders'**
  String folderChildCountValue(int count);

  /// No description provided for @folderDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{folderName}\"?'**
  String folderDeleteDialogTitle(Object folderName);

  /// No description provided for @foldersPlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Folder hub is ready'**
  String get foldersPlaceholderTitle;

  /// No description provided for @foldersPlaceholderMessage.
  ///
  /// In en, this message translates to:
  /// **'This root tab is wired into the shared app navigation. Folder-specific content can expand here next.'**
  String get foldersPlaceholderMessage;

  /// No description provided for @decksTitle.
  ///
  /// In en, this message translates to:
  /// **'Decks'**
  String get decksTitle;

  /// No description provided for @deckShellTitle.
  ///
  /// In en, this message translates to:
  /// **'Decks live inside folders'**
  String get deckShellTitle;

  /// No description provided for @deckShellSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a leaf folder first, then manage the decks that belong to that branch.'**
  String get deckShellSubtitle;

  /// No description provided for @deckShellMessage.
  ///
  /// In en, this message translates to:
  /// **'Deck management now follows the folder tree, so use the folders tab to choose the branch you want to study or maintain.'**
  String get deckShellMessage;

  /// No description provided for @deckShellBrowseFoldersAction.
  ///
  /// In en, this message translates to:
  /// **'Browse folders'**
  String get deckShellBrowseFoldersAction;

  /// No description provided for @deckScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage the decks stored inside the current leaf folder.'**
  String get deckScreenSubtitle;

  /// No description provided for @deckSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search decks'**
  String get deckSearchHint;

  /// No description provided for @deckSortTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort decks'**
  String get deckSortTitle;

  /// No description provided for @deckSortDirectionTooltip.
  ///
  /// In en, this message translates to:
  /// **'Toggle deck sort direction'**
  String get deckSortDirectionTooltip;

  /// No description provided for @deckSortByName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get deckSortByName;

  /// No description provided for @deckSortByCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get deckSortByCreatedAt;

  /// No description provided for @deckSortByUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get deckSortByUpdatedAt;

  /// No description provided for @deckActionsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Deck actions'**
  String get deckActionsTooltip;

  /// No description provided for @deckCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Create deck'**
  String get deckCreateAction;

  /// No description provided for @deckEditAction.
  ///
  /// In en, this message translates to:
  /// **'Edit deck'**
  String get deckEditAction;

  /// No description provided for @deckSaveAction.
  ///
  /// In en, this message translates to:
  /// **'Save deck'**
  String get deckSaveAction;

  /// No description provided for @deckDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete deck'**
  String get deckDeleteAction;

  /// No description provided for @deckCancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get deckCancelAction;

  /// No description provided for @deckErrorBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Deck action failed'**
  String get deckErrorBannerTitle;

  /// No description provided for @deckLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Unable to load decks right now. Try again.'**
  String get deckLoadErrorMessage;

  /// No description provided for @deckCreateDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new deck'**
  String get deckCreateDialogTitle;

  /// No description provided for @deckEditDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit deck'**
  String get deckEditDialogTitle;

  /// No description provided for @deckDeleteDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Deleting a deck also removes its flashcards from the active workspace.'**
  String get deckDeleteDialogMessage;

  /// No description provided for @deckNameFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Deck name'**
  String get deckNameFieldLabel;

  /// No description provided for @deckDescriptionFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get deckDescriptionFieldLabel;

  /// No description provided for @deckNameRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Deck name is required.'**
  String get deckNameRequiredMessage;

  /// No description provided for @deckEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No decks in this folder yet'**
  String get deckEmptyTitle;

  /// No description provided for @deckEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Create the first deck in this branch to start adding flashcards.'**
  String get deckEmptyMessage;

  /// No description provided for @deckDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Deck details'**
  String get deckDetailTitle;

  /// No description provided for @deckDetailPlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Flashcards are the next layer'**
  String get deckDetailPlaceholderTitle;

  /// No description provided for @deckDetailPlaceholderMessage.
  ///
  /// In en, this message translates to:
  /// **'Flashcard workspace will be connected next.'**
  String get deckDetailPlaceholderMessage;

  /// No description provided for @deckBackToListAction.
  ///
  /// In en, this message translates to:
  /// **'Back to deck list'**
  String get deckBackToListAction;

  /// No description provided for @deckFlashcardCountValue.
  ///
  /// In en, this message translates to:
  /// **'{count} flashcards'**
  String deckFlashcardCountValue(int count);

  /// No description provided for @deckFlashcardCountChipLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} cards'**
  String deckFlashcardCountChipLabel(int count);

  /// No description provided for @deckSummaryDeckCount.
  ///
  /// In en, this message translates to:
  /// **'{count} decks'**
  String deckSummaryDeckCount(int count);

  /// No description provided for @deckSummaryFlashcardCount.
  ///
  /// In en, this message translates to:
  /// **'{count} flashcards'**
  String deckSummaryFlashcardCount(int count);

  /// No description provided for @deckDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{deckName}\"?'**
  String deckDeleteDialogTitle(Object deckName);

  /// No description provided for @decksPlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Deck library is ready'**
  String get decksPlaceholderTitle;

  /// No description provided for @decksPlaceholderMessage.
  ///
  /// In en, this message translates to:
  /// **'This tab is now part of the common shell, so deck listing and filtering can grow without changing app navigation.'**
  String get decksPlaceholderMessage;

  /// No description provided for @progressTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progressTitle;

  /// No description provided for @progressPlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress workspace is ready'**
  String get progressPlaceholderTitle;

  /// No description provided for @progressPlaceholderMessage.
  ///
  /// In en, this message translates to:
  /// **'Charts, streaks, and history can plug into this shared navigation slot when the feature slice is implemented.'**
  String get progressPlaceholderMessage;

  /// No description provided for @progressOverviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track study cadence, due pressure, and the next recommended review block.'**
  String get progressOverviewSubtitle;

  /// No description provided for @progressLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Loading study performance, streaks, and due recommendations.'**
  String get progressLoadingMessage;

  /// No description provided for @progressErrorTitle.
  ///
  /// In en, this message translates to:
  /// **'Unable to load progress'**
  String get progressErrorTitle;

  /// No description provided for @progressLoadErrorMessage.
  ///
  /// In en, this message translates to:
  /// **'Refresh the current period or try again in a moment.'**
  String get progressLoadErrorMessage;

  /// No description provided for @progressCalendarActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Study calendar'**
  String get progressCalendarActionLabel;

  /// No description provided for @progressDeckProgressActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Deck progress'**
  String get progressDeckProgressActionLabel;

  /// No description provided for @progressSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Study overview'**
  String get progressSummaryTitle;

  /// No description provided for @progressSummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'A quick read on review load, accuracy, and reminder pressure.'**
  String get progressSummarySubtitle;

  /// No description provided for @progressDueLabel.
  ///
  /// In en, this message translates to:
  /// **'Due cards'**
  String get progressDueLabel;

  /// No description provided for @progressReminderTypesLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminder mix'**
  String get progressReminderTypesLabel;

  /// No description provided for @progressOverdueLabel.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get progressOverdueLabel;

  /// No description provided for @progressLearnedLabel.
  ///
  /// In en, this message translates to:
  /// **'Learned'**
  String get progressLearnedLabel;

  /// No description provided for @progressBoxDistributionLabel.
  ///
  /// In en, this message translates to:
  /// **'Box spread'**
  String get progressBoxDistributionLabel;

  /// No description provided for @progressAccuracyLabel.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get progressAccuracyLabel;

  /// No description provided for @progressPassedAttemptsLabel.
  ///
  /// In en, this message translates to:
  /// **'Passed attempts'**
  String get progressPassedAttemptsLabel;

  /// No description provided for @progressFailedAttemptsLabel.
  ///
  /// In en, this message translates to:
  /// **'Failed attempts'**
  String get progressFailedAttemptsLabel;

  /// No description provided for @progressChartTitle.
  ///
  /// In en, this message translates to:
  /// **'Distribution'**
  String get progressChartTitle;

  /// No description provided for @progressChartSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See how cards are currently spread across the active review boxes.'**
  String get progressChartSubtitle;

  /// No description provided for @progressFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress period'**
  String get progressFilterTitle;

  /// No description provided for @progressRefreshTooltip.
  ///
  /// In en, this message translates to:
  /// **'Refresh progress'**
  String get progressRefreshTooltip;

  /// No description provided for @progressPeriodTodayLabel.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get progressPeriodTodayLabel;

  /// No description provided for @progressPeriodWeekLabel.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get progressPeriodWeekLabel;

  /// No description provided for @progressPeriodMonthLabel.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get progressPeriodMonthLabel;

  /// No description provided for @progressRecommendationTitle.
  ///
  /// In en, this message translates to:
  /// **'Recommended next review'**
  String get progressRecommendationTitle;

  /// No description provided for @progressRecommendationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use the heaviest due deck to decide the next useful session.'**
  String get progressRecommendationSubtitle;

  /// No description provided for @progressRecommendationEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'No specific deck needs immediate follow-up right now.'**
  String get progressRecommendationEmptyMessage;

  /// No description provided for @progressRecommendationMetaLabel.
  ///
  /// In en, this message translates to:
  /// **'{sessionType} · {minutes} min planned'**
  String progressRecommendationMetaLabel(Object sessionType, int minutes);

  /// No description provided for @progressStudyNowActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Study now'**
  String get progressStudyNowActionLabel;

  /// No description provided for @progressViewDeckActionLabel.
  ///
  /// In en, this message translates to:
  /// **'View deck progress'**
  String get progressViewDeckActionLabel;

  /// No description provided for @progressDueCountChipLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} due'**
  String progressDueCountChipLabel(int count);

  /// No description provided for @progressOverdueCountChipLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} overdue'**
  String progressOverdueCountChipLabel(int count);

  /// No description provided for @progressHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent activity'**
  String get progressHistoryTitle;

  /// No description provided for @progressHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'A short log of study outcomes and scheduling changes.'**
  String get progressHistorySubtitle;

  /// No description provided for @progressCalendarTitle.
  ///
  /// In en, this message translates to:
  /// **'Streak calendar'**
  String get progressCalendarTitle;

  /// No description provided for @progressCalendarSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A compact view of recent study consistency.'**
  String get progressCalendarSubtitle;

  /// No description provided for @progressEscalationCalmLabel.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get progressEscalationCalmLabel;

  /// No description provided for @progressEscalationWatchLabel.
  ///
  /// In en, this message translates to:
  /// **'Watch'**
  String get progressEscalationWatchLabel;

  /// No description provided for @progressEscalationUrgentLabel.
  ///
  /// In en, this message translates to:
  /// **'Urgent'**
  String get progressEscalationUrgentLabel;

  /// No description provided for @progressEscalationCriticalLabel.
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get progressEscalationCriticalLabel;

  /// No description provided for @progressDeckScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Deck progress'**
  String get progressDeckScreenTitle;

  /// No description provided for @progressDeckScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review due pressure, accuracy, and recent activity for the selected deck.'**
  String get progressDeckScreenSubtitle;

  /// No description provided for @progressDeckFocusTitle.
  ///
  /// In en, this message translates to:
  /// **'Selected deck'**
  String get progressDeckFocusTitle;

  /// No description provided for @progressDeckFocusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A focused snapshot for the current deck under the active period filter.'**
  String get progressDeckFocusSubtitle;

  /// No description provided for @progressDeckIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Deck #{deckId}'**
  String progressDeckIdLabel(int deckId);

  /// No description provided for @progressDeckRecommendationLabel.
  ///
  /// In en, this message translates to:
  /// **'{sessionType} · {minutes} min recommended'**
  String progressDeckRecommendationLabel(Object sessionType, int minutes);

  /// No description provided for @progressCalendarScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Study calendar'**
  String get progressCalendarScreenTitle;

  /// No description provided for @progressCalendarScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track streak consistency and recent sessions across the active period.'**
  String get progressCalendarScreenSubtitle;

  /// No description provided for @progressJapaneseBasicsDeckTitle.
  ///
  /// In en, this message translates to:
  /// **'Japanese basics'**
  String get progressJapaneseBasicsDeckTitle;

  /// No description provided for @progressExamPrepDeckTitle.
  ///
  /// In en, this message translates to:
  /// **'Exam prep'**
  String get progressExamPrepDeckTitle;

  /// No description provided for @progressReminderSrsReviewLabel.
  ///
  /// In en, this message translates to:
  /// **'SRS review'**
  String get progressReminderSrsReviewLabel;

  /// No description provided for @progressReminderOverdueCatchUpLabel.
  ///
  /// In en, this message translates to:
  /// **'Overdue catch-up'**
  String get progressReminderOverdueCatchUpLabel;

  /// No description provided for @progressReminderMorningReviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Morning review'**
  String get progressReminderMorningReviewLabel;

  /// No description provided for @progressReminderEveningReviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Evening review'**
  String get progressReminderEveningReviewLabel;

  /// No description provided for @progressReminderAfternoonReviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Afternoon review'**
  String get progressReminderAfternoonReviewLabel;

  /// No description provided for @progressSessionReviewSprintLabel.
  ///
  /// In en, this message translates to:
  /// **'Review sprint'**
  String get progressSessionReviewSprintLabel;

  /// No description provided for @progressSessionFocusedReviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Focused review'**
  String get progressSessionFocusedReviewLabel;

  /// No description provided for @progressSessionDeepReviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Deep review'**
  String get progressSessionDeepReviewLabel;

  /// No description provided for @progressBoxLabel.
  ///
  /// In en, this message translates to:
  /// **'Box {index}'**
  String progressBoxLabel(int index);

  /// No description provided for @progressHistoryCompletedAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Completed {count} cards with {accuracy}% accuracy'**
  String progressHistoryCompletedAccuracy(int count, int accuracy);

  /// No description provided for @progressHistoryMissedCards.
  ///
  /// In en, this message translates to:
  /// **'Missed {count} cards in a review sprint'**
  String progressHistoryMissedCards(int count);

  /// No description provided for @progressHistoryScheduledTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Scheduled {count} cards for tomorrow'**
  String progressHistoryScheduledTomorrow(int count);

  /// No description provided for @progressHistoryFinishedWeek.
  ///
  /// In en, this message translates to:
  /// **'Finished {count} cards this week'**
  String progressHistoryFinishedWeek(int count);

  /// No description provided for @progressHistoryLeftForNextSprint.
  ///
  /// In en, this message translates to:
  /// **'Left {count} cards for the next sprint'**
  String progressHistoryLeftForNextSprint(int count);

  /// No description provided for @progressHistoryResetToBoxOne.
  ///
  /// In en, this message translates to:
  /// **'{count} cards scheduled back into box 1'**
  String progressHistoryResetToBoxOne(int count);

  /// No description provided for @progressHistoryMaintainedAccuracy.
  ///
  /// In en, this message translates to:
  /// **'Maintained {accuracy}% accuracy over the month'**
  String progressHistoryMaintainedAccuracy(int accuracy);

  /// No description provided for @progressHistoryAccumulatedDueCards.
  ///
  /// In en, this message translates to:
  /// **'Accumulated {count} due cards for review'**
  String progressHistoryAccumulatedDueCards(int count);

  /// No description provided for @progressHistoryStrongestGrowth.
  ///
  /// In en, this message translates to:
  /// **'{boxLabel} has the strongest growth'**
  String progressHistoryStrongestGrowth(Object boxLabel);

  /// No description provided for @progressTimestampTodayAt.
  ///
  /// In en, this message translates to:
  /// **'Today • {time}'**
  String progressTimestampTodayAt(Object time);

  /// No description provided for @progressTimestampYesterdayAt.
  ///
  /// In en, this message translates to:
  /// **'Yesterday • {time}'**
  String progressTimestampYesterdayAt(Object time);

  /// No description provided for @progressTimestampDayAt.
  ///
  /// In en, this message translates to:
  /// **'{day} • {time}'**
  String progressTimestampDayAt(Object day, Object time);

  /// No description provided for @progressTimestampHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours}h ago'**
  String progressTimestampHoursAgo(int hours);

  /// No description provided for @progressDayMonShort.
  ///
  /// In en, this message translates to:
  /// **'M'**
  String get progressDayMonShort;

  /// No description provided for @progressDayTueShort.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get progressDayTueShort;

  /// No description provided for @progressDayWedShort.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get progressDayWedShort;

  /// No description provided for @progressDayThuShort.
  ///
  /// In en, this message translates to:
  /// **'T'**
  String get progressDayThuShort;

  /// No description provided for @progressDayFriShort.
  ///
  /// In en, this message translates to:
  /// **'F'**
  String get progressDayFriShort;

  /// No description provided for @progressDaySatShort.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get progressDaySatShort;

  /// No description provided for @progressDaySunShort.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get progressDaySunShort;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsPlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings center is ready'**
  String get settingsPlaceholderTitle;

  /// No description provided for @settingsPlaceholderMessage.
  ///
  /// In en, this message translates to:
  /// **'App preferences already have a dedicated root tab, ready for theme, language, audio, and backup settings.'**
  String get settingsPlaceholderMessage;

  /// No description provided for @settingsSectionAppearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsSectionAppearanceTitle;

  /// No description provided for @settingsSectionAppearanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tune the app look and reading language.'**
  String get settingsSectionAppearanceSubtitle;

  /// No description provided for @settingsSectionAudioTitle.
  ///
  /// In en, this message translates to:
  /// **'Audio and feedback'**
  String get settingsSectionAudioTitle;

  /// No description provided for @settingsSectionAudioSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Control playback, cues, and tactile feedback during study.'**
  String get settingsSectionAudioSubtitle;

  /// No description provided for @settingsSectionBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup and reminders'**
  String get settingsSectionBackupTitle;

  /// No description provided for @settingsSectionBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep study preferences recoverable and reminders discoverable.'**
  String get settingsSectionBackupSubtitle;

  /// No description provided for @settingsSectionAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsSectionAboutTitle;

  /// No description provided for @settingsSectionAboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Inspect the active app environment and client configuration.'**
  String get settingsSectionAboutSubtitle;

  /// No description provided for @settingsThemeTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeTileTitle;

  /// No description provided for @settingsLanguageTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageTileTitle;

  /// No description provided for @settingsAudioTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Audio settings'**
  String get settingsAudioTileTitle;

  /// No description provided for @settingsAudioTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure text-to-speech, sounds, and haptics.'**
  String get settingsAudioTileSubtitle;

  /// No description provided for @settingsQuickHapticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick haptics'**
  String get settingsQuickHapticsTitle;

  /// No description provided for @settingsQuickHapticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep short tactile feedback available in the main settings screen.'**
  String get settingsQuickHapticsSubtitle;

  /// No description provided for @settingsBackupTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup and restore'**
  String get settingsBackupTileTitle;

  /// No description provided for @settingsBackupTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage snapshots and sync readiness for the current device.'**
  String get settingsBackupTileSubtitle;

  /// No description provided for @settingsReminderTileTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder settings'**
  String get settingsReminderTileTitle;

  /// No description provided for @settingsReminderTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Review study nudges, time slots, and reminder preview.'**
  String get settingsReminderTileSubtitle;

  /// No description provided for @settingsAboutTileTitle.
  ///
  /// In en, this message translates to:
  /// **'About this app'**
  String get settingsAboutTileTitle;

  /// No description provided for @settingsAboutTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'View runtime environment, language, theme, and API target.'**
  String get settingsAboutTileSubtitle;

  /// No description provided for @themeSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme settings'**
  String get themeSettingsTitle;

  /// No description provided for @themeSystemLabel.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get themeSystemLabel;

  /// No description provided for @themeSystemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Match the current platform brightness automatically.'**
  String get themeSystemSubtitle;

  /// No description provided for @themeLightLabel.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLightLabel;

  /// No description provided for @themeLightSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep the interface bright across the app.'**
  String get themeLightSubtitle;

  /// No description provided for @themeDarkLabel.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDarkLabel;

  /// No description provided for @themeDarkSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use a darker surface palette for lower-light study.'**
  String get themeDarkSubtitle;

  /// No description provided for @languageSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Language settings'**
  String get languageSettingsTitle;

  /// No description provided for @audioSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Audio settings'**
  String get audioSettingsTitle;

  /// No description provided for @audioSettingsSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Study audio controls'**
  String get audioSettingsSectionTitle;

  /// No description provided for @audioSettingsSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose which supporting sounds stay active during study sessions.'**
  String get audioSettingsSectionSubtitle;

  /// No description provided for @audioTtsTitle.
  ///
  /// In en, this message translates to:
  /// **'Text to speech'**
  String get audioTtsTitle;

  /// No description provided for @audioTtsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Allow pronunciation playback for supported flashcards.'**
  String get audioTtsSubtitle;

  /// No description provided for @audioReviewSoundsTitle.
  ///
  /// In en, this message translates to:
  /// **'Review sounds'**
  String get audioReviewSoundsTitle;

  /// No description provided for @audioReviewSoundsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Play short success and error cues during study.'**
  String get audioReviewSoundsSubtitle;

  /// No description provided for @audioHapticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback'**
  String get audioHapticsTitle;

  /// No description provided for @audioHapticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use short vibrations to reinforce actions and results.'**
  String get audioHapticsSubtitle;

  /// No description provided for @backupRestoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup and restore'**
  String get backupRestoreTitle;

  /// No description provided for @backupRestoreSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Backup preferences'**
  String get backupRestoreSectionTitle;

  /// No description provided for @backupRestoreSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Control whether this device should keep sync-ready backup behavior enabled.'**
  String get backupRestoreSectionSubtitle;

  /// No description provided for @backupCloudBackupTitle.
  ///
  /// In en, this message translates to:
  /// **'Cloud backup readiness'**
  String get backupCloudBackupTitle;

  /// No description provided for @backupCloudBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep backup-related preferences enabled for future sync support.'**
  String get backupCloudBackupSubtitle;

  /// No description provided for @backupSnapshotSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Local snapshot'**
  String get backupSnapshotSectionTitle;

  /// No description provided for @backupNoSnapshotLabel.
  ///
  /// In en, this message translates to:
  /// **'No backup snapshot has been created on this device yet.'**
  String get backupNoSnapshotLabel;

  /// No description provided for @backupLastBackupLabel.
  ///
  /// In en, this message translates to:
  /// **'Last backup snapshot: {timestamp}'**
  String backupLastBackupLabel(Object timestamp);

  /// No description provided for @backupCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Create snapshot'**
  String get backupCreateAction;

  /// No description provided for @backupClearAction.
  ///
  /// In en, this message translates to:
  /// **'Clear snapshot'**
  String get backupClearAction;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutTitle;

  /// No description provided for @aboutApplicationSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Application details'**
  String get aboutApplicationSectionTitle;

  /// No description provided for @aboutApplicationSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'This information reflects the active runtime configuration.'**
  String get aboutApplicationSectionSubtitle;

  /// No description provided for @aboutAppNameLabel.
  ///
  /// In en, this message translates to:
  /// **'App name'**
  String get aboutAppNameLabel;

  /// No description provided for @aboutEnvironmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get aboutEnvironmentLabel;

  /// No description provided for @aboutCurrentThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'Current theme'**
  String get aboutCurrentThemeLabel;

  /// No description provided for @aboutCurrentLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Current language'**
  String get aboutCurrentLanguageLabel;

  /// No description provided for @aboutBaseUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'API base URL'**
  String get aboutBaseUrlLabel;

  /// No description provided for @createLabel.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createLabel;

  /// No description provided for @saveLabel.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveLabel;

  /// No description provided for @cancelLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelLabel;

  /// No description provided for @deleteLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteLabel;

  /// No description provided for @editLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editLabel;

  /// No description provided for @openFoldersLabel.
  ///
  /// In en, this message translates to:
  /// **'Open folders'**
  String get openFoldersLabel;

  /// No description provided for @manageDecksLabel.
  ///
  /// In en, this message translates to:
  /// **'Manage decks'**
  String get manageDecksLabel;

  /// No description provided for @createFolderLabel.
  ///
  /// In en, this message translates to:
  /// **'Create folder'**
  String get createFolderLabel;

  /// No description provided for @editFolderLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit folder'**
  String get editFolderLabel;

  /// No description provided for @deleteFolderLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete folder'**
  String get deleteFolderLabel;

  /// No description provided for @createDeckLabel.
  ///
  /// In en, this message translates to:
  /// **'Create deck'**
  String get createDeckLabel;

  /// No description provided for @editDeckLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit deck'**
  String get editDeckLabel;

  /// No description provided for @deleteDeckLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete deck'**
  String get deleteDeckLabel;

  /// No description provided for @folderNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Folder name'**
  String get folderNameLabel;

  /// No description provided for @folderDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Folder description'**
  String get folderDescriptionLabel;

  /// No description provided for @deckNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Deck name'**
  String get deckNameLabel;

  /// No description provided for @deckDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Deck description'**
  String get deckDescriptionLabel;

  /// No description provided for @sortByNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get sortByNameLabel;

  /// No description provided for @sortByCreatedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get sortByCreatedAtLabel;

  /// No description provided for @sortByUpdatedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get sortByUpdatedAtLabel;

  /// No description provided for @ascendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Ascending'**
  String get ascendingLabel;

  /// No description provided for @descendingLabel.
  ///
  /// In en, this message translates to:
  /// **'Descending'**
  String get descendingLabel;

  /// No description provided for @foldersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No folders yet'**
  String get foldersEmptyTitle;

  /// No description provided for @foldersEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Create the first folder in this branch to organize your study library.'**
  String get foldersEmptyMessage;

  /// No description provided for @folderLeafHint.
  ///
  /// In en, this message translates to:
  /// **'This folder has no child folders.'**
  String get folderLeafHint;

  /// No description provided for @folderBranchHint.
  ///
  /// In en, this message translates to:
  /// **'This folder still has child folders.'**
  String get folderBranchHint;

  /// No description provided for @decksShellTitle.
  ///
  /// In en, this message translates to:
  /// **'Deck workspace'**
  String get decksShellTitle;

  /// No description provided for @decksShellMessage.
  ///
  /// In en, this message translates to:
  /// **'Open a leaf folder to manage the decks inside it.'**
  String get decksShellMessage;

  /// No description provided for @decksEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No decks yet'**
  String get decksEmptyTitle;

  /// No description provided for @decksEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Create the first deck in this folder to start studying.'**
  String get decksEmptyMessage;

  /// No description provided for @deckSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Deck summary'**
  String get deckSummaryTitle;

  /// No description provided for @flashcardsTitle.
  ///
  /// In en, this message translates to:
  /// **'Flashcards'**
  String get flashcardsTitle;

  /// No description provided for @flashcardScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Search, preview, and maintain the flashcards in the current deck.'**
  String get flashcardScreenSubtitle;

  /// No description provided for @flashcardSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search flashcards'**
  String get flashcardSearchHint;

  /// No description provided for @flashcardSortTitle.
  ///
  /// In en, this message translates to:
  /// **'Sort flashcards'**
  String get flashcardSortTitle;

  /// No description provided for @flashcardSortDirectionTooltip.
  ///
  /// In en, this message translates to:
  /// **'Toggle flashcard sort direction'**
  String get flashcardSortDirectionTooltip;

  /// No description provided for @flashcardSortByCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get flashcardSortByCreatedAt;

  /// No description provided for @flashcardSortByUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get flashcardSortByUpdatedAt;

  /// No description provided for @flashcardSortByFrontText.
  ///
  /// In en, this message translates to:
  /// **'Front text'**
  String get flashcardSortByFrontText;

  /// No description provided for @flashcardErrorBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Flashcard action failed'**
  String get flashcardErrorBannerTitle;

  /// No description provided for @flashcardCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Create flashcard'**
  String get flashcardCreateAction;

  /// No description provided for @flashcardEditAction.
  ///
  /// In en, this message translates to:
  /// **'Edit flashcard'**
  String get flashcardEditAction;

  /// No description provided for @flashcardSaveAction.
  ///
  /// In en, this message translates to:
  /// **'Save flashcard'**
  String get flashcardSaveAction;

  /// No description provided for @flashcardDeleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete flashcard'**
  String get flashcardDeleteAction;

  /// No description provided for @flashcardCancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get flashcardCancelAction;

  /// No description provided for @flashcardEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No flashcards in this deck yet'**
  String get flashcardEmptyTitle;

  /// No description provided for @flashcardEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Create the first flashcard in this deck to start building study content.'**
  String get flashcardEmptyMessage;

  /// No description provided for @flashcardFrontFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Front text'**
  String get flashcardFrontFieldLabel;

  /// No description provided for @flashcardBackFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Back text'**
  String get flashcardBackFieldLabel;

  /// No description provided for @flashcardFrontLangFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Front language code'**
  String get flashcardFrontLangFieldLabel;

  /// No description provided for @flashcardBackLangFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Back language code'**
  String get flashcardBackLangFieldLabel;

  /// No description provided for @flashcardFrontRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Front text is required.'**
  String get flashcardFrontRequiredMessage;

  /// No description provided for @flashcardBackRequiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Back text is required.'**
  String get flashcardBackRequiredMessage;

  /// No description provided for @flashcardDeleteDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{flashcardText}\"?'**
  String flashcardDeleteDialogTitle(Object flashcardText);

  /// No description provided for @flashcardDeleteDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Deleting a flashcard removes it from the active deck.'**
  String get flashcardDeleteDialogMessage;

  /// No description provided for @flashcardPreviewCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} preview cards'**
  String flashcardPreviewCountLabel(int count);

  /// No description provided for @flashcardBrowseModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Browse mode'**
  String get flashcardBrowseModeLabel;

  /// No description provided for @flashcardSearchModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Search mode'**
  String get flashcardSearchModeLabel;

  /// No description provided for @flashcardPinnedLabel.
  ///
  /// In en, this message translates to:
  /// **'Pinned'**
  String get flashcardPinnedLabel;

  /// No description provided for @flashcardPreviewEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Flashcard preview is ready'**
  String get flashcardPreviewEmptyTitle;

  /// No description provided for @flashcardPreviewEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add flashcards to the deck to see preview cards here.'**
  String get flashcardPreviewEmptyMessage;

  /// No description provided for @flashcardImportPlaceholderTitle.
  ///
  /// In en, this message translates to:
  /// **'Flashcard import is ready'**
  String get flashcardImportPlaceholderTitle;

  /// No description provided for @flashcardImportPlaceholderMessage.
  ///
  /// In en, this message translates to:
  /// **'Bulk import can be connected here later without changing the deck workspace.'**
  String get flashcardImportPlaceholderMessage;

  /// No description provided for @flashcardImportCreatedLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} created'**
  String flashcardImportCreatedLabel(int count);

  /// No description provided for @flashcardImportFailedLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} failed'**
  String flashcardImportFailedLabel(int count);

  /// No description provided for @flashcardActionsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Flashcard actions'**
  String get flashcardActionsTooltip;

  /// No description provided for @offlineTitle.
  ///
  /// In en, this message translates to:
  /// **'You are offline'**
  String get offlineTitle;

  /// No description provided for @offlineMessage.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection and try again.'**
  String get offlineMessage;

  /// No description provided for @offlineRetryLabel.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get offlineRetryLabel;

  /// No description provided for @maintenanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenanceTitle;

  /// No description provided for @maintenanceMessage.
  ///
  /// In en, this message translates to:
  /// **'The system is temporarily unavailable.'**
  String get maintenanceMessage;

  /// No description provided for @notFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get notFoundTitle;

  /// No description provided for @notFoundMessage.
  ///
  /// In en, this message translates to:
  /// **'The requested page does not exist.'**
  String get notFoundMessage;

  /// No description provided for @clearSelectionTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear selection'**
  String get clearSelectionTooltip;

  /// No description provided for @filterTooltip.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filterTooltip;

  /// No description provided for @sortTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sortTooltip;

  /// No description provided for @noResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsTitle;

  /// No description provided for @noResultsMessage.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters or search terms.'**
  String get noResultsMessage;

  /// No description provided for @accessRequiredTitle.
  ///
  /// In en, this message translates to:
  /// **'Access required'**
  String get accessRequiredTitle;

  /// No description provided for @signInMessage.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue.'**
  String get signInMessage;

  /// No description provided for @signInLabel.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInLabel;

  /// No description provided for @clearDateTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear date'**
  String get clearDateTooltip;

  /// No description provided for @clearTimeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear time'**
  String get clearTimeTooltip;

  /// No description provided for @clearSearchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearchTooltip;

  /// No description provided for @selectDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Select date'**
  String get selectDateLabel;

  /// No description provided for @selectTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Select time'**
  String get selectTimeLabel;

  /// No description provided for @searchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchLabel;

  /// No description provided for @requiredFieldMark.
  ///
  /// In en, this message translates to:
  /// **' *'**
  String get requiredFieldMark;

  /// No description provided for @selectionCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String selectionCountLabel(int count);

  /// No description provided for @dashboardFocusChipLabel.
  ///
  /// In en, this message translates to:
  /// **'Focus: {focusLabel}'**
  String dashboardFocusChipLabel(Object focusLabel);

  /// No description provided for @dashboardDueDeckChipLabel.
  ///
  /// In en, this message translates to:
  /// **'{dueDeckCount} decks due'**
  String dashboardDueDeckChipLabel(Object dueDeckCount);

  /// No description provided for @dashboardDueCardChipLabel.
  ///
  /// In en, this message translates to:
  /// **'{dueCardCount} cards today'**
  String dashboardDueCardChipLabel(Object dueCardCount);

  /// No description provided for @dashboardDueDeckValue.
  ///
  /// In en, this message translates to:
  /// **'{dueDeckCount} decks'**
  String dashboardDueDeckValue(Object dueDeckCount);

  /// No description provided for @dashboardDueCardValue.
  ///
  /// In en, this message translates to:
  /// **'{dueCardCount} cards'**
  String dashboardDueCardValue(Object dueCardCount);

  /// No description provided for @dashboardReviewedValue.
  ///
  /// In en, this message translates to:
  /// **'{reviewedCount} cards'**
  String dashboardReviewedValue(Object reviewedCount);

  /// No description provided for @dashboardStudyMinutesValue.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String dashboardStudyMinutesValue(Object minutes);

  /// No description provided for @dashboardStreakValue.
  ///
  /// In en, this message translates to:
  /// **'{days} days'**
  String dashboardStreakValue(Object days);

  /// No description provided for @dashboardGoalProgressMessage.
  ///
  /// In en, this message translates to:
  /// **'{reviewed} / {goal} cards reviewed today'**
  String dashboardGoalProgressMessage(Object reviewed, Object goal);

  /// No description provided for @dashboardGoalRemainingMessage.
  ///
  /// In en, this message translates to:
  /// **'{remaining} cards left to hit today\'s goal'**
  String dashboardGoalRemainingMessage(Object remaining);

  /// No description provided for @dashboardDeckStatusMessage.
  ///
  /// In en, this message translates to:
  /// **'{folderName} • {modeLabel} • {mastery}% mastered'**
  String dashboardDeckStatusMessage(
    Object folderName,
    Object modeLabel,
    Object mastery,
  );

  /// No description provided for @dashboardDueCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{dueCount} due'**
  String dashboardDueCountLabel(Object dueCount);

  /// No description provided for @authLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get authLoginTitle;

  /// No description provided for @authRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Create your account'**
  String get authRegisterTitle;

  /// No description provided for @authLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue organizing decks, tracking streaks, and reviewing what is due next.'**
  String get authLoginSubtitle;

  /// No description provided for @authRegisterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a study account so your folders, decks, and progress can stay in sync.'**
  String get authRegisterSubtitle;

  /// No description provided for @authModeLoginLabel.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get authModeLoginLabel;

  /// No description provided for @authModeRegisterLabel.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get authModeRegisterLabel;

  /// No description provided for @authIdentifierLabel.
  ///
  /// In en, this message translates to:
  /// **'Email or username'**
  String get authIdentifierLabel;

  /// No description provided for @authIdentifierHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get authIdentifierHint;

  /// No description provided for @authIdentifierRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Enter your email or username.'**
  String get authIdentifierRequiredError;

  /// No description provided for @authUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get authUsernameLabel;

  /// No description provided for @authUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'study_builder'**
  String get authUsernameHint;

  /// No description provided for @authUsernameRequiredError.
  ///
  /// In en, this message translates to:
  /// **'Enter a username with at least 3 characters.'**
  String get authUsernameRequiredError;

  /// No description provided for @authEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmailLabel;

  /// No description provided for @authEmailHint.
  ///
  /// In en, this message translates to:
  /// **'learner@example.com'**
  String get authEmailHint;

  /// No description provided for @authEmailInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get authEmailInvalidError;

  /// No description provided for @authPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPasswordLabel;

  /// No description provided for @authPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters'**
  String get authPasswordHint;

  /// No description provided for @authPasswordInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters.'**
  String get authPasswordInvalidError;

  /// No description provided for @authForgotPasswordAction.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get authForgotPasswordAction;

  /// No description provided for @authSuccessBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'All set'**
  String get authSuccessBannerTitle;

  /// No description provided for @authWarningBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Check this first'**
  String get authWarningBannerTitle;

  /// No description provided for @authErrorBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Authentication failed'**
  String get authErrorBannerTitle;

  /// No description provided for @authInfoBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Heads up'**
  String get authInfoBannerTitle;

  /// No description provided for @authSocialSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get authSocialSectionTitle;

  /// No description provided for @authContinueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get authContinueWithGoogle;

  /// No description provided for @authContinueWithApple.
  ///
  /// In en, this message translates to:
  /// **'Continue with Apple'**
  String get authContinueWithApple;

  /// No description provided for @authContinueWithKakao.
  ///
  /// In en, this message translates to:
  /// **'Continue with Kakao'**
  String get authContinueWithKakao;

  /// No description provided for @authBootstrapLoadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Checking your saved session'**
  String get authBootstrapLoadingTitle;

  /// No description provided for @authBootstrapLoadingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We are deciding whether to send you straight into the app or back to authentication.'**
  String get authBootstrapLoadingSubtitle;

  /// No description provided for @authLoginSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'You are signed in and ready to continue learning.'**
  String get authLoginSuccessMessage;

  /// No description provided for @authRegisterSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account is ready and your first learning workspace is unlocked.'**
  String get authRegisterSuccessMessage;

  /// No description provided for @authSignOutSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Your current session has been cleared from this device.'**
  String get authSignOutSuccessMessage;

  /// No description provided for @authSessionExpiredMessage.
  ///
  /// In en, this message translates to:
  /// **'Your session has expired. Please sign in again to continue.'**
  String get authSessionExpiredMessage;

  /// No description provided for @authPasswordResetSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Password reset instructions have been sent to your email.'**
  String get authPasswordResetSuccessMessage;

  /// No description provided for @authInvalidCredentialsMessage.
  ///
  /// In en, this message translates to:
  /// **'Your login details do not look right yet. Check the identifier and password.'**
  String get authInvalidCredentialsMessage;

  /// No description provided for @authDuplicateAccountMessage.
  ///
  /// In en, this message translates to:
  /// **'That username or email is already being used.'**
  String get authDuplicateAccountMessage;

  /// No description provided for @authInvalidResetRequestMessage.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email before requesting a reset link.'**
  String get authInvalidResetRequestMessage;

  /// No description provided for @authNetworkFailureMessage.
  ///
  /// In en, this message translates to:
  /// **'We could not reach the server. Try again when the network is stable.'**
  String get authNetworkFailureMessage;

  /// No description provided for @authSessionReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'Session is active'**
  String get authSessionReadyTitle;

  /// No description provided for @authSessionReadyMessage.
  ///
  /// In en, this message translates to:
  /// **'You are currently signed in as {userLabel}. Continue into the app or sign out to switch accounts.'**
  String authSessionReadyMessage(Object userLabel);

  /// No description provided for @authContinueToAppAction.
  ///
  /// In en, this message translates to:
  /// **'Stay signed in'**
  String get authContinueToAppAction;

  /// No description provided for @authSignOutAction.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get authSignOutAction;

  /// No description provided for @authForgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset your password'**
  String get authForgotPasswordTitle;

  /// No description provided for @authForgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your account email and we will prepare a reset instruction message.'**
  String get authForgotPasswordSubtitle;

  /// No description provided for @authBackToLoginAction.
  ///
  /// In en, this message translates to:
  /// **'Back to login'**
  String get authBackToLoginAction;

  /// No description provided for @authSendResetAction.
  ///
  /// In en, this message translates to:
  /// **'Send reset instructions'**
  String get authSendResetAction;

  /// No description provided for @reminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Study reminders'**
  String get reminderTitle;

  /// No description provided for @reminderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shape when Memora nudges you back into the next useful review block.'**
  String get reminderSubtitle;

  /// No description provided for @reminderOverviewSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder health'**
  String get reminderOverviewSectionTitle;

  /// No description provided for @reminderOverviewSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep track of how much study debt is building and whether reminder cues are active.'**
  String get reminderOverviewSectionSubtitle;

  /// No description provided for @reminderToggleTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable reminders'**
  String get reminderToggleTitle;

  /// No description provided for @reminderToggleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Turn learning reminders on when you want Memora to keep your study rhythm visible.'**
  String get reminderToggleSubtitle;

  /// No description provided for @reminderDueCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} due now'**
  String reminderDueCountLabel(int count);

  /// No description provided for @reminderOverdueCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} overdue'**
  String reminderOverdueCountLabel(int count);

  /// No description provided for @reminderActiveSlotsLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} active slots'**
  String reminderActiveSlotsLabel(int count);

  /// No description provided for @reminderFrequencySectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder cadence'**
  String get reminderFrequencySectionTitle;

  /// No description provided for @reminderFrequencySectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose whether reminders should follow every day, only weekdays, or a custom pattern.'**
  String get reminderFrequencySectionSubtitle;

  /// No description provided for @reminderFrequencyDailyLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get reminderFrequencyDailyLabel;

  /// No description provided for @reminderFrequencyWeekdaysLabel.
  ///
  /// In en, this message translates to:
  /// **'Weekdays'**
  String get reminderFrequencyWeekdaysLabel;

  /// No description provided for @reminderFrequencyCustomLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get reminderFrequencyCustomLabel;

  /// No description provided for @reminderSuggestedDeckSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Suggested next deck'**
  String get reminderSuggestedDeckSectionTitle;

  /// No description provided for @reminderSuggestedDeckSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use the reminder signal to jump directly into the branch that needs attention first.'**
  String get reminderSuggestedDeckSectionSubtitle;

  /// No description provided for @reminderSuggestedDeckMessage.
  ///
  /// In en, this message translates to:
  /// **'{dueCount} cards are due and {overdueCount} are already overdue in the suggested deck.'**
  String reminderSuggestedDeckMessage(Object dueCount, Object overdueCount);

  /// No description provided for @reminderPreviewAction.
  ///
  /// In en, this message translates to:
  /// **'Preview reminder'**
  String get reminderPreviewAction;

  /// No description provided for @reminderManageSlotsAction.
  ///
  /// In en, this message translates to:
  /// **'Manage time slots'**
  String get reminderManageSlotsAction;

  /// No description provided for @reminderTimeSlotsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder time slots'**
  String get reminderTimeSlotsTitle;

  /// No description provided for @reminderTimeSlotsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust when reminder nudges can appear during the day.'**
  String get reminderTimeSlotsSubtitle;

  /// No description provided for @reminderAddSlotAction.
  ///
  /// In en, this message translates to:
  /// **'Add slot'**
  String get reminderAddSlotAction;

  /// No description provided for @reminderCustomDaysSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom reminder days'**
  String get reminderCustomDaysSectionTitle;

  /// No description provided for @reminderCustomDaysSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick the specific days when reminders should stay active.'**
  String get reminderCustomDaysSectionSubtitle;

  /// No description provided for @reminderWeekdayMonday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get reminderWeekdayMonday;

  /// No description provided for @reminderWeekdayTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get reminderWeekdayTuesday;

  /// No description provided for @reminderWeekdayWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get reminderWeekdayWednesday;

  /// No description provided for @reminderWeekdayThursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get reminderWeekdayThursday;

  /// No description provided for @reminderWeekdayFriday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get reminderWeekdayFriday;

  /// No description provided for @reminderWeekdaySaturday.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get reminderWeekdaySaturday;

  /// No description provided for @reminderWeekdaySunday.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get reminderWeekdaySunday;

  /// No description provided for @reminderSlotMorningReviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Morning review'**
  String get reminderSlotMorningReviewLabel;

  /// No description provided for @reminderSlotEveningResetLabel.
  ///
  /// In en, this message translates to:
  /// **'Evening reset'**
  String get reminderSlotEveningResetLabel;

  /// No description provided for @reminderSlotStudyBlockLabel.
  ///
  /// In en, this message translates to:
  /// **'Study block'**
  String get reminderSlotStudyBlockLabel;

  /// No description provided for @reminderSlotEnabledLabel.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get reminderSlotEnabledLabel;

  /// No description provided for @reminderSlotPausedLabel.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get reminderSlotPausedLabel;

  /// No description provided for @reminderPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminder preview'**
  String get reminderPreviewTitle;

  /// No description provided for @reminderPreviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'See how the next notification cue would look before you save it into habit.'**
  String get reminderPreviewSubtitle;

  /// No description provided for @reminderPreviewSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Next reminder snapshot'**
  String get reminderPreviewSummaryTitle;

  /// No description provided for @reminderPreviewSummarySubtitle.
  ///
  /// In en, this message translates to:
  /// **'This preview combines your current cadence, active time slots, and suggested study deck.'**
  String get reminderPreviewSummarySubtitle;

  /// No description provided for @reminderPreviewScheduleMessage.
  ///
  /// In en, this message translates to:
  /// **'The next reminder is scheduled for {timeLabel}.'**
  String reminderPreviewScheduleMessage(Object timeLabel);

  /// No description provided for @reminderPreviewCardTitle.
  ///
  /// In en, this message translates to:
  /// **'Review {deckName} next'**
  String reminderPreviewCardTitle(Object deckName);

  /// No description provided for @reminderPreviewCardMessage.
  ///
  /// In en, this message translates to:
  /// **'{dueCount} cards are ready and {overdueCount} need urgent attention.'**
  String reminderPreviewCardMessage(Object dueCount, Object overdueCount);

  /// No description provided for @reminderOpenSuggestedDeckAction.
  ///
  /// In en, this message translates to:
  /// **'Open suggested deck'**
  String get reminderOpenSuggestedDeckAction;

  /// No description provided for @reminderBackToSettingsAction.
  ///
  /// In en, this message translates to:
  /// **'Back to settings'**
  String get reminderBackToSettingsAction;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingTitle;

  /// No description provided for @onboardingPageOrganizeTitle.
  ///
  /// In en, this message translates to:
  /// **'Organize knowledge clearly'**
  String get onboardingPageOrganizeTitle;

  /// No description provided for @onboardingPageOrganizeDescription.
  ///
  /// In en, this message translates to:
  /// **'Build a folder tree that matches the way you think about topics, courses, or daily practice.'**
  String get onboardingPageOrganizeDescription;

  /// No description provided for @onboardingPageOrganizeHighlight.
  ///
  /// In en, this message translates to:
  /// **'Start small, then grow your library one clear branch at a time.'**
  String get onboardingPageOrganizeHighlight;

  /// No description provided for @onboardingPageReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review with intent'**
  String get onboardingPageReviewTitle;

  /// No description provided for @onboardingPageReviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Move from folders to decks to flashcards without losing context or momentum.'**
  String get onboardingPageReviewDescription;

  /// No description provided for @onboardingPageReviewHighlight.
  ///
  /// In en, this message translates to:
  /// **'Keep the next useful review block visible so it is easier to begin.'**
  String get onboardingPageReviewHighlight;

  /// No description provided for @onboardingPageMomentumTitle.
  ///
  /// In en, this message translates to:
  /// **'Protect your study rhythm'**
  String get onboardingPageMomentumTitle;

  /// No description provided for @onboardingPageMomentumDescription.
  ///
  /// In en, this message translates to:
  /// **'Use reminders, streaks, and daily targets to stay consistent without overloading a single session.'**
  String get onboardingPageMomentumDescription;

  /// No description provided for @onboardingPageMomentumHighlight.
  ///
  /// In en, this message translates to:
  /// **'Short, repeatable sessions compound faster than big bursts.'**
  String get onboardingPageMomentumHighlight;

  /// No description provided for @onboardingPermissionsAction.
  ///
  /// In en, this message translates to:
  /// **'Set permissions'**
  String get onboardingPermissionsAction;

  /// No description provided for @onboardingSkipAction.
  ///
  /// In en, this message translates to:
  /// **'Skip for now'**
  String get onboardingSkipAction;

  /// No description provided for @onboardingContinueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get onboardingContinueAction;

  /// No description provided for @onboardingNextAction.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNextAction;

  /// No description provided for @onboardingPermissionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your helpful nudges'**
  String get onboardingPermissionsTitle;

  /// No description provided for @onboardingPermissionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Decide which app signals should be ready when you start building a routine.'**
  String get onboardingPermissionsSubtitle;

  /// No description provided for @onboardingPermissionNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Study reminders'**
  String get onboardingPermissionNotificationsTitle;

  /// No description provided for @onboardingPermissionNotificationsDescription.
  ///
  /// In en, this message translates to:
  /// **'Allow reminder prompts so due decks do not disappear behind a busy day.'**
  String get onboardingPermissionNotificationsDescription;

  /// No description provided for @onboardingPermissionNotificationsNote.
  ///
  /// In en, this message translates to:
  /// **'You can fine-tune the exact cadence later from reminder settings.'**
  String get onboardingPermissionNotificationsNote;

  /// No description provided for @onboardingPermissionAudioTitle.
  ///
  /// In en, this message translates to:
  /// **'Audio prompts'**
  String get onboardingPermissionAudioTitle;

  /// No description provided for @onboardingPermissionAudioDescription.
  ///
  /// In en, this message translates to:
  /// **'Keep pronunciation and listening cues ready when you begin study modes that use sound.'**
  String get onboardingPermissionAudioDescription;

  /// No description provided for @onboardingPermissionAudioNote.
  ///
  /// In en, this message translates to:
  /// **'This simply prepares the preference; you can still change it whenever you want.'**
  String get onboardingPermissionAudioNote;

  /// No description provided for @onboardingBackAction.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get onboardingBackAction;

  /// No description provided for @onboardingGoalSetupAction.
  ///
  /// In en, this message translates to:
  /// **'Set study goal'**
  String get onboardingGoalSetupAction;

  /// No description provided for @onboardingGoalSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Define your first study target'**
  String get onboardingGoalSetupTitle;

  /// No description provided for @onboardingGoalSetupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a goal profile, then adjust the card target and session length that feel sustainable.'**
  String get onboardingGoalSetupSubtitle;

  /// No description provided for @onboardingGoalSetupCompletedMessage.
  ///
  /// In en, this message translates to:
  /// **'You are set for {dailyGoal} cards per day across {sessionMinutes}-minute sessions.'**
  String onboardingGoalSetupCompletedMessage(
    Object dailyGoal,
    Object sessionMinutes,
  );

  /// No description provided for @onboardingGoalPresetSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Goal profile'**
  String get onboardingGoalPresetSectionTitle;

  /// No description provided for @onboardingGoalPresetSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose the pace that best matches your current routine.'**
  String get onboardingGoalPresetSectionSubtitle;

  /// No description provided for @onboardingGoalNumbersSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Goal details'**
  String get onboardingGoalNumbersSectionTitle;

  /// No description provided for @onboardingGoalNumbersSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Adjust the daily study volume and ideal session length.'**
  String get onboardingGoalNumbersSectionSubtitle;

  /// No description provided for @onboardingDailyGoalFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Daily card goal'**
  String get onboardingDailyGoalFieldLabel;

  /// No description provided for @onboardingSessionLengthFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Session length (minutes)'**
  String get onboardingSessionLengthFieldLabel;

  /// No description provided for @onboardingFinishAction.
  ///
  /// In en, this message translates to:
  /// **'Finish setup'**
  String get onboardingFinishAction;

  /// No description provided for @onboardingGoalSteadyLabel.
  ///
  /// In en, this message translates to:
  /// **'Steady'**
  String get onboardingGoalSteadyLabel;

  /// No description provided for @onboardingGoalFocusedLabel.
  ///
  /// In en, this message translates to:
  /// **'Focused'**
  String get onboardingGoalFocusedLabel;

  /// No description provided for @onboardingGoalIntensiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Intensive'**
  String get onboardingGoalIntensiveLabel;

  /// No description provided for @studySessionTypeFirstLearning.
  ///
  /// In en, this message translates to:
  /// **'First learning'**
  String get studySessionTypeFirstLearning;

  /// No description provided for @studySessionTypeReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get studySessionTypeReview;

  /// No description provided for @studySessionTypeFirstLearningSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Move through the full progression with more guided support and repetition.'**
  String get studySessionTypeFirstLearningSubtitle;

  /// No description provided for @studySessionTypeReviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Focus on due cards and keep the session fast, lean, and corrective.'**
  String get studySessionTypeReviewSubtitle;

  /// No description provided for @studyModeReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get studyModeReview;

  /// No description provided for @studyModeRecall.
  ///
  /// In en, this message translates to:
  /// **'Recall'**
  String get studyModeRecall;

  /// No description provided for @studyModeGuess.
  ///
  /// In en, this message translates to:
  /// **'Guess'**
  String get studyModeGuess;

  /// No description provided for @studyModeMatch.
  ///
  /// In en, this message translates to:
  /// **'Match'**
  String get studyModeMatch;

  /// No description provided for @studyModeFill.
  ///
  /// In en, this message translates to:
  /// **'Fill'**
  String get studyModeFill;

  /// No description provided for @studyModeReviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Skim quickly, make a confidence call, and keep the review queue moving.'**
  String get studyModeReviewDescription;

  /// No description provided for @studyModeRecallDescription.
  ///
  /// In en, this message translates to:
  /// **'Pause first, reveal second, then decide whether the answer was really there.'**
  String get studyModeRecallDescription;

  /// No description provided for @studyModeGuessDescription.
  ///
  /// In en, this message translates to:
  /// **'Pick from several close options to test recognition under light pressure.'**
  String get studyModeGuessDescription;

  /// No description provided for @studyModeMatchDescription.
  ///
  /// In en, this message translates to:
  /// **'Line up both sides of a concept set before confirming the whole board.'**
  String get studyModeMatchDescription;

  /// No description provided for @studyModeFillDescription.
  ///
  /// In en, this message translates to:
  /// **'Type the answer yourself so accuracy depends on recall instead of recognition.'**
  String get studyModeFillDescription;

  /// No description provided for @studyLifecycleReady.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get studyLifecycleReady;

  /// No description provided for @studyLifecycleInProgress.
  ///
  /// In en, this message translates to:
  /// **'In progress'**
  String get studyLifecycleInProgress;

  /// No description provided for @studyLifecycleFeedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback ready'**
  String get studyLifecycleFeedback;

  /// No description provided for @studyLifecycleRetryPending.
  ///
  /// In en, this message translates to:
  /// **'Retry pending'**
  String get studyLifecycleRetryPending;

  /// No description provided for @studyLifecycleCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get studyLifecycleCompleted;

  /// No description provided for @studyHistoryCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get studyHistoryCompleted;

  /// No description provided for @studyHistoryResumed.
  ///
  /// In en, this message translates to:
  /// **'Resumed'**
  String get studyHistoryResumed;

  /// No description provided for @studyHistoryInterrupted.
  ///
  /// In en, this message translates to:
  /// **'Interrupted'**
  String get studyHistoryInterrupted;

  /// No description provided for @studyAudioTitle.
  ///
  /// In en, this message translates to:
  /// **'Audio support'**
  String get studyAudioTitle;

  /// No description provided for @studyAudioSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Pronunciation support is ready with {voiceLabel}.'**
  String studyAudioSubtitle(Object voiceLabel);

  /// No description provided for @studyAudioFallbackVoice.
  ///
  /// In en, this message translates to:
  /// **'the default voice'**
  String get studyAudioFallbackVoice;

  /// No description provided for @studyAudioUnavailableMessage.
  ///
  /// In en, this message translates to:
  /// **'This item does not include speech support, so the session stays visual.'**
  String get studyAudioUnavailableMessage;

  /// No description provided for @studyAudioMuteAction.
  ///
  /// In en, this message translates to:
  /// **'Mute audio'**
  String get studyAudioMuteAction;

  /// No description provided for @studyAudioEnableAction.
  ///
  /// In en, this message translates to:
  /// **'Enable audio'**
  String get studyAudioEnableAction;

  /// No description provided for @studyAudioUnavailableAction.
  ///
  /// In en, this message translates to:
  /// **'No audio'**
  String get studyAudioUnavailableAction;

  /// No description provided for @studyExitDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave this study session?'**
  String get studyExitDialogTitle;

  /// No description provided for @studyExitConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Leave session'**
  String get studyExitConfirmAction;

  /// No description provided for @studyExitCancelAction.
  ///
  /// In en, this message translates to:
  /// **'Stay here'**
  String get studyExitCancelAction;

  /// No description provided for @studyExitDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'You can resume this session later, but any unsaved momentum in the current step may feel more abrupt when you return.'**
  String get studyExitDialogMessage;

  /// No description provided for @studyFooterTitle.
  ///
  /// In en, this message translates to:
  /// **'Session controls'**
  String get studyFooterTitle;

  /// No description provided for @studyFooterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{modeLabel} is active and the session is currently {lifecycleLabel}.'**
  String studyFooterSubtitle(Object modeLabel, Object lifecycleLabel);

  /// No description provided for @studyResetModeAction.
  ///
  /// In en, this message translates to:
  /// **'Reset current mode'**
  String get studyResetModeAction;

  /// No description provided for @studyExitAction.
  ///
  /// In en, this message translates to:
  /// **'Exit study'**
  String get studyExitAction;

  /// No description provided for @studyHeaderSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{folderLabel} · {sessionType}'**
  String studyHeaderSubtitle(Object folderLabel, Object sessionType);

  /// No description provided for @studyDueCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} due cards'**
  String studyDueCountLabel(int count);

  /// No description provided for @studyDueCountTitle.
  ///
  /// In en, this message translates to:
  /// **'Due now'**
  String get studyDueCountTitle;

  /// No description provided for @studyModeSequenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Mode sequence'**
  String get studyModeSequenceTitle;

  /// No description provided for @studyModeSequenceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Keep the whole study arc visible while you decide how to start.'**
  String get studyModeSequenceSubtitle;

  /// No description provided for @studyModeProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total}'**
  String studyModeProgressLabel(int completed, int total);

  /// No description provided for @studyProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Session progress'**
  String get studyProgressTitle;

  /// No description provided for @studyProgressSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{modeLabel} · {completedModes} of {totalModes} modes cleared'**
  String studyProgressSubtitle(
    Object modeLabel,
    int completedModes,
    int totalModes,
  );

  /// No description provided for @studyItemProgressLabel.
  ///
  /// In en, this message translates to:
  /// **'{completed} of {total} items'**
  String studyItemProgressLabel(int completed, int total);

  /// No description provided for @studyResultCompletionTitle.
  ///
  /// In en, this message translates to:
  /// **'Completion'**
  String get studyResultCompletionTitle;

  /// No description provided for @studyResultCompletionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A quick read on how much of the session made it through the full cycle.'**
  String get studyResultCompletionSubtitle;

  /// No description provided for @studyResultMasteredLabel.
  ///
  /// In en, this message translates to:
  /// **'Mastered items'**
  String get studyResultMasteredLabel;

  /// No description provided for @studyResultMasteredSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Items you moved forward without another retry pass.'**
  String get studyResultMasteredSubtitle;

  /// No description provided for @studyResultRetryLabel.
  ///
  /// In en, this message translates to:
  /// **'Retry items'**
  String get studyResultRetryLabel;

  /// No description provided for @studyResultRetrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Items that still need another look in the next block.'**
  String get studyResultRetrySubtitle;

  /// No description provided for @studyResultFocusLabel.
  ///
  /// In en, this message translates to:
  /// **'Focus time'**
  String get studyResultFocusLabel;

  /// No description provided for @studyResultFocusSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Total time budget reserved for this session shell.'**
  String get studyResultFocusSubtitle;

  /// No description provided for @studyMinutesShortLabel.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String studyMinutesShortLabel(int minutes);

  /// No description provided for @studyModePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Mode picker'**
  String get studyModePickerTitle;

  /// No description provided for @studyModePickerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Preview the mode chain before you jump into the live session.'**
  String get studyModePickerSubtitle;

  /// No description provided for @studyModePickerSelectedAction.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get studyModePickerSelectedAction;

  /// No description provided for @studyModePickerChooseAction.
  ///
  /// In en, this message translates to:
  /// **'Focus here'**
  String get studyModePickerChooseAction;

  /// No description provided for @studySetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Study setup'**
  String get studySetupTitle;

  /// No description provided for @studySetupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prime the next session, decide whether to resume, and check how the mode chain will unfold.'**
  String get studySetupSubtitle;

  /// No description provided for @studyDeckReadinessTitle.
  ///
  /// In en, this message translates to:
  /// **'Deck readiness'**
  String get studyDeckReadinessTitle;

  /// No description provided for @studyDeckReadinessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Current mastery gives a quick signal for how demanding this session should feel.'**
  String get studyDeckReadinessSubtitle;

  /// No description provided for @studySetupEstimateTitle.
  ///
  /// In en, this message translates to:
  /// **'Estimated time'**
  String get studySetupEstimateTitle;

  /// No description provided for @studySetupEstimateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A short, sustainable block for the current due queue.'**
  String get studySetupEstimateSubtitle;

  /// No description provided for @studySessionTypeSelectedAction.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get studySessionTypeSelectedAction;

  /// No description provided for @studySessionTypeChooseAction.
  ///
  /// In en, this message translates to:
  /// **'Use this flow'**
  String get studySessionTypeChooseAction;

  /// No description provided for @studyResumeTitle.
  ///
  /// In en, this message translates to:
  /// **'Resume where you stopped'**
  String get studyResumeTitle;

  /// No description provided for @studyResumeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'{modeLabel} was active with {completed} of {total} items already processed.'**
  String studyResumeSubtitle(Object modeLabel, int completed, int total);

  /// No description provided for @studyResumeAction.
  ///
  /// In en, this message translates to:
  /// **'Resume session'**
  String get studyResumeAction;

  /// No description provided for @studyStartFreshAction.
  ///
  /// In en, this message translates to:
  /// **'Start fresh'**
  String get studyStartFreshAction;

  /// No description provided for @studyHistoryPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Recent study blocks'**
  String get studyHistoryPreviewTitle;

  /// No description provided for @studyHistoryPreviewSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use the recent trail to decide whether you need repetition or a fresh pass.'**
  String get studyHistoryPreviewSubtitle;

  /// No description provided for @studyHistoryEntrySubtitle.
  ///
  /// In en, this message translates to:
  /// **'{modeLabel} · {mastered} of {total} held'**
  String studyHistoryEntrySubtitle(Object modeLabel, int mastered, int total);

  /// No description provided for @studyStartAction.
  ///
  /// In en, this message translates to:
  /// **'Prepare session'**
  String get studyStartAction;

  /// No description provided for @studyHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Study history'**
  String get studyHistoryTitle;

  /// No description provided for @studyHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Look back at recent sessions to spot where momentum is stable and where drift starts.'**
  String get studyHistorySubtitle;

  /// No description provided for @studyHistoryEntryDescription.
  ///
  /// In en, this message translates to:
  /// **'{statusLabel} · {modeLabel} · {dateLabel}'**
  String studyHistoryEntryDescription(
    Object statusLabel,
    Object modeLabel,
    Object dateLabel,
  );

  /// No description provided for @studyResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Study result'**
  String get studyResultTitle;

  /// No description provided for @studyResultSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Close the session with a compact summary before you decide what to do next.'**
  String get studyResultSubtitle;

  /// No description provided for @studyResultNextBlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Next useful move'**
  String get studyResultNextBlockTitle;

  /// No description provided for @studyResultNextBlockSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The session shell is ready to loop back into {modeLabel} if you want another pass.'**
  String studyResultNextBlockSubtitle(Object modeLabel);

  /// No description provided for @studyRestartSessionAction.
  ///
  /// In en, this message translates to:
  /// **'Restart session'**
  String get studyRestartSessionAction;

  /// No description provided for @studyReturnToDeckAction.
  ///
  /// In en, this message translates to:
  /// **'Return to deck'**
  String get studyReturnToDeckAction;

  /// No description provided for @studySessionCompletedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The current session has reached the result stage.'**
  String get studySessionCompletedSubtitle;

  /// No description provided for @studySessionCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Session completed'**
  String get studySessionCompletedTitle;

  /// No description provided for @studySessionCompletedMessage.
  ///
  /// In en, this message translates to:
  /// **'Open the result summary or leave the study flow from here.'**
  String get studySessionCompletedMessage;

  /// No description provided for @studyOpenResultAction.
  ///
  /// In en, this message translates to:
  /// **'Open result'**
  String get studyOpenResultAction;

  /// No description provided for @studyRememberedAction.
  ///
  /// In en, this message translates to:
  /// **'Remembered'**
  String get studyRememberedAction;

  /// No description provided for @studyRetryItemAction.
  ///
  /// In en, this message translates to:
  /// **'Study again'**
  String get studyRetryItemAction;

  /// No description provided for @studyNextAction.
  ///
  /// In en, this message translates to:
  /// **'Next item'**
  String get studyNextAction;

  /// No description provided for @studyFeedbackLockedInTitle.
  ///
  /// In en, this message translates to:
  /// **'Locked in'**
  String get studyFeedbackLockedInTitle;

  /// No description provided for @studyFeedbackLockedInMessage.
  ///
  /// In en, this message translates to:
  /// **'This item is ready to leave the active review queue.'**
  String get studyFeedbackLockedInMessage;

  /// No description provided for @studyFeedbackQueuedTitle.
  ///
  /// In en, this message translates to:
  /// **'Queued for another pass'**
  String get studyFeedbackQueuedTitle;

  /// No description provided for @studyFeedbackQueuedMessage.
  ///
  /// In en, this message translates to:
  /// **'This item will stay visible in the weak-memory lane.'**
  String get studyFeedbackQueuedMessage;

  /// No description provided for @studyFeedbackRevealedTitle.
  ///
  /// In en, this message translates to:
  /// **'Answer revealed'**
  String get studyFeedbackRevealedTitle;

  /// No description provided for @studyFeedbackRevealedMessage.
  ///
  /// In en, this message translates to:
  /// **'Compare what you remembered before you move on.'**
  String get studyFeedbackRevealedMessage;

  /// No description provided for @studyFeedbackGuessCorrectTitle.
  ///
  /// In en, this message translates to:
  /// **'Correct choice'**
  String get studyFeedbackGuessCorrectTitle;

  /// No description provided for @studyFeedbackGuessCorrectMessage.
  ///
  /// In en, this message translates to:
  /// **'You matched the prompt with the correct answer.'**
  String get studyFeedbackGuessCorrectMessage;

  /// No description provided for @studyFeedbackGuessIncorrectTitle.
  ///
  /// In en, this message translates to:
  /// **'Not quite'**
  String get studyFeedbackGuessIncorrectTitle;

  /// No description provided for @studyFeedbackGuessIncorrectMessage.
  ///
  /// In en, this message translates to:
  /// **'The correct answer is {answer}.'**
  String studyFeedbackGuessIncorrectMessage(Object answer);

  /// No description provided for @studyFeedbackMatchCorrectTitle.
  ///
  /// In en, this message translates to:
  /// **'Clean match'**
  String get studyFeedbackMatchCorrectTitle;

  /// No description provided for @studyFeedbackMatchCorrectMessage.
  ///
  /// In en, this message translates to:
  /// **'Every pair lines up with the prompt set.'**
  String get studyFeedbackMatchCorrectMessage;

  /// No description provided for @studyFeedbackMatchIncorrectTitle.
  ///
  /// In en, this message translates to:
  /// **'Some pairs slipped'**
  String get studyFeedbackMatchIncorrectTitle;

  /// No description provided for @studyFeedbackMatchIncorrectMessage.
  ///
  /// In en, this message translates to:
  /// **'Review the pairings once before the next board.'**
  String get studyFeedbackMatchIncorrectMessage;

  /// No description provided for @studyFeedbackExactRecallTitle.
  ///
  /// In en, this message translates to:
  /// **'Exact recall'**
  String get studyFeedbackExactRecallTitle;

  /// No description provided for @studyFeedbackExactRecallMessage.
  ///
  /// In en, this message translates to:
  /// **'You typed the full answer accurately.'**
  String get studyFeedbackExactRecallMessage;

  /// No description provided for @studyFeedbackKeepWorkingTitle.
  ///
  /// In en, this message translates to:
  /// **'Keep working this item'**
  String get studyFeedbackKeepWorkingTitle;

  /// No description provided for @studyFeedbackKeepWorkingMessage.
  ///
  /// In en, this message translates to:
  /// **'The expected answer is {answer}.'**
  String studyFeedbackKeepWorkingMessage(Object answer);

  /// No description provided for @studyCheckAnswerAction.
  ///
  /// In en, this message translates to:
  /// **'Check answer'**
  String get studyCheckAnswerAction;

  /// No description provided for @studyMatchConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm pairs'**
  String get studyMatchConfirmAction;

  /// No description provided for @studyMatchLeftColumnTitle.
  ///
  /// In en, this message translates to:
  /// **'Prompt side'**
  String get studyMatchLeftColumnTitle;

  /// No description provided for @studyMatchRightColumnTitle.
  ///
  /// In en, this message translates to:
  /// **'Meaning side'**
  String get studyMatchRightColumnTitle;

  /// No description provided for @studyMatchPairsTitle.
  ///
  /// In en, this message translates to:
  /// **'Current pairs'**
  String get studyMatchPairsTitle;

  /// No description provided for @studyMatchPairsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Remove any pair if you want to rebuild it before submitting.'**
  String get studyMatchPairsSubtitle;

  /// No description provided for @studyRevealAnswerAction.
  ///
  /// In en, this message translates to:
  /// **'Reveal answer'**
  String get studyRevealAnswerAction;

  /// No description provided for @studyRetryCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} retry'**
  String studyRetryCountLabel(int count);

  /// No description provided for @studyRecallAnswerTitle.
  ///
  /// In en, this message translates to:
  /// **'Answer revealed'**
  String get studyRecallAnswerTitle;

  /// No description provided for @studyRecallAnswerHiddenTitle.
  ///
  /// In en, this message translates to:
  /// **'Answer stays hidden'**
  String get studyRecallAnswerHiddenTitle;

  /// No description provided for @studyRecallAnswerHiddenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Try to recall it first, then reveal only when you are ready.'**
  String get studyRecallAnswerHiddenSubtitle;

  /// No description provided for @studyFillInputTitle.
  ///
  /// In en, this message translates to:
  /// **'Type your answer'**
  String get studyFillInputTitle;

  /// No description provided for @studyFillInputSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use the field below to prove the answer from memory.'**
  String get studyFillInputSubtitle;

  /// No description provided for @studyFillAnswerReveal.
  ///
  /// In en, this message translates to:
  /// **'Expected answer: {answer}'**
  String studyFillAnswerReveal(Object answer);

  /// No description provided for @studyResetModeDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset this mode?'**
  String get studyResetModeDialogTitle;

  /// No description provided for @studyResetModeDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'This clears the current mode progress and sends you back to its first item.'**
  String get studyResetModeDialogMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
