import 'package:flutter/foundation.dart';
import 'package:memora/core/theme/responsive/responsive_scale.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';
import 'package:memora/core/theme/tokens/typography_tokens.dart';

@immutable
class AdaptiveTypography {
  const AdaptiveTypography({
    required this.display,
    required this.displayMedium,
    required this.headline,
    required this.headlineLarge,
    required this.title,
    required this.titleMedium,
    required this.body,
    required this.bodyMedium,
    required this.label,
    required this.labelMedium,
  });

  factory AdaptiveTypography.resolve(ScreenInfo screenInfo) {
    return AdaptiveTypography(
      display: ResponsiveScale.typography(
        base: AppTypographyTokens.displayLarge,
        screenInfo: screenInfo,
        min: 40,
        max: 52,
      ),
      displayMedium: ResponsiveScale.typography(
        base: AppTypographyTokens.displayMedium,
        screenInfo: screenInfo,
        min: 36,
        max: 44,
      ),
      headline: ResponsiveScale.typography(
        base: AppTypographyTokens.headlineMedium,
        screenInfo: screenInfo,
        min: 28,
        max: 36,
      ),
      headlineLarge: ResponsiveScale.typography(
        base: AppTypographyTokens.headlineLarge,
        screenInfo: screenInfo,
        min: 30,
        max: 40,
      ),
      title: ResponsiveScale.typography(
        base: AppTypographyTokens.titleLarge,
        screenInfo: screenInfo,
        min: 20,
        max: 26,
      ),
      titleMedium: ResponsiveScale.typography(
        base: AppTypographyTokens.titleMedium,
        screenInfo: screenInfo,
        min: 18,
        max: 22,
      ),
      body: ResponsiveScale.typography(
        base: AppTypographyTokens.bodyLarge,
        screenInfo: screenInfo,
        min: 16,
        max: 18,
      ),
      bodyMedium: ResponsiveScale.typography(
        base: AppTypographyTokens.bodyMedium,
        screenInfo: screenInfo,
        min: 14,
        max: 16,
      ),
      label: ResponsiveScale.typography(
        base: AppTypographyTokens.labelLarge,
        screenInfo: screenInfo,
        min: 14,
        max: 16,
      ),
      labelMedium: ResponsiveScale.typography(
        base: AppTypographyTokens.labelMedium,
        screenInfo: screenInfo,
        min: 12,
        max: 14,
      ),
    );
  }

  final double display;
  final double displayMedium;
  final double headline;
  final double headlineLarge;
  final double title;
  final double titleMedium;
  final double body;
  final double bodyMedium;
  final double label;
  final double labelMedium;
}
