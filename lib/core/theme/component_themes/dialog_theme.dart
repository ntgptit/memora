import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/dimension_theme_ext.dart';
import 'package:memora/core/theme/tokens/elevation_tokens.dart';
import 'package:memora/core/theme/tokens/typography_tokens.dart';

abstract final class MemoraDialogTheme {
  static DialogThemeData build(
    ColorScheme colorScheme,
    DimensionThemeExt dims,
  ) {
    return DialogThemeData(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      elevation: AppElevationTokens.level3,
      shadowColor: colorScheme.shadow,
      insetPadding: EdgeInsets.all(dims.componentSize.dialogPadding),
      constraints: BoxConstraints(maxWidth: dims.layout.dialogMaxWidth),
      titleTextStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: dims.typography.title,
        fontWeight: AppTypographyTokens.semibold,
      ),
      contentTextStyle: TextStyle(
        color: colorScheme.onSurfaceVariant,
        fontSize: dims.typography.bodyMedium,
        fontWeight: AppTypographyTokens.regular,
        height: AppTypographyTokens.bodyHeight,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dims.radius.lg),
      ),
    );
  }
}
