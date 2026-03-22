import 'package:flutter/foundation.dart';
import 'package:memora/core/theme/responsive/responsive_scale.dart';
import 'package:memora/core/theme/responsive/screen_class.dart';
import 'package:memora/core/theme/tokens/icon_tokens.dart';

@immutable
class AdaptiveIconSize {
  const AdaptiveIconSize({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
  });

  factory AdaptiveIconSize.fromScreen(ScreenClass screenClass) {
    final scale = ResponsiveScale.icon(screenClass);

    return AdaptiveIconSize(
      xs: AppIconTokens.xs * scale,
      sm: AppIconTokens.sm * scale,
      md: AppIconTokens.md * scale,
      lg: AppIconTokens.lg * scale,
      xl: AppIconTokens.xl * scale,
      xxl: AppIconTokens.xxl * scale,
    );
  }

  final double xs;
  final double sm;
  final double md;
  final double lg;
  final double xl;
  final double xxl;
}
