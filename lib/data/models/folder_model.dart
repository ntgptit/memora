import 'package:flutter/foundation.dart';
import 'package:memora/data/models/audit_model.dart';

@immutable
class FolderModel {
  const FolderModel({
    required this.id,
    required this.name,
    required this.description,
    required this.colorHex,
    required this.parentId,
    required this.depth,
    required this.childFolderCount,
    required this.audit,
  });

  final int id;
  final String name;
  final String description;
  final String colorHex;
  final int? parentId;
  final int depth;
  final int childFolderCount;
  final AuditModel? audit;

  factory FolderModel.fromJson(Map<String, dynamic> json) {
    return FolderModel(
      id: _readRequiredInt(json['id']),
      name: _readString(json['name']),
      description: _readString(json['description']),
      colorHex: _readString(json['colorHex'], fallback: '#4F46E5'),
      parentId: _readNullableInt(json['parentId']),
      depth: _readRequiredInt(json['depth']),
      childFolderCount: _readRequiredInt(json['childFolderCount']),
      audit: _readAudit(json['audit']),
    );
  }

  static AuditModel? _readAudit(Object? value) {
    if (value is! Map<String, dynamic>) {
      return null;
    }
    return AuditModel.fromJson(value);
  }

  static String _readString(Object? value, {String fallback = ''}) {
    if (value is String) {
      return value;
    }
    return fallback;
  }

  static int _readRequiredInt(Object? value) {
    return _readNullableInt(value) ?? 0;
  }

  static int? _readNullableInt(Object? value) {
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
