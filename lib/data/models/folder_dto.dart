import 'package:flutter/foundation.dart';
import 'package:memora/data/models/api_audit_dto.dart';

@immutable
class FolderDto {
  const FolderDto({
    required this.id,
    required this.name,
    required this.depth,
    required this.childFolderCount,
    required this.audit,
    this.parentId,
    this.description,
    this.colorHex,
  });

  final int id;
  final int? parentId;
  final String name;
  final String? description;
  final String? colorHex;
  final int depth;
  final int childFolderCount;
  final ApiAuditDto audit;

  factory FolderDto.fromJson(Map<String, Object?> json) {
    final audit = _readAudit(json['audit']);
    return FolderDto(
      id: _readInt(json['id']) ?? 0,
      parentId: _readInt(json['parentId'] ?? json['parent_id']),
      name: _readString(json['name']) ?? '',
      description: _readString(json['description']),
      colorHex: _readString(json['colorHex'] ?? json['color_hex']),
      depth: _readInt(json['depth']) ?? 0,
      childFolderCount:
          _readInt(json['childFolderCount'] ?? json['child_folder_count']) ?? 0,
      audit: audit ?? ApiAuditDto.fromJson(_fallbackAudit(json)),
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'parentId': parentId,
      'name': name,
      'description': description,
      'colorHex': colorHex,
      'depth': depth,
      'childFolderCount': childFolderCount,
      'audit': audit.toJson(),
    };
  }

  static ApiAuditDto? _readAudit(Object? value) {
    if (value is Map) {
      return ApiAuditDto.fromJson(Map<String, Object?>.from(value));
    }
    return null;
  }

  static Map<String, Object?> _fallbackAudit(Map<String, Object?> json) {
    return <String, Object?>{
      'createdAt': json['createdAt'] ?? json['created_at'],
      'updatedAt': json['updatedAt'] ?? json['updated_at'],
      'deletedAt': json['deletedAt'] ?? json['deleted_at'],
      'version': json['version'],
    };
  }

  static String? _readString(Object? value) {
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
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
