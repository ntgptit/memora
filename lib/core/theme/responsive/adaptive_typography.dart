import 'package:flutter/foundation.dart';
import 'package:memora/core/theme/responsive/responsive_scale.dart';
import 'package:memora/core/theme/responsive/screen_class.dart';
import 'package:memora/core/theme/tokens/typography_tokens.dart';

@immutable
class AdaptiveTypography {
  const AdaptiveTypography({
    required this.display,
    required this.headline,
    required this.title,
    required this.body,
    required this.label,
  });

  factory AdaptiveTypography.resolve(ScreenClass screenClass) {
    return AdaptiveTypography(
      display: ResponsiveScale.bounded(
        base: AppTypographyTokens.display,
        screenClass: screenClass,
        min: 40,
        max: 48,
      ),
      headline: ResponsiveScale.bounded(
        base: AppTypographyTokens.headline,
        screenClass: screenClass,
        min: 28,
        max: 34,
      ),
      title: ResponsiveScale.bounded(
        base: AppTypographyTokens.title,
        screenClass: screenClass,
        min: 20,
        max: 24,
      ),
      body: ResponsiveScale.bounded(
        base: AppTypographyTokens.body,
        screenClass: screenClass,
        min: 16,
        max: 18,
      ),
      label: ResponsiveScale.bounded(
        base: AppTypographyTokens.label,
        screenClass: screenClass,
        min: 14,
        max: 16,
      ),
    );
  }

  final double display;
  final double headline;
  final double title;
  final double body;
  final double label;
}
