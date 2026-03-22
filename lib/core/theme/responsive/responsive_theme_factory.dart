import 'package:flutter/foundation.dart';
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

  List<Object> asList() {
    return [dimensions, components, text, colors];
  }
}

abstract final class ResponsiveThemeFactory {
  static ResponsiveThemeBundle create({required ScreenInfo screenInfo}) {
    final typography = AdaptiveTypography.resolve(screenInfo.screenClass);

    return ResponsiveThemeBundle(
      dimensions: DimensionThemeExt(
        spacing: AdaptiveSpacing.resolve(screenInfo.screenClass),
        radius: AdaptiveRadius.resolve(screenInfo.screenClass),
        layout: AdaptiveLayout.resolve(screenInfo.screenClass),
      ),
      components: ComponentThemeExt(
        iconSize: AdaptiveIconSize.resolve(screenInfo.screenClass),
        componentSize: AdaptiveComponentSize.resolve(screenInfo.screenClass),
      ),
      text: TextThemeExt(typography: typography),
      colors: ColorSchemeExt.fallback(),
    );
  }
}
