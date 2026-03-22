import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:memora/core/theme/app_color_scheme.dart';
import 'package:memora/core/theme/app_text_theme.dart';
import 'package:memora/core/theme/component_themes/app_bar_theme.dart';
import 'package:memora/core/theme/component_themes/bottom_sheet_theme.dart';
import 'package:memora/core/theme/component_themes/button_theme.dart';
import 'package:memora/core/theme/component_themes/card_theme.dart';
import 'package:memora/core/theme/component_themes/checkbox_theme.dart';
import 'package:memora/core/theme/component_themes/chip_theme.dart';
import 'package:memora/core/theme/component_themes/dialog_theme.dart';
import 'package:memora/core/theme/component_themes/divider_theme.dart';
import 'package:memora/core/theme/component_themes/input_theme.dart';
import 'package:memora/core/theme/component_themes/progress_indicator_theme.dart';
import 'package:memora/core/theme/component_themes/radio_theme.dart';
import 'package:memora/core/theme/component_themes/slider_theme.dart';
import 'package:memora/core/theme/component_themes/switch_theme.dart';
import 'package:memora/core/theme/extensions/dimension_theme_ext.dart';
import 'package:memora/core/theme/app_theme_mode.dart';
import 'package:memora/core/theme/responsive/responsive_theme_factory.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';
import 'package:memora/core/theme/tokens/color_tokens.dart';

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
      navigationBarTheme: _navigationBarTheme(
        colorScheme: colorScheme,
        dimensions: dimensions,
        textTheme: textTheme,
      ),
      navigationRailTheme: _navigationRailTheme(
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

  static NavigationBarThemeData _navigationBarTheme({
    required ColorScheme colorScheme,
    required DimensionThemeExt dimensions,
    required TextTheme textTheme,
  }) {
    return NavigationBarThemeData(
      height: dimensions.componentSize.bottomBarHeight,
      backgroundColor: colorScheme.surface,
      indicatorColor: colorScheme.secondaryContainer,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final isSelected = states.contains(WidgetState.selected);
        return textTheme.labelMedium?.copyWith(
          color: isSelected
              ? colorScheme.onSurface
              : colorScheme.onSurfaceVariant,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final isSelected = states.contains(WidgetState.selected);
        return IconThemeData(
          size: dimensions.iconSize.lg,
          color: isSelected
              ? colorScheme.onSecondaryContainer
              : colorScheme.onSurfaceVariant,
        );
      }),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    );
  }

  static NavigationRailThemeData _navigationRailTheme({
    required ColorScheme colorScheme,
    required DimensionThemeExt dimensions,
    required TextTheme textTheme,
  }) {
    return NavigationRailThemeData(
      backgroundColor: colorScheme.surface,
      indicatorColor: colorScheme.secondaryContainer,
      minWidth: dimensions.componentSize.navigationRailWidth,
      minExtendedWidth: dimensions.componentSize.navigationRailWidth * 2.75,
      selectedIconTheme: IconThemeData(
        size: dimensions.iconSize.lg,
        color: colorScheme.onSecondaryContainer,
      ),
      unselectedIconTheme: IconThemeData(
        size: dimensions.iconSize.lg,
        color: colorScheme.onSurfaceVariant,
      ),
      selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
        color: colorScheme.onSurface,
      ),
      unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      useIndicator: true,
    );
  }
}
