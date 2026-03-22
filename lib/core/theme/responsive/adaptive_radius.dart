import 'package:flutter/foundation.dart';
import 'package:memora/core/theme/responsive/responsive_scale.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';
import 'package:memora/core/theme/tokens/radius_tokens.dart';

@immutable
class AdaptiveRadius {
  const AdaptiveRadius({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.pill,
  });

  factory AdaptiveRadius.resolve(ScreenInfo screenInfo) {
    return AdaptiveRadius(
      xs: ResponsiveScale.radius(
        base: AppRadiusTokens.xs,
        screenInfo: screenInfo,
        min: 8,
        max: 12,
      ),
      sm: ResponsiveScale.radius(
        base: AppRadiusTokens.sm,
        screenInfo: screenInfo,
        min: 12,
        max: 18,
      ),
      md: ResponsiveScale.radius(
        base: AppRadiusTokens.md,
        screenInfo: screenInfo,
        min: 18,
        max: 24,
      ),
      lg: ResponsiveScale.radius(
        base: AppRadiusTokens.lg,
        screenInfo: screenInfo,
        min: 24,
        max: 32,
      ),
      xl: ResponsiveScale.radius(
        base: AppRadiusTokens.xl,
        screenInfo: screenInfo,
        min: 32,
        max: 40,
      ),
      pill: AppRadiusTokens.pill,
    );
  }

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double pill;
}
