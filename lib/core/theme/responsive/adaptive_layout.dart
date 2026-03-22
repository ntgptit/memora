import 'package:flutter/foundation.dart';
import 'package:memora/core/theme/responsive/screen_class.dart';

@immutable
class AdaptiveLayout {
  const AdaptiveLayout({
    required this.pageHorizontalPadding,
    required this.pageVerticalPadding,
    required this.sectionGap,
    required this.contentMaxWidth,
    required this.panelMaxWidth,
    required this.dialogMaxWidth,
  });

  factory AdaptiveLayout.resolve(ScreenClass screenClass) {
    return switch (screenClass) {
      ScreenClass.compact => const AdaptiveLayout(
        pageHorizontalPadding: 20,
        pageVerticalPadding: 24,
        sectionGap: 24,
        contentMaxWidth: 560,
        panelMaxWidth: 480,
        dialogMaxWidth: 420,
      ),
      ScreenClass.medium => const AdaptiveLayout(
        pageHorizontalPadding: 32,
        pageVerticalPadding: 32,
        sectionGap: 32,
        contentMaxWidth: 720,
        panelMaxWidth: 560,
        dialogMaxWidth: 520,
      ),
      ScreenClass.expanded => const AdaptiveLayout(
        pageHorizontalPadding: 40,
        pageVerticalPadding: 40,
        sectionGap: 40,
        contentMaxWidth: 960,
        panelMaxWidth: 640,
        dialogMaxWidth: 560,
      ),
      ScreenClass.large => const AdaptiveLayout(
        pageHorizontalPadding: 56,
        pageVerticalPadding: 48,
        sectionGap: 48,
        contentMaxWidth: 1120,
        panelMaxWidth: 720,
        dialogMaxWidth: 640,
      ),
    };
  }

  final double pageHorizontalPadding;
  final double pageVerticalPadding;
  final double sectionGap;
  final double contentMaxWidth;
  final double panelMaxWidth;
  final double dialogMaxWidth;
}
