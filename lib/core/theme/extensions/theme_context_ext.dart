import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/screen_context_ext.dart';
import 'package:memora/core/theme/extensions/color_scheme_ext.dart';
import 'package:memora/core/theme/extensions/component_theme_ext.dart';
import 'package:memora/core/theme/extensions/dimension_theme_ext.dart';
import 'package:memora/core/theme/extensions/text_theme_ext.dart';
import 'package:memora/core/theme/responsive/adaptive_layout.dart';
import 'package:memora/core/theme/responsive/adaptive_component_size.dart';
import 'package:memora/core/theme/responsive/adaptive_icon_size.dart';
import 'package:memora/core/theme/responsive/adaptive_radius.dart';
import 'package:memora/core/theme/responsive/adaptive_spacing.dart';
import 'package:memora/core/theme/responsive/responsive_theme_factory.dart';

extension ThemeContextExt on BuildContext {
  DimensionThemeExt get dims {
    final dimensions = Theme.of(this).extension<DimensionThemeExt>();
    if (dimensions != null) {
      return dimensions;
    }
    return ResponsiveThemeFactory.create(
      screenInfo: screenInfo,
      brightness: Theme.of(this).brightness,
    ).dimensions;
  }

  AdaptiveSpacing get spacing => dims.spacing;
  AdaptiveRadius get radius => dims.radius;
  AdaptiveLayout get layout => dims.layout;

  ComponentThemeExt get componentTheme {
    final components = Theme.of(this).extension<ComponentThemeExt>();
    if (components != null) {
      return components;
    }
    return ResponsiveThemeFactory.create(
      screenInfo: screenInfo,
      brightness: Theme.of(this).brightness,
    ).components;
  }

  TextThemeExt get appTextTheme {
    final text = Theme.of(this).extension<TextThemeExt>();
    if (text != null) {
      return text;
    }
    return ResponsiveThemeFactory.create(
      screenInfo: screenInfo,
      brightness: Theme.of(this).brightness,
    ).text;
  }

  ColorSchemeExt get appColors {
    return Theme.of(this).extension<ColorSchemeExt>() ??
        ColorSchemeExt.fromBrightness(Theme.of(this).brightness);
  }

  AdaptiveIconSize get iconSize => componentTheme.iconSize;
  AdaptiveComponentSize get componentSize => componentTheme.componentSize;
  AdaptiveComponentSize get component => componentSize;
}
