extension NumExt on num {
  bool get isZeroValue => this == 0;

  double clampToDouble(num min, num max) {
    return clamp(min, max).toDouble();
  }

  Duration get milliseconds => Duration(milliseconds: round());
}
