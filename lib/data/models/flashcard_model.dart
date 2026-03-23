import 'package:flutter/foundation.dart';
import 'package:memora/data/models/audit_model.dart';

@immutable
class FlashcardModel {
  const FlashcardModel({
    required this.id,
    required this.deckId,
    required this.frontText,
    required this.backText,
    required this.isBookmarked,
    required this.audit,
    this.frontLangCode,
    this.backLangCode,
    this.pronunciation,
    this.note,
  });

  final int id;
  final int deckId;
  final String frontText;
  final String backText;
  final String? frontLangCode;
  final String? backLangCode;
  final String? pronunciation;
  final String? note;
  final bool isBookmarked;
  final AuditModel? audit;

  factory FlashcardModel.fromJson(Map<String, Object?> json) {
    return FlashcardModel(
      id: _readRequiredInt(json['id']),
      deckId: _readRequiredInt(json['deckId'] ?? json['deck_id']),
      frontText: _readString(json['frontText'] ?? json['front_text']),
      backText: _readString(json['backText'] ?? json['back_text']),
      frontLangCode: _readOptionalString(
        json['frontLangCode'] ?? json['front_lang_code'],
      ),
      backLangCode: _readOptionalString(
        json['backLangCode'] ?? json['back_lang_code'],
      ),
      pronunciation: _readOptionalString(json['pronunciation']),
      note: _readOptionalString(json['note']),
      isBookmarked: _readBool(json['isBookmarked'] ?? json['is_bookmarked']),
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

  static String? _readOptionalString(Object? value) {
    if (value is String) {
      final trimmed = value.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    return null;
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

  static bool _readBool(Object? value) {
    if (value is bool) {
      return value;
    }
    if (value is num) {
      return value != 0;
    }
    if (value is String) {
      final normalized = value.trim().toLowerCase();
      return normalized == 'true' || normalized == '1';
    }
    return false;
  }
}
