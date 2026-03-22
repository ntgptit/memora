import 'package:flutter/material.dart';
import 'package:memora/core/enums/app_theme_type.dart';
import 'package:memora/core/theme/app_theme.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';

abstract final class ThemeHelpers {
  static ScreenInfo screenInfoOf(BuildContext context) {
    return ScreenInfo.fromContext(context);
  }

  static ThemeMode resolveThemeMode(AppThemeType themeType) {
    switch (themeType) {
      case AppThemeType.system:
        return ThemeMode.system;
      case AppThemeType.light:
        return ThemeMode.light;
      case AppThemeType.dark:
        return ThemeMode.dark;
    }
  }

  static Brightness resolveBrightness(
    BuildContext context, {
    required AppThemeType themeType,
  }) {
    switch (themeType) {
      case AppThemeType.light:
        return Brightness.light;
      case AppThemeType.dark:
        return Brightness.dark;
      case AppThemeType.system:
        return MediaQuery.platformBrightnessOf(context);
    }
  }

  static ThemeData resolveTheme(
    BuildContext context, {
    required AppThemeType themeType,
  }) {
    final brightness = resolveBrightness(context, themeType: themeType);
    final screenInfo = screenInfoOf(context);

    if (brightness == Brightness.dark) {
      return AppTheme.dark(screenInfo: screenInfo);
    }

    return AppTheme.light(screenInfo: screenInfo);
  }
}
