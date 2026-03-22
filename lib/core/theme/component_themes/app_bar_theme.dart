import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/dimension_theme_ext.dart';
import 'package:memora/core/theme/extensions/text_theme_ext.dart';
import 'package:memora/core/theme/tokens/elevation_tokens.dart';
import 'package:memora/core/theme/tokens/typography_tokens.dart';

abstract final class MemoraAppBarTheme {
  static AppBarTheme build({
    required ColorScheme colorScheme,
    required DimensionThemeExt dims,
    required TextThemeExt text,
  }) {
    return AppBarTheme(
      centerTitle: false,
      elevation: AppElevationTokens.level0,
      scrolledUnderElevation: AppElevationTokens.level0,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      titleSpacing: dims.spacing.lg,
      titleTextStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: text.typography.title,
        fontWeight: AppTypographyTokens.semibold,
      ),
    );
  }
}
