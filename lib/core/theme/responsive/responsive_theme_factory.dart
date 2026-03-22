import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/color_scheme_ext.dart';
import 'package:memora/core/theme/extensions/component_theme_ext.dart';
import 'package:memora/core/theme/extensions/dimension_theme_ext.dart';
import 'package:memora/core/theme/extensions/text_theme_ext.dart';
import 'package:memora/core/theme/responsive/adaptive_layout.dart';
import 'package:memora/core/theme/responsive/adaptive_radius.dart';
import 'package:memora/core/theme/responsive/adaptive_spacing.dart';
import 'package:memora/core/theme/responsive/adaptive_typography.dart';
import 'package:memora/core/theme/responsive/adaptive_component_size.dart';
import 'package:memora/core/theme/responsive/adaptive_icon_size.dart';
import 'package:memora/core/theme/responsive/screen_class.dart';

abstract final class ResponsiveThemeFactory {
  static DimensionThemeExt create(ScreenClass screenClass) {
    return DimensionThemeExt(
      spacing: AdaptiveSpacing.fromScreen(screenClass),
      radius: AdaptiveRadius.fromScreen(screenClass),
      typography: AdaptiveTypography.fromScreen(screenClass),
      iconSize: AdaptiveIconSize.fromScreen(screenClass),
      componentSize: AdaptiveComponentSize.fromScreen(screenClass),
      layout: AdaptiveLayout.fromScreen(screenClass),
    );
  }

  static TextThemeExt text(ScreenClass screenClass) {
    return TextThemeExt(typography: AdaptiveTypography.fromScreen(screenClass));
  }

  static ComponentThemeExt components(ScreenClass screenClass) {
    return ComponentThemeExt(
      iconSize: AdaptiveIconSize.fromScreen(screenClass),
      componentSize: AdaptiveComponentSize.fromScreen(screenClass),
    );
  }

  static List<ThemeExtension<dynamic>> extensions({
    required ScreenClass screenClass,
    Brightness brightness = Brightness.light,
  }) {
    return [
      create(screenClass),
      text(screenClass),
      components(screenClass),
      ColorSchemeExt.fromBrightness(brightness),
    ];
  }

  static ColorSchemeExt colors(Brightness brightness) {
    return ColorSchemeExt.fromBrightness(brightness);
  }
}
