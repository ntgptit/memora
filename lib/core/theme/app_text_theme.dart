import 'package:flutter/material.dart';
import 'package:memora/core/theme/responsive/adaptive_typography.dart';
import 'package:memora/core/theme/tokens/typography_tokens.dart';

abstract final class AppTextTheme {
  static TextTheme build(
    ColorScheme colorScheme,
    AdaptiveTypography typography,
  ) {
    return TextTheme(
      displayLarge: _style(
        colorScheme,
        size: typography.display,
        weight: AppTypographyTokens.bold,
      ),
      headlineMedium: _style(
        colorScheme,
        size: typography.headline,
        weight: AppTypographyTokens.bold,
      ),
      titleLarge: _style(
        colorScheme,
        size: typography.title,
        weight: AppTypographyTokens.semibold,
      ),
      bodyLarge: _style(
        colorScheme,
        size: typography.body,
        weight: AppTypographyTokens.regular,
        height: 1.5,
      ),
      bodyMedium: _style(
        colorScheme,
        size: typography.label,
        weight: AppTypographyTokens.regular,
        height: 1.4,
      ),
      labelLarge: _style(
        colorScheme,
        size: typography.label,
        weight: AppTypographyTokens.medium,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  static TextStyle _style(
    ColorScheme colorScheme, {
    required double size,
    required FontWeight weight,
    Color? color,
    double? height,
  }) {
    return TextStyle(
      fontSize: size,
      fontWeight: weight,
      color: color ?? colorScheme.onSurface,
      height: height,
    );
  }
}
