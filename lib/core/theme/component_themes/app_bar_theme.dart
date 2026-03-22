import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/dimension_theme_ext.dart';
import 'package:memora/core/theme/tokens/elevation_tokens.dart';
import 'package:memora/core/theme/tokens/typography_tokens.dart';

abstract final class MemoraAppBarTheme {
  static AppBarTheme build({
    required ColorScheme colorScheme,
    required DimensionThemeExt dims,
  }) {
    return AppBarTheme(
      centerTitle: false,
      elevation: AppElevationTokens.level0,
      scrolledUnderElevation: AppElevationTokens.level0,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      toolbarHeight: dims.componentSize.toolbarHeight,
      titleSpacing: dims.spacing.lg,
      titleTextStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: dims.typography.title,
        fontWeight: AppTypographyTokens.semibold,
      ),
    );
  }
}
