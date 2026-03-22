import 'package:go_router/go_router.dart';
import 'package:memora/app/app_shell.dart';
import 'package:memora/app/app_routes.dart';
import 'package:memora/core/di/core_providers.dart';
import 'package:memora/presentation/features/dashboard/screens/dashboard_screen.dart';
import 'package:memora/presentation/features/deck/screens/deck_list_screen.dart';
import 'package:memora/presentation/features/folder/screens/folder_list_screen.dart';
import 'package:memora/presentation/features/progress/screens/learning_progress_screen.dart';
import 'package:memora/presentation/features/settings/screens/settings_screen.dart';
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
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                name: AppRouteNames.settings,
                builder: (context, state) => const SettingsScreen(),
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
