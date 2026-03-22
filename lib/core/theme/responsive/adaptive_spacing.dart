import 'package:flutter/foundation.dart';
import 'package:memora/core/theme/responsive/responsive_scale.dart';
import 'package:memora/core/theme/responsive/screen_class.dart';
import 'package:memora/core/theme/tokens/spacing_tokens.dart';

@immutable
class AdaptiveSpacing {
  const AdaptiveSpacing({
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
  });

  factory AdaptiveSpacing.resolve(ScreenClass screenClass) {
    return AdaptiveSpacing(
      xxs: ResponsiveScale.bounded(
        base: AppSpacingTokens.xxs,
        screenClass: screenClass,
        min: 4,
        max: 6,
      ),
      xs: ResponsiveScale.bounded(
        base: AppSpacingTokens.xs,
        screenClass: screenClass,
        min: 8,
        max: 12,
      ),
      sm: ResponsiveScale.bounded(
        base: AppSpacingTokens.sm,
        screenClass: screenClass,
        min: 12,
        max: 16,
      ),
      md: ResponsiveScale.bounded(
        base: AppSpacingTokens.md,
        screenClass: screenClass,
        min: 16,
        max: 24,
      ),
      lg: ResponsiveScale.bounded(
        base: AppSpacingTokens.lg,
        screenClass: screenClass,
        min: 24,
        max: 32,
      ),
      xl: ResponsiveScale.bounded(
        base: AppSpacingTokens.xl,
        screenClass: screenClass,
        min: 32,
        max: 48,
      ),
      xxl: ResponsiveScale.bounded(
        base: AppSpacingTokens.xxl,
        screenClass: screenClass,
        min: 48,
        max: 72,
      ),
    );
  }

  final double xxs;
  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
}
