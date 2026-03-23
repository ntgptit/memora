import 'package:flutter/material.dart';
import 'package:memora/core/theme/tokens/tokens.dart';

abstract final class MemoraSliderTheme {
  static SliderThemeData build(ColorScheme colorScheme) {
    return SliderThemeData(
      activeTrackColor: colorScheme.primary,
      inactiveTrackColor: colorScheme.surfaceContainerHighest,
      thumbColor: colorScheme.primary,
      overlayColor: colorScheme.primary.withValues(
        alpha: AppOpacityTokens.subtle,
      ),
    );
  }
}
