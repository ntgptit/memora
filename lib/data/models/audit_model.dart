import 'package:flutter/foundation.dart';

@immutable
class AuditModel {
  const AuditModel({
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.version,
  });

  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? deletedAt;
  final int? version;

  factory AuditModel.fromJson(Map<String, dynamic> json) {
    return AuditModel(
      createdAt: _readDateTime(json['createdAt']),
      updatedAt: _readDateTime(json['updatedAt']),
      deletedAt: _readDateTime(json['deletedAt']),
      version: _readInt(json['version']),
    );
  }

  static DateTime? _readDateTime(Object? value) {
    if (value is! String || value.trim().isEmpty) {
      return null;
    }

    return DateTime.tryParse(value)?.toLocal();
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
