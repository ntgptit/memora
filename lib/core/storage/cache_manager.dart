import 'package:flutter/foundation.dart';

class CacheManager {
  CacheManager({DateTime Function()? now}) : _now = now ?? DateTime.now;

  final DateTime Function() _now;
  final Map<String, _CacheEntry<Object?>> _entries = {};

  T? read<T>(String key) {
    final entry = _entries[key];
    if (entry == null) {
      return null;
    }

    if (entry.isExpired(_now())) {
      _entries.remove(key);
      return null;
    }

    final value = entry.value;
    return value is T ? value : null;
  }

  void write(String key, Object? value, {Duration? ttl}) {
    _entries[key] = _CacheEntry<Object?>(
      value: value,
      expiresAt: ttl == null ? null : _now().add(ttl),
    );
  }

  void remove(String key) {
    _entries.remove(key);
  }

  void clear() {
    _entries.clear();
  }
}

@immutable
class _CacheEntry<T> {
  const _CacheEntry({required this.value, required this.expiresAt});

  final T value;
  final DateTime? expiresAt;

  bool isExpired(DateTime now) {
    final deadline = expiresAt;
    if (deadline == null) {
      return false;
    }

    return !deadline.isAfter(now);
  }
}
