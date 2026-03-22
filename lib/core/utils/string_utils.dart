abstract final class StringUtils {
  static bool isBlank(String? value) {
    return value == null || value.trim().isEmpty;
  }

  static String? trimmedOrNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  static String capitalize(String value) {
    if (value.trim().isEmpty) {
      return value;
    }
    return '${value[0].toUpperCase()}${value.substring(1)}';
  }
}
