import 'package:flutter/material.dart';

abstract final class ContextUtils {
  static Size screenSize(BuildContext context) => MediaQuery.sizeOf(context);

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
