import 'package:flutter/material.dart';

abstract final class ContextUtils {
  static Size screenSize(BuildContext context) => MediaQuery.sizeOf(context);

  static double screenWidth(BuildContext context) => screenSize(context).width;

  static double screenHeight(BuildContext context) =>
      screenSize(context).height;

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  static bool canPop(BuildContext context) => Navigator.of(context).canPop();
}
