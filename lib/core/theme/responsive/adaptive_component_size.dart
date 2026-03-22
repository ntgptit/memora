import 'package:flutter/foundation.dart';
import 'package:memora/core/theme/responsive/responsive_scale.dart';
import 'package:memora/core/theme/responsive/screen_class.dart';
import 'package:memora/core/theme/tokens/size_tokens.dart';

@immutable
class AdaptiveComponentSize {
  const AdaptiveComponentSize({
    required this.buttonHeight,
    required this.inputHeight,
    required this.chipHeight,
    required this.dialogPadding,
  });

  factory AdaptiveComponentSize.resolve(ScreenClass screenClass) {
    return AdaptiveComponentSize(
      buttonHeight: ResponsiveScale.bounded(
        base: AppSizeTokens.regularButtonHeight,
        screenClass: screenClass,
        min: AppSizeTokens.compactButtonHeight,
        max: AppSizeTokens.comfortableButtonHeight,
      ),
      inputHeight: ResponsiveScale.bounded(
        base: AppSizeTokens.regularInputHeight,
        screenClass: screenClass,
        min: AppSizeTokens.compactInputHeight,
        max: 56,
      ),
      chipHeight: ResponsiveScale.bounded(
        base: AppSizeTokens.chipHeight,
        screenClass: screenClass,
        min: 32,
        max: 38,
      ),
      dialogPadding: ResponsiveScale.bounded(
        base: AppSizeTokens.dialogPadding,
        screenClass: screenClass,
        min: 24,
        max: 32,
      ),
    );
  }

  final double buttonHeight;
  final double inputHeight;
  final double chipHeight;
  final double dialogPadding;
}
