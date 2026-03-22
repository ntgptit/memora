import 'package:flutter/material.dart';
import 'package:memora/core/theme/tokens/color_tokens.dart';

@immutable
class ColorSchemeExt extends ThemeExtension<ColorSchemeExt> {
  const ColorSchemeExt({
    required this.success,
    required this.warning,
    required this.info,
  });

  factory ColorSchemeExt.fallback() {
    return const ColorSchemeExt(
      success: AppColorTokens.success,
      warning: AppColorTokens.warning,
      info: AppColorTokens.info,
    );
  }

  final Color success;
  final Color warning;
  final Color info;

  @override
  ColorSchemeExt copyWith({Color? success, Color? warning, Color? info}) {
    return ColorSchemeExt(
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
    );
  }

  @override
  ColorSchemeExt lerp(ThemeExtension<ColorSchemeExt>? other, double t) {
    if (other is! ColorSchemeExt) {
      return this;
    }
    return ColorSchemeExt(
      success: Color.lerp(success, other.success, t) ?? success,
      warning: Color.lerp(warning, other.warning, t) ?? warning,
      info: Color.lerp(info, other.info, t) ?? info,
    );
  }
}
