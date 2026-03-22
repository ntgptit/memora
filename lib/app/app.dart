import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memora/app/app_lifecycle_handler.dart';
import 'package:memora/app/app_providers.dart';
import 'package:memora/app/app_router.dart';
import 'package:memora/core/config/app_constants.dart';
import 'package:memora/core/config/app_duration.dart';
import 'package:memora/core/di/core_providers.dart';
import 'package:memora/core/config/env_config.dart';
import 'package:memora/core/theme/app_theme.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';
import 'package:memora/core/theme/theme_helpers.dart';

class App extends StatelessWidget {
  const App({super.key, this.container});

  final ProviderContainer? container;

  @override
  Widget build(BuildContext context) {
    final child = const AppLifecycleHandler(child: _AppView());

    if (container != null) {
      return UncontrolledProviderScope(container: container!, child: child);
    }

    return ProviderScope(child: child);
  }
}

class _AppView extends ConsumerWidget {
  const _AppView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final envConfig = ref.watch(envConfigProvider);
    final themeType = ref.watch(themeTypeControllerProvider);
    final locale = ref.watch(appLocaleProvider);
    final supportedLocales = ref.watch(supportedLocalesProvider);
    final router = ref.watch(appRouterProvider);
    final scaffoldMessengerKey = ref.watch(rootScaffoldMessengerKeyProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: envConfig.showDebugBanner,
      title: envConfig.appName,
      scaffoldMessengerKey: scaffoldMessengerKey,
      routerConfig: router,
      restorationScopeId: AppConstants.appRestorationScopeId,
      locale: locale,
      supportedLocales: supportedLocales,
      showPerformanceOverlay: envConfig.showPerformanceOverlay,
      themeMode: ThemeHelpers.resolveThemeMode(themeType),
      theme: AppTheme.light(screenInfo: const ScreenInfo.fallback()),
      darkTheme: AppTheme.dark(screenInfo: const ScreenInfo.fallback()),
      themeAnimationDuration: AppDuration.themeChange,
      themeAnimationCurve: Curves.easeInOutCubic,
      builder: (context, child) {
        final theme = ThemeHelpers.resolveTheme(context, themeType: themeType);
        final content = Theme(
          data: theme,
          child: child ?? const SizedBox.shrink(),
        );

        return _AppEnvironmentBanner(envConfig: envConfig, child: content);
      },
    );
  }
}

class _AppEnvironmentBanner extends StatelessWidget {
  const _AppEnvironmentBanner({required this.envConfig, required this.child});

  final EnvConfig envConfig;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!envConfig.showEnvironmentBanner || envConfig.isProduction) {
      return child;
    }

    return Banner(
      message: envConfig.environmentLabel,
      location: BannerLocation.topEnd,
      color: _bannerColor(envConfig.flavor),
      child: child,
    );
  }

  Color _bannerColor(AppFlavor flavor) {
    switch (flavor) {
      case AppFlavor.development:
        return Colors.green.shade700;
      case AppFlavor.staging:
        return Colors.orange.shade700;
      case AppFlavor.production:
        return Colors.blueGrey.shade700;
    }
  }
}
