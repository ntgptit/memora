extension IterableExt<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;

  T? get lastOrNull => isEmpty ? null : last;

  Iterable<T> separatedBy(T separator) sync* {
    var index = 0;
    for (final item in this) {
      if (index > 0) {
        yield separator;
      }
      yield item;
      index++;
    }
  }
}
