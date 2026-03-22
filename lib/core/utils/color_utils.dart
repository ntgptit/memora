import 'package:flutter/material.dart';

abstract final class ColorUtils {
  static Color withOpacityPercent(Color color, double opacityPercent) {
    final normalized = opacityPercent.clamp(0, 100) / 100;
    return color.withAlpha((normalized * 255).round());
  }

  static Color fromHex(String hex) {
    final sanitized = hex.replaceAll('#', '');
    final normalized = sanitized.length == 6 ? 'FF$sanitized' : sanitized;
    return Color(int.parse(normalized, radix: 16));
  }

  static String toHex(Color color, {bool includeAlpha = false}) {
    final alpha = color.a.round().toRadixString(16).padLeft(2, '0');
    final red = color.r.round().toRadixString(16).padLeft(2, '0');
    final green = color.g.round().toRadixString(16).padLeft(2, '0');
    final blue = color.b.round().toRadixString(16).padLeft(2, '0');

    return includeAlpha ? '#$alpha$red$green$blue' : '#$red$green$blue';
  }
}
