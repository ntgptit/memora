import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:memora/core/theme/app_color_scheme.dart';
import 'package:memora/core/theme/app_text_theme.dart';
import 'package:memora/core/theme/component_themes/component_themes.dart';
import 'package:memora/core/theme/app_theme_mode.dart';
import 'package:memora/core/theme/responsive/responsive_theme_factory.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';
import 'package:memora/core/theme/tokens/tokens.dart';

abstract final class AppTheme {
  static ThemeData light({required ScreenInfo screenInfo}) {
    return _build(brightness: Brightness.light, screenInfo: screenInfo);
  }

  static ThemeData dark({required ScreenInfo screenInfo}) {
    return _build(brightness: Brightness.dark, screenInfo: screenInfo);
  }

  static ThemeData resolve({
    required AppThemeMode mode,
    required ScreenInfo screenInfo,
    required Brightness platformBrightness,
  }) {
    return _build(
      brightness: mode.resolveBrightness(platformBrightness),
      screenInfo: screenInfo,
    );
  }

  static ThemeData _build({
    required Brightness brightness,
    required ScreenInfo screenInfo,
  }) {
    final baseTheme = brightness == Brightness.dark
        ? FlexThemeData.dark(
            useMaterial3: true,
            visualDensity: VisualDensity.standard,
          )
        : FlexThemeData.light(
            useMaterial3: true,
            visualDensity: VisualDensity.standard,
          );
    final colorScheme = brightness == Brightness.dark
        ? AppColorScheme.dark()
        : AppColorScheme.light();
    final dimensions = ResponsiveThemeFactory.create(screenInfo.screenClass);
    final textTheme = AppTextTheme.build(colorScheme, dimensions.typography);

    return baseTheme.copyWith(
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: AppColorTokens.background(brightness),
      appBarTheme: MemoraAppBarTheme.build(
        colorScheme: colorScheme,
        dims: dimensions,
      ),
      filledButtonTheme: MemoraButtonThemes.filled(colorScheme, dimensions),
      outlinedButtonTheme: MemoraButtonThemes.outlined(colorScheme, dimensions),
      textButtonTheme: MemoraButtonThemes.text(colorScheme, dimensions),
      inputDecorationTheme: MemoraInputTheme.build(colorScheme, dimensions),
      cardTheme: MemoraCardTheme.build(colorScheme, dimensions),
      dialogTheme: MemoraDialogTheme.build(colorScheme, dimensions),
      chipTheme: MemoraChipTheme.build(colorScheme, dimensions),
      dividerTheme: MemoraDividerTheme.build(colorScheme),
      checkboxTheme: MemoraCheckboxTheme.build(colorScheme),
      radioTheme: MemoraRadioTheme.build(colorScheme),
      switchTheme: MemoraSwitchTheme.build(colorScheme),
      sliderTheme: MemoraSliderTheme.build(colorScheme),
      progressIndicatorTheme: MemoraProgressIndicatorTheme.build(colorScheme),
      bottomSheetTheme: MemoraBottomSheetTheme.build(colorScheme, dimensions),
      navigationBarTheme: MemoraNavigationTheme.bar(
        colorScheme: colorScheme,
        dimensions: dimensions,
        textTheme: textTheme,
      ),
      navigationRailTheme: MemoraNavigationTheme.rail(
        colorScheme: colorScheme,
        dimensions: dimensions,
        textTheme: textTheme,
      ),
      extensions: ResponsiveThemeFactory.extensions(
        screenClass: screenInfo.screenClass,
        brightness: brightness,
      ),
    );
  }
}
