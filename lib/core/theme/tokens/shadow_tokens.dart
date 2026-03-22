import 'package:flutter/material.dart';
import 'package:memora/core/theme/tokens/color_tokens.dart';

abstract final class AppShadowTokens {
  static const soft = [
    BoxShadow(
      color: AppColorTokens.shadow,
      blurRadius: 12,
      offset: Offset(0, 6),
    ),
  ];
}
