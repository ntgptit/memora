import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:memora/core/config/app_keys.dart';
import 'package:memora/core/enums/app_theme_type.dart';

part 'app_providers.g.dart';

@Riverpod(keepAlive: true)
GlobalKey<NavigatorState> rootNavigatorKey(Ref ref) {
  return GlobalKey<NavigatorState>(debugLabel: AppKeys.rootNavigatorKeyLabel);
}

@Riverpod(keepAlive: true)
GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey(Ref ref) {
  return GlobalKey<ScaffoldMessengerState>(
    debugLabel: AppKeys.rootScaffoldMessengerKeyLabel,
  );
}

@Riverpod(keepAlive: true)
class ThemeTypeController extends _$ThemeTypeController {
  @override
  AppThemeType build() {
    return AppThemeType.system;
  }

  void setTheme(AppThemeType themeType) {
    state = themeType;
  }
}

@Riverpod(keepAlive: true)
class LifecycleStateController extends _$LifecycleStateController {
  @override
  AppLifecycleState? build() {
    return null;
  }

  void setLifecycle(AppLifecycleState lifecycleState) {
    state = lifecycleState;
  }
}
