import 'package:flutter/foundation.dart';
import 'package:memora/core/theme/responsive/responsive_scale.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';
import 'package:memora/core/theme/tokens/icon_tokens.dart';

@immutable
class AdaptiveIconSize {
  const AdaptiveIconSize({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
  });

  factory AdaptiveIconSize.resolve(ScreenInfo screenInfo) {
    return AdaptiveIconSize(
      xs: ResponsiveScale.component(
        base: AppIconTokens.xs,
        screenInfo: screenInfo,
        min: 16,
        max: 18,
      ),
      sm: ResponsiveScale.component(
        base: AppIconTokens.sm,
        screenInfo: screenInfo,
        min: 18,
        max: 20,
      ),
      md: ResponsiveScale.component(
        base: AppIconTokens.md,
        screenInfo: screenInfo,
        min: 20,
        max: 22,
      ),
      lg: ResponsiveScale.component(
        base: AppIconTokens.lg,
        screenInfo: screenInfo,
        min: 24,
        max: 28,
      ),
      xl: ResponsiveScale.component(
        base: AppIconTokens.xl,
        screenInfo: screenInfo,
        min: 28,
        max: 32,
      ),
      xxl: ResponsiveScale.component(
        base: AppIconTokens.xxl,
        screenInfo: screenInfo,
        min: 36,
        max: 44,
      ),
    );
  }

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
}
