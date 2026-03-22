import 'package:memora/core/theme/responsive/screen_class.dart';

abstract final class ResponsiveScale {
  static double bounded({
    required double base,
    required ScreenClass screenClass,
    required double min,
    required double max,
  }) {
    final factor = switch (screenClass) {
      ScreenClass.compact => 1.0,
      ScreenClass.medium => 1.08,
      ScreenClass.expanded => 1.14,
      ScreenClass.large => 1.2,
    };

    final value = base * factor;
    if (value < min) {
      return min;
    }
    if (value > max) {
      return max;
    }
    return value;
  }
}
