import 'package:flutter/foundation.dart';
import 'package:memora/core/theme/responsive/responsive_scale.dart';
import 'package:memora/core/theme/responsive/screen_class.dart';
import 'package:memora/core/theme/tokens/radius_tokens.dart';

@immutable
class AdaptiveRadius {
  const AdaptiveRadius({
    required this.sm,
    required this.md,
    required this.lg,
    required this.pill,
  });

  factory AdaptiveRadius.resolve(ScreenClass screenClass) {
    return AdaptiveRadius(
      sm: ResponsiveScale.bounded(
        base: AppRadiusTokens.sm,
        screenClass: screenClass,
        min: 12,
        max: 18,
      ),
      md: ResponsiveScale.bounded(
        base: AppRadiusTokens.md,
        screenClass: screenClass,
        min: 18,
        max: 24,
      ),
      lg: ResponsiveScale.bounded(
        base: AppRadiusTokens.lg,
        screenClass: screenClass,
        min: 24,
        max: 32,
      ),
      pill: AppRadiusTokens.pill,
    );
  }

  final double sm;
  final double md;
  final double lg;
  final double pill;
}
