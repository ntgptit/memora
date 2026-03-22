import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/dimension_theme_ext.dart';

abstract final class MemoraChipTheme {
  static ChipThemeData build(
    ColorScheme colorScheme,
    DimensionThemeExt dims,
  ) {
    return ChipThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dims.radius.pill),
      ),
      side: BorderSide(color: colorScheme.outlineVariant),
      backgroundColor: colorScheme.surfaceContainerLow,
      selectedColor: colorScheme.secondaryContainer,
      padding: EdgeInsets.symmetric(horizontal: dims.spacing.sm),
      labelPadding: EdgeInsets.zero,
      showCheckmark: false,
    );
  }
}
