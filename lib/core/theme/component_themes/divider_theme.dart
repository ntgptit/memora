import 'package:flutter/material.dart';
import 'package:memora/core/theme/tokens/border_tokens.dart';

abstract final class MemoraDividerTheme {
  static DividerThemeData build(ColorScheme colorScheme) {
    return DividerThemeData(
      color: colorScheme.outlineVariant,
      thickness: AppBorderTokens.thin,
      space: 1,
    );
  }
}
