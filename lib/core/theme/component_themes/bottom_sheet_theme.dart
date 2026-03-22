import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/dimension_theme_ext.dart';

abstract final class MemoraBottomSheetTheme {
  static BottomSheetThemeData build(
    ColorScheme colorScheme,
    DimensionThemeExt dims,
  ) {
    return BottomSheetThemeData(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(dims.radius.lg),
        ),
      ),
      showDragHandle: true,
    );
  }
}
