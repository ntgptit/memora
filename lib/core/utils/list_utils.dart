abstract final class ListUtils {
  static bool isNullOrEmpty<T>(List<T>? values) {
    return values == null || values.isEmpty;
  }

  static List<T> replaceAt<T>(List<T> source, int index, T value) {
    final next = List<T>.of(source);
    next[index] = value;
    return next;
  }

  static List<T> toggle<T>(List<T> source, T value) {
    final next = List<T>.of(source);
    if (next.contains(value)) {
      next.remove(value);
    } else {
      next.add(value);
    }
    return next;
  }
}
