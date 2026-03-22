import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memora/app/app_lifecycle_handler.dart';
import 'package:memora/app/app_providers.dart';
import 'package:memora/app/app_router.dart';
import 'package:memora/core/di/core_providers.dart';
import 'package:memora/core/theme/app_theme.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';
import 'package:memora/core/theme/theme_helpers.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProviderScope(child: AppLifecycleHandler(child: _AppView()));
  }
}

class _AppView extends ConsumerWidget {
  const _AppView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final envConfig = ref.watch(envConfigProvider);
    final themeType = ref.watch(themeTypeControllerProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: envConfig.appName,
      routerConfig: router,
      themeMode: ThemeHelpers.resolveThemeMode(themeType),
      theme: AppTheme.light(screenInfo: const ScreenInfo.fallback()),
      darkTheme: AppTheme.dark(screenInfo: const ScreenInfo.fallback()),
      builder: (context, child) {
        final theme = ThemeHelpers.resolveTheme(context, themeType: themeType);

        return Theme(data: theme, child: child ?? const SizedBox.shrink());
      },
    );
  }
}
