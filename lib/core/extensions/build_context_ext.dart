import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';

extension BuildContextExt on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  EdgeInsets get pagePadding {
    return EdgeInsets.symmetric(
      horizontal: layout.pageHorizontalPadding,
      vertical: layout.pageVerticalPadding,
    );
  }
}
