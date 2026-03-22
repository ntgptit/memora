import 'package:flutter/material.dart';
import 'package:memora/core/theme/responsive/adaptive_layout.dart';
import 'package:memora/core/theme/responsive/adaptive_radius.dart';
import 'package:memora/core/theme/responsive/adaptive_spacing.dart';

@immutable
class DimensionThemeExt extends ThemeExtension<DimensionThemeExt> {
  const DimensionThemeExt({
    required this.spacing,
    required this.radius,
    required this.layout,
  });

  final AdaptiveSpacing spacing;
  final AdaptiveRadius radius;
  final AdaptiveLayout layout;

  @override
  DimensionThemeExt copyWith({
    AdaptiveSpacing? spacing,
    AdaptiveRadius? radius,
    AdaptiveLayout? layout,
  }) {
    return DimensionThemeExt(
      spacing: spacing ?? this.spacing,
      radius: radius ?? this.radius,
      layout: layout ?? this.layout,
    );
  }

  @override
  DimensionThemeExt lerp(ThemeExtension<DimensionThemeExt>? other, double t) {
    if (other is! DimensionThemeExt) {
      return this;
    }
    return t < 0.5 ? this : other;
  }
}
