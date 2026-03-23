import 'package:go_router/go_router.dart';
import 'package:memora/app/app_shell.dart';
import 'package:memora/app/app_routes.dart';
import 'package:memora/core/di/core_providers.dart';
import 'package:memora/presentation/features/deck/screens/deck_detail_screen.dart';
import 'package:memora/presentation/features/deck/screens/deck_list_screen.dart';
import 'package:memora/presentation/features/dashboard/screens/dashboard_screen.dart';
import 'package:memora/presentation/features/folder/screens/folder_list_screen.dart';
import 'package:memora/presentation/features/progress/screens/deck_progress_screen.dart';
import 'package:memora/presentation/features/progress/screens/learning_progress_screen.dart';
import 'package:memora/presentation/features/progress/screens/study_calendar_screen.dart';
import 'package:memora/presentation/features/settings/screens/about_screen.dart';
import 'package:memora/presentation/features/settings/screens/audio_settings_screen.dart';
import 'package:memora/presentation/features/settings/screens/backup_restore_screen.dart';
import 'package:memora/presentation/features/settings/screens/language_settings_screen.dart';
import 'package:memora/presentation/features/settings/screens/settings_screen.dart';
import 'package:memora/presentation/features/settings/screens/theme_settings_screen.dart';
import 'package:memora/presentation/shared/screens/maintenance_screen.dart';
import 'package:memora/presentation/shared/screens/not_found_screen.dart';
import 'package:memora/presentation/shared/screens/offline_screen.dart';
import 'package:memora/presentation/shared/screens/splash_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final envConfig = ref.watch(envConfigProvider);
  final navigatorKey = ref.watch(rootNavigatorKeyProvider);

  final router = GoRouter(
    navigatorKey: navigatorKey,
    debugLogDiagnostics: envConfig.enableRouterLogs,
    initialLocation: AppRoutes.dashboard,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                name: AppRouteNames.dashboard,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.folders,
                name: AppRouteNames.folders,
                builder: (context, state) => const FolderListScreen(),
                routes: [
                  GoRoute(
                    path: ':folderId',
                    name: AppRouteNames.folderDetailRoute,
                    builder: (context, state) {
                      final folderId = _parseId(
                        state.pathParameters['folderId'],
                      );
                      return FolderListScreen(folderId: folderId);
                    },
                    routes: [
                      GoRoute(
                        path: 'decks',
                        name: AppRouteNames.folderDecksRoute,
                        builder: (context, state) {
                          final folderId = _parseId(
                            state.pathParameters['folderId'],
                          );
                          return DeckListScreen(folderId: folderId);
                        },
                        routes: [
                          GoRoute(
                            path: ':deckId',
                            name: AppRouteNames.deckDetailRoute,
                            builder: (context, state) {
                              final folderId = _parseId(
                                state.pathParameters['folderId'],
                              );
                              final deckId = _parseId(
                                state.pathParameters['deckId'],
                              );
                              return DeckDetailScreen(
                                folderId: folderId,
                                deckId: deckId,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.decks,
                name: AppRouteNames.decks,
                builder: (context, state) => const DeckListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.progress,
                name: AppRouteNames.progress,
                builder: (context, state) => const LearningProgressScreen(),
                routes: [
                  GoRoute(
                    path: 'calendar',
                    name: AppRouteNames.progressCalendar,
                    builder: (context, state) => const StudyCalendarScreen(),
                  ),
                  GoRoute(
                    path: 'decks/:deckId',
                    name: AppRouteNames.deckProgress,
                    builder: (context, state) {
                      final deckId = _parseId(state.pathParameters['deckId']);
                      return DeckProgressScreen(deckId: deckId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                name: AppRouteNames.settings,
                builder: (context, state) => const SettingsScreen(),
                routes: [
                  GoRoute(
                    path: 'theme',
                    name: AppRouteNames.themeSettings,
                    builder: (context, state) => const ThemeSettingsScreen(),
                  ),
                  GoRoute(
                    path: 'language',
                    name: AppRouteNames.languageSettings,
                    builder: (context, state) => const LanguageSettingsScreen(),
                  ),
                  GoRoute(
                    path: 'audio',
                    name: AppRouteNames.audioSettings,
                    builder: (context, state) => const AudioSettingsScreen(),
                  ),
                  GoRoute(
                    path: 'backup-restore',
                    name: AppRouteNames.backupRestore,
                    builder: (context, state) => const BackupRestoreScreen(),
                  ),
                  GoRoute(
                    path: 'about',
                    name: AppRouteNames.about,
                    builder: (context, state) => const AboutScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.offline,
        name: AppRouteNames.offline,
        builder: (context, state) => const OfflineScreen(),
      ),
      GoRoute(
        path: AppRoutes.maintenance,
        name: AppRouteNames.maintenance,
        builder: (context, state) => const MaintenanceScreen(),
      ),
      GoRoute(
        path: AppRoutes.notFound,
        name: AppRouteNames.notFound,
        builder: (context, state) => const NotFoundScreen(),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );

  ref.onDispose(router.dispose);
  return router;
}

int _parseId(String? value) {
  final parsed = int.tryParse(value ?? '');
  if (parsed != null) {
    return parsed;
  }
  throw const FormatException('Invalid route identifier');
}
