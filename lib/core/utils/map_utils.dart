abstract final class MapUtils {
  static Map<K, V> merge<K, V>(Map<K, V> base, [Map<K, V> extra = const {}]) {
    return <K, V>{...base, ...extra};
  }

  static Map<K, V> compact<K, V>(Map<K, V?> source) {
    final result = <K, V>{};
    source.forEach((key, value) {
      if (value != null) {
        result[key] = value;
      }
    });
    return result;
  }
}
