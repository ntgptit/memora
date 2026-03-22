import 'package:flutter/foundation.dart';

@immutable
class ApiClient {
  const ApiClient({required this.baseUrl, required this.enableLogs});

  final String baseUrl;
  final bool enableLogs;
}
