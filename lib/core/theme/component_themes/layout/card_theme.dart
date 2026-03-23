import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/dimension_theme_ext.dart';
import 'package:memora/core/theme/tokens/tokens.dart';

abstract final class MemoraCardTheme {
  static CardThemeData build(ColorScheme colorScheme, DimensionThemeExt dims) {
    return CardThemeData(
      elevation: AppElevationTokens.level0,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      color: colorScheme.surfaceContainerLow,
      shadowColor: colorScheme.shadow,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dims.radius.lg),
      ),
    );
  }
}
