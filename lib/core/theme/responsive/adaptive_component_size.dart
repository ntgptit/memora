import 'package:flutter/foundation.dart';
import 'package:memora/core/theme/responsive/screen_class.dart';
import 'package:memora/core/theme/tokens/size_tokens.dart';

@immutable
class AdaptiveComponentSize {
  const AdaptiveComponentSize({
    required this.buttonHeight,
    required this.bottomBarHeight,
    required this.cardPadding,
    required this.inputHeight,
    required this.chipHeight,
    required this.dialogPadding,
    required this.toolbarHeight,
    required this.fabSize,
    required this.navigationRailWidth,
    required this.cardMinHeight,
  });

  factory AdaptiveComponentSize.fromScreen(ScreenClass screenClass) {
    return switch (screenClass) {
      ScreenClass.compact => const AdaptiveComponentSize(
        buttonHeight: AppSizeTokens.compactButtonHeight,
        bottomBarHeight: AppSizeTokens.compactBottomBarHeight,
        cardPadding: AppSizeTokens.cardPadding,
        inputHeight: AppSizeTokens.compactInputHeight,
        chipHeight: AppSizeTokens.chipHeight,
        dialogPadding: AppSizeTokens.dialogPadding,
        toolbarHeight: AppSizeTokens.compactToolbarHeight,
        fabSize: AppSizeTokens.fabSize,
        navigationRailWidth: 72,
        cardMinHeight: AppSizeTokens.cardMinHeight,
      ),
      ScreenClass.medium => const AdaptiveComponentSize(
        buttonHeight: AppSizeTokens.regularButtonHeight,
        bottomBarHeight: AppSizeTokens.regularBottomBarHeight,
        cardPadding: AppSizeTokens.cardPadding,
        inputHeight: AppSizeTokens.regularInputHeight,
        chipHeight: AppSizeTokens.chipHeight,
        dialogPadding: AppSizeTokens.dialogPadding,
        toolbarHeight: AppSizeTokens.compactToolbarHeight,
        fabSize: AppSizeTokens.fabSize,
        navigationRailWidth: AppSizeTokens.navigationRailWidth,
        cardMinHeight: AppSizeTokens.cardMinHeight,
      ),
      ScreenClass.expanded => const AdaptiveComponentSize(
        buttonHeight: AppSizeTokens.comfortableButtonHeight,
        bottomBarHeight: AppSizeTokens.comfortableBottomBarHeight,
        cardPadding: 20,
        inputHeight: 56,
        chipHeight: 36,
        dialogPadding: 32,
        toolbarHeight: AppSizeTokens.regularToolbarHeight,
        fabSize: 60,
        navigationRailWidth: 88,
        cardMinHeight: 136,
      ),
      ScreenClass.large => const AdaptiveComponentSize(
        buttonHeight: AppSizeTokens.comfortableButtonHeight,
        bottomBarHeight: AppSizeTokens.comfortableBottomBarHeight,
        cardPadding: 24,
        inputHeight: 56,
        chipHeight: 38,
        dialogPadding: 40,
        toolbarHeight: AppSizeTokens.regularToolbarHeight,
        fabSize: 64,
        navigationRailWidth: 96,
        cardMinHeight: 156,
      ),
    };
  }

  final double buttonHeight;
  final double bottomBarHeight;
  final double cardPadding;
  final double inputHeight;
  final double chipHeight;
  final double dialogPadding;
  final double toolbarHeight;
  final double fabSize;
  final double navigationRailWidth;
  final double cardMinHeight;
}
