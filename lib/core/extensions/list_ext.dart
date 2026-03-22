extension ListExt<T> on List<T> {
  List<T> replacingAt(int index, T value) {
    final next = List<T>.of(this);
    next[index] = value;
    return next;
  }

  List<T> toggled(T value) {
    final next = List<T>.of(this);
    if (next.contains(value)) {
      next.remove(value);
    } else {
      next.add(value);
    }
    return next;
  }
}
