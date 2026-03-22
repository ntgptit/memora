abstract final class ObjectUtils {
  static T? castOrNull<T>(Object? value) {
    return value is T ? value : null;
  }

  static T? firstNonNull<T>(Iterable<T?> values) {
    for (final value in values) {
      if (value != null) {
        return value;
      }
    }
    return null;
  }
}
