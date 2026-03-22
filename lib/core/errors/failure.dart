import 'package:flutter/foundation.dart';

@immutable
class Failure {
  const Failure({required this.message, this.code, this.isRetryable = false});

  final String message;
  final String? code;
  final bool isRetryable;
}
