import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/dimension_theme_ext.dart';
import 'package:memora/core/theme/tokens/tokens.dart';

abstract final class MemoraBottomSheetTheme {
  static BottomSheetThemeData build(
    ColorScheme colorScheme,
    DimensionThemeExt dims,
  ) {
    return BottomSheetThemeData(
      backgroundColor: colorScheme.surface,
      modalBackgroundColor: colorScheme.surface,
      elevation: AppElevationTokens.level2,
      modalElevation: AppElevationTokens.level3,
      shadowColor: colorScheme.shadow,
      surfaceTintColor: Colors.transparent,
      constraints: BoxConstraints(maxWidth: dims.layout.panelMaxWidth),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(dims.radius.lg),
        ),
      ),
      showDragHandle: true,
      dragHandleColor: colorScheme.outlineVariant,
      dragHandleSize: Size(dims.iconSize.xl, AppBorderTokens.thick),
    );
  }
}
