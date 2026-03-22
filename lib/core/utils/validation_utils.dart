abstract final class ValidationUtils {
  static final RegExp _emailPattern = RegExp(
    r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$',
  );

  static bool hasText(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  static bool isEmail(String? value) {
    if (!hasText(value)) {
      return false;
    }
    return _emailPattern.hasMatch(value!.trim());
  }

  static bool hasMinLength(String? value, int minLength) {
    return (value?.trim().length ?? 0) >= minLength;
  }
}
