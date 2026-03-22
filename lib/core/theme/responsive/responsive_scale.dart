import 'package:memora/core/theme/responsive/screen_class.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';

abstract final class ResponsiveScale {
  static double factor(
    ScreenInfo screenInfo, {
    double compact = 1.0,
    double medium = 1.08,
    double expanded = 1.14,
    double large = 1.2,
    double landscapeBoost = 0.0,
  }) {
    final base = switch (screenInfo.screenClass) {
      ScreenClass.compact => compact,
      ScreenClass.medium => medium,
      ScreenClass.expanded => expanded,
      ScreenClass.large => large,
    };

    if (!screenInfo.isLandscape) {
      return base;
    }

    return base + landscapeBoost;
  }

  static double bounded({
    required double base,
    required ScreenInfo screenInfo,
    required double min,
    required double max,
    double compactFactor = 1.0,
    double mediumFactor = 1.08,
    double expandedFactor = 1.14,
    double largeFactor = 1.2,
    double landscapeBoost = 0.0,
  }) {
    final scale = factor(
      screenInfo,
      compact: compactFactor,
      medium: mediumFactor,
      expanded: expandedFactor,
      large: largeFactor,
      landscapeBoost: landscapeBoost,
    );

    final value = base * scale;
    if (value < min) {
      return min;
    }
    if (value > max) {
      return max;
    }
    return value;
  }

  static double spacing({
    required double base,
    required ScreenInfo screenInfo,
    required double min,
    required double max,
  }) {
    return bounded(
      base: base,
      screenInfo: screenInfo,
      min: min,
      max: max,
      mediumFactor: 1.06,
      expandedFactor: 1.14,
      largeFactor: 1.2,
      landscapeBoost: 0.02,
    );
  }

  static double radius({
    required double base,
    required ScreenInfo screenInfo,
    required double min,
    required double max,
  }) {
    return bounded(
      base: base,
      screenInfo: screenInfo,
      min: min,
      max: max,
      mediumFactor: 1.04,
      expandedFactor: 1.12,
      largeFactor: 1.18,
    );
  }

  static double typography({
    required double base,
    required ScreenInfo screenInfo,
    required double min,
    required double max,
  }) {
    return bounded(
      base: base,
      screenInfo: screenInfo,
      min: min,
      max: max,
      mediumFactor: 1.05,
      expandedFactor: 1.12,
      largeFactor: 1.18,
      landscapeBoost: 0.02,
    );
  }

  static double component({
    required double base,
    required ScreenInfo screenInfo,
    required double min,
    required double max,
  }) {
    return bounded(
      base: base,
      screenInfo: screenInfo,
      min: min,
      max: max,
      mediumFactor: 1.03,
      expandedFactor: 1.08,
      largeFactor: 1.12,
    );
  }
}
