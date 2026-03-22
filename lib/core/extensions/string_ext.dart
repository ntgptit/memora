extension NullableStringExt on String? {
  bool get isBlank => this == null || this!.trim().isEmpty;

  String? get trimmedOrNull {
    final trimmed = this?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}

extension StringExt on String {
  String get capitalized {
    if (trim().isEmpty) {
      return this;
    }

    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
