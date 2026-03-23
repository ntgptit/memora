import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:memora/core/theme/tokens/tokens.dart';

abstract final class AppColorScheme {
  static const FlexSchemeColor _lightFlexColors = FlexSchemeColor(
    primary: AppColorTokens.primary,
    primaryContainer: AppColorTokens.primaryContainer,
    secondary: AppColorTokens.secondary,
    secondaryContainer: AppColorTokens.secondaryContainer,
    tertiary: AppColorTokens.tertiary,
    tertiaryContainer: AppColorTokens.tertiaryContainer,
  );

  static const FlexSchemeColor _darkFlexColors = FlexSchemeColor(
    primary: Color(0xFF8ED6CC),
    primaryContainer: Color(0xFF175852),
    primaryLightRef: AppColorTokens.primary,
    secondary: Color(0xFFF7B17A),
    secondaryContainer: Color(0xFF703B0C),
    secondaryLightRef: AppColorTokens.secondary,
    tertiary: Color(0xFF93C9F5),
    tertiaryContainer: Color(0xFF1C4D6D),
    tertiaryLightRef: AppColorTokens.tertiary,
  );

  static ColorScheme light() {
    return _applySurfaceTokens(
      _materialScheme(Brightness.light),
      brightness: Brightness.light,
    );
  }

  static ColorScheme dark() {
    return _applySurfaceTokens(
      _materialScheme(Brightness.dark),
      brightness: Brightness.dark,
    );
  }

  static ColorScheme build(Brightness brightness) {
    return brightness == Brightness.dark ? dark() : light();
  }

  static ColorScheme _materialScheme(Brightness brightness) {
    final theme = brightness == Brightness.dark
        ? FlexThemeData.dark(
            useMaterial3: true,
            colors: _darkFlexColors,
            visualDensity: VisualDensity.standard,
          )
        : FlexThemeData.light(
            useMaterial3: true,
            colors: _lightFlexColors,
            visualDensity: VisualDensity.standard,
          );

    return theme.colorScheme;
  }

  static ColorScheme _applySurfaceTokens(
    ColorScheme scheme, {
    required Brightness brightness,
  }) {
    if (brightness == Brightness.dark) {
      return scheme.copyWith(
        surface: AppColorTokens.darkSurface,
        surfaceContainerLowest: AppColorTokens.darkSurface,
        surfaceContainerLow: AppColorTokens.darkSurfaceContainerLow,
        surfaceContainer: AppColorTokens.darkSurfaceContainer,
        surfaceContainerHigh: AppColorTokens.darkSurfaceContainerHigh,
        surfaceContainerHighest: AppColorTokens.darkSurfaceContainerHighest,
        outline: AppColorTokens.darkOutline,
        outlineVariant: AppColorTokens.darkOutline.withAlpha(160),
      );
    }

    return scheme.copyWith(
      surface: AppColorTokens.lightSurface,
      surfaceContainerLowest: AppColorTokens.lightSurface,
      surfaceContainerLow: AppColorTokens.lightSurfaceContainerLow,
      surfaceContainer: AppColorTokens.lightSurfaceContainer,
      surfaceContainerHigh: AppColorTokens.lightSurfaceContainerHigh,
      surfaceContainerHighest: AppColorTokens.lightSurfaceContainerHighest,
      outline: AppColorTokens.lightOutline,
      outlineVariant: AppColorTokens.lightOutline.withAlpha(160),
    );
  }
}
