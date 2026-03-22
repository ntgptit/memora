import 'package:flutter/material.dart';
import 'package:memora/core/theme/responsive/screen_class.dart';

@immutable
class ScreenInfo {
  const ScreenInfo({
    required this.size,
    required this.orientation,
    required this.screenClass,
  });

  const ScreenInfo.fallback()
    : size = const Size(390, 844),
      orientation = Orientation.portrait,
      screenClass = ScreenClass.compact;

  factory ScreenInfo.fromContext(BuildContext context) {
    return ScreenInfo.fromSize(
      MediaQuery.sizeOf(context),
      orientation: MediaQuery.orientationOf(context),
    );
  }

  factory ScreenInfo.fromSize(Size size, {Orientation? orientation}) {
    final resolvedOrientation =
        orientation ??
        (size.width >= size.height
            ? Orientation.landscape
            : Orientation.portrait);

    return ScreenInfo(
      size: size,
      orientation: resolvedOrientation,
      screenClass: ScreenClass.fromWidth(size.width),
    );
  }

  final Size size;
  final Orientation orientation;
  final ScreenClass screenClass;

  double get width => size.width;
  double get height => size.height;
  bool get isLandscape => orientation == Orientation.landscape;
}
