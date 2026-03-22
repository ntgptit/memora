import 'package:flutter/foundation.dart';
import 'package:memora/core/theme/responsive/responsive_scale.dart';
import 'package:memora/core/theme/responsive/screen_class.dart';
import 'package:memora/core/theme/tokens/icon_tokens.dart';

@immutable
class AdaptiveIconSize {
  const AdaptiveIconSize({
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
  });

  factory AdaptiveIconSize.resolve(ScreenClass screenClass) {
    return AdaptiveIconSize(
      sm: ResponsiveScale.bounded(
        base: AppIconTokens.sm,
        screenClass: screenClass,
        min: 18,
        max: 20,
      ),
      md: ResponsiveScale.bounded(
        base: AppIconTokens.md,
        screenClass: screenClass,
        min: 20,
        max: 22,
      ),
      lg: ResponsiveScale.bounded(
        base: AppIconTokens.lg,
        screenClass: screenClass,
        min: 24,
        max: 28,
      ),
      xl: ResponsiveScale.bounded(
        base: AppIconTokens.xl,
        screenClass: screenClass,
        min: 28,
        max: 32,
      ),
    );
  }

  final double sm;
  final double md;
  final double lg;
  final double xl;
}
