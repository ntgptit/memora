import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/component_theme_ext.dart';
import 'package:memora/core/theme/extensions/dimension_theme_ext.dart';

abstract final class MemoraDialogTheme {
  static DialogThemeData build(
    ColorScheme colorScheme,
    DimensionThemeExt dims,
    ComponentThemeExt components,
  ) {
    return DialogThemeData(
      backgroundColor: colorScheme.surface,
      surfaceTintColor: Colors.transparent,
      insetPadding: EdgeInsets.all(components.componentSize.dialogPadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dims.radius.lg),
      ),
    );
  }
}
