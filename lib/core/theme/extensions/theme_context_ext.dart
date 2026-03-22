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
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;

  DimensionThemeExt get dims {
    final dimensions = theme.extension<DimensionThemeExt>();
    if (dimensions != null) {
      return dimensions;
    }
    return ResponsiveThemeFactory.create(
      screenInfo: screenInfo,
      brightness: theme.brightness,
    ).dimensions;
  }

  AdaptiveSpacing get spacing => dims.spacing;
  AdaptiveRadius get radius => dims.radius;
  AdaptiveLayout get layout => dims.layout;

  ComponentThemeExt get componentTheme {
    final components = theme.extension<ComponentThemeExt>();
    if (components != null) {
      return components;
    }
    return ResponsiveThemeFactory.create(
      screenInfo: screenInfo,
      brightness: theme.brightness,
    ).components;
  }

  TextThemeExt get appTextTheme {
    final text = theme.extension<TextThemeExt>();
    if (text != null) {
      return text;
    }
    return ResponsiveThemeFactory.create(
      screenInfo: screenInfo,
      brightness: theme.brightness,
    ).text;
  }

  ColorSchemeExt get appColors {
    return theme.extension<ColorSchemeExt>() ??
        ColorSchemeExt.fromBrightness(theme.brightness);
  }

  AdaptiveIconSize get iconSize => componentTheme.iconSize;
  AdaptiveComponentSize get componentSize => componentTheme.componentSize;
  AdaptiveComponentSize get component => componentSize;
}
