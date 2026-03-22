import 'package:flutter/foundation.dart';

@immutable
class Failure {
  const Failure({
    required this.message,
    this.code,
    this.isRetryable = false,
    this.cause,
    this.stackTrace,
  });

  final String message;
  final String? code;
  final bool isRetryable;
  final Object? cause;
  final StackTrace? stackTrace;

  bool get hasCode => code != null && code!.isNotEmpty;

  @override
  String toString() {
    return '$runtimeType(code: $code, retryable: $isRetryable, message: $message)';
  }
}
