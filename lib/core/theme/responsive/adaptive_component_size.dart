import 'package:flutter/foundation.dart';
import 'package:memora/core/theme/responsive/responsive_scale.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';
import 'package:memora/core/theme/tokens/size_tokens.dart';

@immutable
class AdaptiveComponentSize {
  const AdaptiveComponentSize({
    required this.buttonHeight,
    required this.inputHeight,
    required this.chipHeight,
    required this.dialogPadding,
    required this.toolbarHeight,
    required this.fabSize,
    required this.navigationRailWidth,
    required this.cardMinHeight,
  });

  factory AdaptiveComponentSize.resolve(ScreenInfo screenInfo) {
    return AdaptiveComponentSize(
      buttonHeight: ResponsiveScale.component(
        base: AppSizeTokens.regularButtonHeight,
        screenInfo: screenInfo,
        min: AppSizeTokens.compactButtonHeight,
        max: AppSizeTokens.comfortableButtonHeight,
      ),
      inputHeight: ResponsiveScale.component(
        base: AppSizeTokens.regularInputHeight,
        screenInfo: screenInfo,
        min: AppSizeTokens.compactInputHeight,
        max: 56,
      ),
      chipHeight: ResponsiveScale.component(
        base: AppSizeTokens.chipHeight,
        screenInfo: screenInfo,
        min: 32,
        max: 38,
      ),
      dialogPadding: ResponsiveScale.spacing(
        base: AppSizeTokens.dialogPadding,
        screenInfo: screenInfo,
        min: 24,
        max: 40,
      ),
      toolbarHeight: ResponsiveScale.component(
        base: AppSizeTokens.regularToolbarHeight,
        screenInfo: screenInfo,
        min: AppSizeTokens.compactToolbarHeight,
        max: 72,
      ),
      fabSize: ResponsiveScale.component(
        base: AppSizeTokens.fabSize,
        screenInfo: screenInfo,
        min: 56,
        max: 64,
      ),
      navigationRailWidth: ResponsiveScale.component(
        base: AppSizeTokens.navigationRailWidth,
        screenInfo: screenInfo,
        min: 72,
        max: 96,
      ),
      cardMinHeight: ResponsiveScale.component(
        base: AppSizeTokens.cardMinHeight,
        screenInfo: screenInfo,
        min: 120,
        max: 156,
      ),
    );
  }

  final double buttonHeight;
  final double inputHeight;
  final double chipHeight;
  final double dialogPadding;
  final double toolbarHeight;
  final double fabSize;
  final double navigationRailWidth;
  final double cardMinHeight;
}
