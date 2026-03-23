import 'package:flutter/foundation.dart';
import 'package:memora/data/models/api_audit_dto.dart';

@immutable
class DeckDto {
  const DeckDto({
    required this.id,
    required this.folderId,
    required this.name,
    required this.flashcardCount,
    required this.audit,
    this.description,
  });

  final int id;
  final int folderId;
  final String name;
  final String? description;
  final int flashcardCount;
  final ApiAuditDto audit;

  factory DeckDto.fromJson(Map<String, Object?> json) {
    final audit = _readAudit(json['audit']);
    return DeckDto(
      id: _readInt(json['id']) ?? 0,
      folderId: _readInt(json['folderId'] ?? json['folder_id']) ?? 0,
      name: _readString(json['name']) ?? '',
      description: _readString(json['description']),
      flashcardCount:
          _readInt(json['flashcardCount'] ?? json['flashcard_count']) ?? 0,
      audit: audit ?? ApiAuditDto.fromJson(_fallbackAudit(json)),
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'id': id,
      'folderId': folderId,
      'name': name,
      'description': description,
      'flashcardCount': flashcardCount,
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
