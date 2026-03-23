import 'package:flutter/foundation.dart';
import 'package:memora/presentation/features/study/providers/study_core_models.dart';

@immutable
class StudyModeBlueprint {
  const StudyModeBlueprint({required this.mode, required this.items});

  final StudyMode mode;
  final List<StudySessionItem> items;
}

@immutable
class StudyResumeSummary {
  const StudyResumeSummary({
    required this.sessionId,
    required this.activeMode,
    required this.completedItems,
    required this.totalItems,
  });

  final String sessionId;
  final StudyMode activeMode;
  final int completedItems;
  final int totalItems;

  double get progress => totalItems == 0 ? 0 : completedItems / totalItems;
}

@immutable
class StudyHistoryEntry {
  const StudyHistoryEntry({
    required this.id,
    required this.deckTitle,
    required this.sessionType,
    required this.primaryMode,
    required this.completedAt,
    required this.masteredItems,
    required this.totalItems,
    required this.retryItems,
    required this.status,
  });

  final String id;
  final String deckTitle;
  final StudySessionType sessionType;
  final StudyMode primaryMode;
  final DateTime completedAt;
  final int masteredItems;
  final int totalItems;
  final int retryItems;
  final StudyHistoryStatus status;

  double get completionRatio =>
      totalItems == 0 ? 0 : masteredItems / totalItems;
}

@immutable
class StudySessionBlueprint {
  const StudySessionBlueprint({
    required this.deck,
    required this.sessionType,
    required this.modes,
    required this.resumeSummary,
    required this.historyEntries,
  });

  final StudyDeckSummary deck;
  final StudySessionType sessionType;
  final List<StudyModeBlueprint> modes;
  final StudyResumeSummary? resumeSummary;
  final List<StudyHistoryEntry> historyEntries;

  int get totalItems =>
      modes.fold<int>(0, (sum, mode) => sum + mode.items.length);
}
