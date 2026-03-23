import 'package:flutter/foundation.dart';
import 'package:memora/data/models/flashcard_model.dart';

@immutable
class FlashcardPageModel {
  const FlashcardPageModel({
    required this.items,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.hasNext,
    required this.hasPrevious,
  });

  final List<FlashcardModel> items;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool hasNext;
  final bool hasPrevious;

  factory FlashcardPageModel.fromJson(Map<String, Object?> json) {
    return FlashcardPageModel(
      items: _readItems(json['items'] ?? json['content'] ?? json['data']),
      page: _readInt(json['page']),
      size: _readInt(json['size']),
      totalElements: _readInt(json['totalElements'] ?? json['total_elements']),
      totalPages: _readInt(json['totalPages'] ?? json['total_pages']),
      hasNext: _readBool(json['hasNext'] ?? json['has_next']),
      hasPrevious: _readBool(json['hasPrevious'] ?? json['has_previous']),
    );
  }

  static List<FlashcardModel> _readItems(Object? value) {
    if (value is! List) {
      return const <FlashcardModel>[];
    }

    return value
        .whereType<Map>()
        .map(
          (item) => FlashcardModel.fromJson(
            Map<String, Object?>.from(item.cast<String, Object?>()),
          ),
        )
        .toList(growable: false);
  }

  static int _readInt(Object? value, {int fallback = 0}) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? fallback;
    }
    return fallback;
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
