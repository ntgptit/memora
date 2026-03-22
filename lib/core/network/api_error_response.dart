import 'package:flutter/foundation.dart';

@immutable
class ApiErrorResponse {
  const ApiErrorResponse({required this.message, this.code});

  final String message;
  final String? code;
}
