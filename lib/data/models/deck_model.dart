import 'package:flutter/foundation.dart';
import 'package:memora/data/models/audit_model.dart';

@immutable
class DeckModel {
  const DeckModel({
    required this.id,
    required this.folderId,
    required this.name,
    required this.description,
    required this.flashcardCount,
    required this.audit,
  });

  final int id;
  final int folderId;
  final String name;
  final String description;
  final int flashcardCount;
  final AuditModel? audit;

  factory DeckModel.fromJson(Map<String, dynamic> json) {
    return DeckModel(
      id: _readRequiredInt(json['id']),
      folderId: _readRequiredInt(json['folderId']),
      name: _readString(json['name']),
      description: _readString(json['description']),
      flashcardCount: _readRequiredInt(json['flashcardCount']),
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
