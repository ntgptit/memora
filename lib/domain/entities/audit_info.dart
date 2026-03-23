import 'package:flutter/foundation.dart';

@immutable
class AuditInfo {
  const AuditInfo({
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.version,
  });

  const AuditInfo.empty()
    : createdAt = null,
      updatedAt = null,
      deletedAt = null,
      version = null;

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final int? version;
}
