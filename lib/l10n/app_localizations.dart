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
