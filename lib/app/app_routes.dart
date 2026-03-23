abstract final class AppRoutes {
  static const splash = '/splash';
  static const dashboard = '/';
  static const auth = '/auth';
  static const login = '$auth/login';
  static const register = '$auth/register';
  static const forgotPassword = '$auth/forgot-password';
  static const onboarding = '/onboarding';
  static const onboardingPermissions = '$onboarding/permissions';
  static const onboardingStudyGoal = '$onboarding/study-goal';
  static const folders = '/folders';
  static const decks = '/decks';
  static const study = '/study';
  static const studySetup = '$study/setup';
  static const studySession = '$study/session';
  static const studyResult = '$study/result';
  static const studyHistory = '$study/history';
  static const studyModePicker = '$study/mode-picker';
  static const progress = '/progress';
  static const progressCalendar = '$progress/calendar';
  static const settings = '/settings';
  static const themeSettings = '$settings/theme';
  static const languageSettings = '$settings/language';
  static const audioSettings = '$settings/audio';
  static const backupRestore = '$settings/backup-restore';
  static const about = '$settings/about';
  static const reminders = '$settings/reminders';
  static const reminderTimeSlots = '$reminders/time-slots';
  static const reminderPreview = '$reminders/preview';
  static const offline = '/offline';
  static const maintenance = '/maintenance';
  static const notFound = '/not-found';

  static String folder(int folderId) => '$folders/$folderId';
  static String folderDetail(int folderId) => folder(folderId);
  static String folderDecks(int folderId) => '${folder(folderId)}/decks';
  static String deckDetail({required int folderId, required int deckId}) =>
      '${folderDecks(folderId)}/$deckId';

  static String deckProgress(int deckId) => '$progress/decks/$deckId';

  static const all = <String>{
    splash,
    dashboard,
    auth,
    login,
    register,
    forgotPassword,
    onboarding,
    onboardingPermissions,
    onboardingStudyGoal,
    folders,
    decks,
    study,
    studySetup,
    studySession,
    studyResult,
    studyHistory,
    studyModePicker,
    progress,
    progressCalendar,
    settings,
    themeSettings,
    languageSettings,
    audioSettings,
    backupRestore,
    about,
    reminders,
    reminderTimeSlots,
    reminderPreview,
    offline,
    maintenance,
    notFound,
  };
}

abstract final class AppRouteNames {
  static const splash = 'splash';
  static const dashboard = 'dashboard';
  static const auth = 'auth';
  static const login = 'login';
  static const register = 'register';
  static const forgotPassword = 'forgot_password';
  static const onboarding = 'onboarding';
  static const onboardingPermissions = 'onboarding_permissions';
  static const onboardingStudyGoal = 'onboarding_study_goal';
  static const folders = 'folders';
  static const decks = 'decks';
  static const folderDetailRoute = 'folder_detail';
  static const folderDecksRoute = 'folder_decks';
  static const deckDetailRoute = 'deck_detail';
  static const study = 'study';
  static const studySetup = 'study_setup';
  static const studySession = 'study_session';
  static const studyResult = 'study_result';
  static const studyHistory = 'study_history';
  static const studyModePicker = 'study_mode_picker';
  static const progress = 'progress';
  static const deckProgress = 'deck_progress';
  static const progressCalendar = 'progress_calendar';
  static const settings = 'settings';
  static const themeSettings = 'theme_settings';
  static const languageSettings = 'language_settings';
  static const audioSettings = 'audio_settings';
  static const backupRestore = 'backup_restore';
  static const about = 'about';
  static const reminders = 'reminders';
  static const reminderTimeSlots = 'reminder_time_slots';
  static const reminderPreview = 'reminder_preview';
  static const offline = 'offline';
  static const maintenance = 'maintenance';
  static const notFound = 'not_found';
}
