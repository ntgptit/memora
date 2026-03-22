import 'package:flutter/material.dart';
import 'package:memora/core/theme/tokens/color_tokens.dart';

abstract final class AppColorScheme {
  static ColorScheme build(Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColorTokens.seed,
      brightness: brightness,
    );

    if (brightness == Brightness.dark) {
      return scheme.copyWith(
        surface: AppColorTokens.darkSurface,
        surfaceContainer: AppColorTokens.darkSurfaceContainer,
        surfaceContainerHighest: const Color(0xFF2C3331),
      );
    }

    return scheme.copyWith(
      surface: AppColorTokens.lightSurface,
      surfaceContainer: AppColorTokens.lightSurfaceContainer,
      surfaceContainerHighest: const Color(0xFFE7E2D7),
    );
  }
}
