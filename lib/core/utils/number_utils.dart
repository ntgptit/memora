abstract final class NumberUtils {
  static double clampDouble(num value, {required num min, required num max}) {
    return value.clamp(min, max).toDouble();
  }

  static double percentage({required num value, required num total}) {
    if (total == 0) {
      return 0;
    }
    return (value / total) * 100;
  }

  static String fixed(num value, [int fractionDigits = 0]) {
    return value.toStringAsFixed(fractionDigits);
  }
}
