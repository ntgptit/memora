import 'package:go_router/go_router.dart';
import 'package:memora/app/app_providers.dart';
import 'package:memora/app/app_routes.dart';
import 'package:memora/presentation/features/dashboard/screens/dashboard_screen.dart';
import 'package:memora/presentation/shared/screens/not_found_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final navigatorKey = ref.watch(rootNavigatorKeyProvider);

  final router = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.dashboard,
    routes: [
      GoRoute(
        path: AppRoutes.dashboard,
        name: AppRouteNames.dashboard,
        builder: (context, state) => const DashboardScreen(),
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
