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
import 'package:memora/core/theme/responsive/adaptive_typography.dart';
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
    return ResponsiveThemeFactory.create(screenClass);
  }

  AdaptiveSpacing get spacing => dims.spacing;
  AdaptiveRadius get radius => dims.radius;
  AdaptiveTypography get typography => dims.typography;
  AdaptiveLayout get layout => dims.layout;

  ComponentThemeExt get componentTheme {
    return theme.extension<ComponentThemeExt>() ??
        ResponsiveThemeFactory.components(screenClass);
  }

  TextThemeExt get appTextTheme {
    return theme.extension<TextThemeExt>() ??
        ResponsiveThemeFactory.text(screenClass);
  }

  ColorSchemeExt get appColors {
    return theme.extension<ColorSchemeExt>() ??
        ResponsiveThemeFactory.colors(theme.brightness);
  }

  AdaptiveIconSize get iconSize => dims.iconSize;
  AdaptiveComponentSize get componentSize => dims.componentSize;
  AdaptiveComponentSize get component => componentSize;
}
