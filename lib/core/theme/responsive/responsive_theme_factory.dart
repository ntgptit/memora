import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/color_scheme_ext.dart';
import 'package:memora/core/theme/extensions/component_theme_ext.dart';
import 'package:memora/core/theme/extensions/dimension_theme_ext.dart';
import 'package:memora/core/theme/extensions/text_theme_ext.dart';
import 'package:memora/core/theme/responsive/adaptive_component_size.dart';
import 'package:memora/core/theme/responsive/adaptive_icon_size.dart';
import 'package:memora/core/theme/responsive/adaptive_layout.dart';
import 'package:memora/core/theme/responsive/adaptive_radius.dart';
import 'package:memora/core/theme/responsive/adaptive_spacing.dart';
import 'package:memora/core/theme/responsive/adaptive_typography.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';

@immutable
class ResponsiveThemeBundle {
  const ResponsiveThemeBundle({
    required this.dimensions,
    required this.components,
    required this.text,
    required this.colors,
  });

  final DimensionThemeExt dimensions;
  final ComponentThemeExt components;
  final TextThemeExt text;
  final ColorSchemeExt colors;

  List<ThemeExtension<dynamic>> asList() {
    return [dimensions, components, text, colors];
  }
}

abstract final class ResponsiveThemeFactory {
  static ResponsiveThemeBundle create({
    required ScreenInfo screenInfo,
    Brightness brightness = Brightness.light,
  }) {
    final typography = AdaptiveTypography.resolve(screenInfo);

    return ResponsiveThemeBundle(
      dimensions: DimensionThemeExt(
        spacing: AdaptiveSpacing.resolve(screenInfo),
        radius: AdaptiveRadius.resolve(screenInfo),
        layout: AdaptiveLayout.resolve(screenInfo),
      ),
      components: ComponentThemeExt(
        iconSize: AdaptiveIconSize.resolve(screenInfo),
        componentSize: AdaptiveComponentSize.resolve(screenInfo),
      ),
      text: TextThemeExt(typography: typography),
      colors: ColorSchemeExt.fromBrightness(brightness),
    );
  }
}
