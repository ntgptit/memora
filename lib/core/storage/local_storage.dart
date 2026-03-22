abstract interface class LocalStorage {
  bool contains(String key);

  T? read<T>(String key);

  Future<void> write(String key, Object? value);

  Future<void> delete(String key);

  Future<void> clear();
}

class InMemoryLocalStorage implements LocalStorage {
  InMemoryLocalStorage({Map<String, Object?> seed = const <String, Object?>{}})
    : _store = Map<String, Object?>.of(seed);

  final Map<String, Object?> _store;

  @override
  bool contains(String key) => _store.containsKey(key);

  @override
  T? read<T>(String key) {
    final value = _store[key];
    return value is T ? value : null;
  }

  @override
  Future<void> write(String key, Object? value) async {
    _store[key] = value;
  }

  @override
  Future<void> delete(String key) async {
    _store.remove(key);
  }

  @override
  Future<void> clear() async {
    _store.clear();
  }
}
