import 'package:flutter/foundation.dart';
import 'package:memora/core/theme/responsive/responsive_scale.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';
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
    required this.xxxl,
    required this.section,
    required this.gutter,
    required this.gridGap,
  });

  factory AdaptiveSpacing.resolve(ScreenInfo screenInfo) {
    return AdaptiveSpacing(
      xxs: ResponsiveScale.spacing(
        base: AppSpacingTokens.xxs,
        screenInfo: screenInfo,
        min: 4,
        max: 6,
      ),
      xs: ResponsiveScale.spacing(
        base: AppSpacingTokens.xs,
        screenInfo: screenInfo,
        min: 8,
        max: 12,
      ),
      sm: ResponsiveScale.spacing(
        base: AppSpacingTokens.sm,
        screenInfo: screenInfo,
        min: 12,
        max: 16,
      ),
      md: ResponsiveScale.spacing(
        base: AppSpacingTokens.md,
        screenInfo: screenInfo,
        min: 16,
        max: 24,
      ),
      lg: ResponsiveScale.spacing(
        base: AppSpacingTokens.lg,
        screenInfo: screenInfo,
        min: 24,
        max: 32,
      ),
      xl: ResponsiveScale.spacing(
        base: AppSpacingTokens.xl,
        screenInfo: screenInfo,
        min: 32,
        max: 48,
      ),
      xxl: ResponsiveScale.spacing(
        base: AppSpacingTokens.xxl,
        screenInfo: screenInfo,
        min: 48,
        max: 72,
      ),
      xxxl: ResponsiveScale.spacing(
        base: AppSpacingTokens.xxxl,
        screenInfo: screenInfo,
        min: 64,
        max: 96,
      ),
      section: ResponsiveScale.spacing(
        base: AppSpacingTokens.section,
        screenInfo: screenInfo,
        min: 24,
        max: 40,
      ),
      gutter: ResponsiveScale.spacing(
        base: AppSpacingTokens.gutter,
        screenInfo: screenInfo,
        min: 20,
        max: 40,
      ),
      gridGap: ResponsiveScale.spacing(
        base: AppSpacingTokens.gridGap,
        screenInfo: screenInfo,
        min: 16,
        max: 28,
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
  final double xxxl;
  final double section;
  final double gutter;
  final double gridGap;
}
