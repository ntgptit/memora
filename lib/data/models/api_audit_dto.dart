import 'package:flutter/foundation.dart';

@immutable
class ApiAuditDto {
  const ApiAuditDto({
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.version,
  });

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final int? version;

  factory ApiAuditDto.fromJson(Map<String, Object?> json) {
    return ApiAuditDto(
      createdAt: _readDateTime(json['createdAt'] ?? json['created_at']),
      updatedAt: _readDateTime(json['updatedAt'] ?? json['updated_at']),
      deletedAt: _readDateTime(json['deletedAt'] ?? json['deleted_at']),
      version: _readInt(json['version']),
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'deletedAt': deletedAt?.toIso8601String(),
      'version': version,
    };
  }

  static DateTime? _readDateTime(Object? value) {
    if (value is DateTime) {
      return value;
    }
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }

  static int? _readInt(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }
}
