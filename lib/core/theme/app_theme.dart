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
import 'package:memora/core/theme/responsive/responsive_theme_factory.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';

abstract final class AppTheme {
  static ThemeData light({required ScreenInfo screenInfo}) {
    return _build(brightness: Brightness.light, screenInfo: screenInfo);
  }

  static ThemeData dark({required ScreenInfo screenInfo}) {
    return _build(brightness: Brightness.dark, screenInfo: screenInfo);
  }

  static ThemeData _build({
    required Brightness brightness,
    required ScreenInfo screenInfo,
  }) {
    final colorScheme = AppColorScheme.build(brightness);
    final bundle = ResponsiveThemeFactory.create(screenInfo: screenInfo);
    final dimensions = bundle.dimensions;
    final components = bundle.components;
    final text = bundle.text;
    final textTheme = AppTextTheme.build(colorScheme, text.typography);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: MemoraAppBarTheme.build(
        colorScheme: colorScheme,
        dims: dimensions,
        text: text,
      ),
      filledButtonTheme: MemoraButtonThemes.filled(
        colorScheme,
        dimensions,
        components,
      ),
      outlinedButtonTheme: MemoraButtonThemes.outlined(
        colorScheme,
        dimensions,
        components,
      ),
      textButtonTheme: MemoraButtonThemes.text(colorScheme, dimensions),
      inputDecorationTheme: MemoraInputTheme.build(
        colorScheme,
        dimensions,
        components,
      ),
      cardTheme: MemoraCardTheme.build(colorScheme, dimensions),
      dialogTheme: MemoraDialogTheme.build(colorScheme, dimensions, components),
      chipTheme: MemoraChipTheme.build(colorScheme, dimensions, components),
      dividerTheme: MemoraDividerTheme.build(colorScheme),
      checkboxTheme: MemoraCheckboxTheme.build(colorScheme),
      radioTheme: MemoraRadioTheme.build(colorScheme),
      switchTheme: MemoraSwitchTheme.build(colorScheme),
      sliderTheme: MemoraSliderTheme.build(colorScheme),
      progressIndicatorTheme: MemoraProgressIndicatorTheme.build(colorScheme),
      bottomSheetTheme: MemoraBottomSheetTheme.build(colorScheme, dimensions),
      extensions: <ThemeExtension<dynamic>>[
        dimensions,
        components,
        text,
        bundle.colors,
      ],
    );
  }
}
