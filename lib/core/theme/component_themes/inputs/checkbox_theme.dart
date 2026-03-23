import 'package:flutter/material.dart';

abstract final class MemoraCheckboxTheme {
  static CheckboxThemeData build(ColorScheme colorScheme) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.surface;
      }),
      checkColor: WidgetStatePropertyAll(colorScheme.onPrimary),
    );
  }
}
