import 'package:flutter/material.dart';

abstract final class MemoraProgressIndicatorTheme {
  static ProgressIndicatorThemeData build(ColorScheme colorScheme) {
    return ProgressIndicatorThemeData(
      color: colorScheme.primary,
      linearTrackColor: colorScheme.surfaceContainerHighest,
      circularTrackColor: colorScheme.surfaceContainerHighest,
    );
  }
}
