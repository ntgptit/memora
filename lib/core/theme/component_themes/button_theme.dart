import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/component_theme_ext.dart';
import 'package:memora/core/theme/extensions/dimension_theme_ext.dart';
import 'package:memora/core/theme/tokens/typography_tokens.dart';

abstract final class MemoraButtonThemes {
  static FilledButtonThemeData filled(
    ColorScheme colorScheme,
    DimensionThemeExt dims,
    ComponentThemeExt components,
  ) {
    return FilledButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(
          Size.fromHeight(components.componentSize.buttonHeight),
        ),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: dims.spacing.lg),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dims.radius.pill),
          ),
        ),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            fontSize: AppTypographyTokens.labelLarge,
            fontWeight: AppTypographyTokens.semibold,
          ),
        ),
      ),
    );
  }

  static OutlinedButtonThemeData outlined(
    ColorScheme colorScheme,
    DimensionThemeExt dims,
    ComponentThemeExt components,
  ) {
    return OutlinedButtonThemeData(
      style: ButtonStyle(
        minimumSize: WidgetStatePropertyAll(
          Size.fromHeight(components.componentSize.buttonHeight),
        ),
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: dims.spacing.lg),
        ),
        side: WidgetStatePropertyAll(
          BorderSide(color: colorScheme.outlineVariant),
        ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(dims.radius.pill),
          ),
        ),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            fontSize: AppTypographyTokens.labelLarge,
            fontWeight: AppTypographyTokens.medium,
          ),
        ),
      ),
    );
  }

  static TextButtonThemeData text(
    ColorScheme colorScheme,
    DimensionThemeExt dims,
  ) {
    return TextButtonThemeData(
      style: ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: dims.spacing.md),
        ),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(
            fontSize: AppTypographyTokens.labelLarge,
            fontWeight: AppTypographyTokens.medium,
          ),
        ),
      ),
    );
  }
}
