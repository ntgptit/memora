import 'package:memora/core/theme/responsive/breakpoints.dart';

enum ScreenClass {
  compact('compact'),
  medium('medium'),
  expanded('expanded'),
  large('large');

  const ScreenClass(this.label);

  final String label;

  static ScreenClass fromWidth(double width) {
    if (width <= AppBreakpoints.compactMaxWidth) {
      return ScreenClass.compact;
    }
    if (width <= AppBreakpoints.mediumMaxWidth) {
      return ScreenClass.medium;
    }
    if (width <= AppBreakpoints.expandedMaxWidth) {
      return ScreenClass.expanded;
    }
    return ScreenClass.large;
  }
}
