import 'package:flutter/material.dart';

abstract final class AppColorTokens {
  static const seed = Color(0xFF0E6D68);

  static const primary = Color(0xFF0E6D68);
  static const primaryContainer = Color(0xFFBDE9E2);
  static const secondary = Color(0xFFC06B2C);
  static const secondaryContainer = Color(0xFFFFDCC0);
  static const tertiary = Color(0xFF296C93);
  static const tertiaryContainer = Color(0xFFCBE7FA);

  static const lightBackground = Color(0xFFF7F4EC);
  static const lightSurface = Color(0xFFFBF8F1);
  static const lightSurfaceContainerLow = Color(0xFFF4F0E7);
  static const lightSurfaceContainer = Color(0xFFEFE9DE);
  static const lightSurfaceContainerHigh = Color(0xFFE9E2D4);
  static const lightSurfaceContainerHighest = Color(0xFFE2D9CA);
  static const lightOutline = Color(0xFF71807C);

  static const darkBackground = Color(0xFF0E1413);
  static const darkSurface = Color(0xFF131918);
  static const darkSurfaceContainerLow = Color(0xFF1A2120);
  static const darkSurfaceContainer = Color(0xFF202927);
  static const darkSurfaceContainerHigh = Color(0xFF28312F);
  static const darkSurfaceContainerHighest = Color(0xFF313B38);
  static const darkOutline = Color(0xFF8C9A96);

  static const success = Color(0xFF2F8F4E);
  static const successContainer = Color(0xFFCBEFD6);
  static const onSuccess = Color(0xFFFFFFFF);
  static const onSuccessContainer = Color(0xFF103920);

  static const warning = Color(0xFFB86A07);
  static const warningContainer = Color(0xFFFFE2BF);
  static const onWarning = Color(0xFFFFFFFF);
  static const onWarningContainer = Color(0xFF3F2400);

  static const error = Color(0xFFB3261E);
  static const errorContainer = Color(0xFFF9DEDC);
  static const info = Color(0xFF1565C0);
  static const infoContainer = Color(0xFFD6E7FF);
  static const onInfo = Color(0xFFFFFFFF);
  static const onInfoContainer = Color(0xFF001D36);

  static const dividerLight = Color(0x1F1B2A24);
  static const dividerDark = Color(0x33FFFFFF);
  static const overlayLight = Color(0x14000000);
  static const overlayDark = Color(0x33FFFFFF);
  static const shadow = Color(0x1A000000);

  static Color surface(Brightness brightness) {
    return brightness == Brightness.dark ? darkSurface : lightSurface;
  }

  static Color background(Brightness brightness) {
    return brightness == Brightness.dark ? darkBackground : lightBackground;
  }

  static Color outline(Brightness brightness) {
    return brightness == Brightness.dark ? darkOutline : lightOutline;
  }

  static Color divider(Brightness brightness) {
    return brightness == Brightness.dark ? dividerDark : dividerLight;
  }
}
