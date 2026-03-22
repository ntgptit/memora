import 'package:flutter/material.dart';

@immutable
class DashboardState {
  const DashboardState({
    required this.focus,
    required this.reviewedToday,
    required this.dailyGoal,
    required this.totalStudyMinutes,
    required this.currentStreak,
    required this.dueDecks,
    required this.quickActions,
  });

  factory DashboardState.sample() {
    return const DashboardState(
      focus: DashboardFocus.reviewSprint,
      reviewedToday: 36,
      dailyGoal: 60,
      totalStudyMinutes: 48,
      currentStreak: 9,
      dueDecks: [
        DashboardDueDeckItem(
          id: 'verbs',
          deck: DashboardDeckSeed.verbs,
          folder: DashboardFolderSeed.languageLab,
          mode: DashboardStudyMode.recall,
          dueCardCount: 18,
          masteryProgress: 0.72,
          isPriority: true,
        ),
        DashboardDueDeckItem(
          id: 'medical',
          deck: DashboardDeckSeed.medical,
          folder: DashboardFolderSeed.examPrep,
          mode: DashboardStudyMode.review,
          dueCardCount: 14,
          masteryProgress: 0.61,
        ),
        DashboardDueDeckItem(
          id: 'travel',
          deck: DashboardDeckSeed.travel,
          folder: DashboardFolderSeed.dailyPractice,
          mode: DashboardStudyMode.speedDrill,
          dueCardCount: 10,
          masteryProgress: 0.84,
        ),
      ],
      quickActions: [
        DashboardQuickActionItem(
          type: DashboardQuickActionType.review,
          icon: Icons.play_circle_fill_rounded,
        ),
        DashboardQuickActionItem(
          type: DashboardQuickActionType.createDeck,
          icon: Icons.add_card_rounded,
        ),
        DashboardQuickActionItem(
          type: DashboardQuickActionType.importCards,
          icon: Icons.file_upload_outlined,
        ),
      ],
    );
  }

  final DashboardFocus focus;
  final int reviewedToday;
  final int dailyGoal;
  final int totalStudyMinutes;
  final int currentStreak;
  final List<DashboardDueDeckItem> dueDecks;
  final List<DashboardQuickActionItem> quickActions;

  int get dueDeckCount => dueDecks.length;

  int get dueCardCount {
    return dueDecks.fold<int>(0, (total, deck) => total + deck.dueCardCount);
  }

  DashboardState copyWith({
    DashboardFocus? focus,
    int? reviewedToday,
    int? dailyGoal,
    int? totalStudyMinutes,
    int? currentStreak,
    List<DashboardDueDeckItem>? dueDecks,
    List<DashboardQuickActionItem>? quickActions,
  }) {
    return DashboardState(
      focus: focus ?? this.focus,
      reviewedToday: reviewedToday ?? this.reviewedToday,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      totalStudyMinutes: totalStudyMinutes ?? this.totalStudyMinutes,
      currentStreak: currentStreak ?? this.currentStreak,
      dueDecks: dueDecks ?? this.dueDecks,
      quickActions: quickActions ?? this.quickActions,
    );
  }
}

@immutable
class DashboardDueDeckItem {
  const DashboardDueDeckItem({
    required this.id,
    required this.deck,
    required this.folder,
    required this.mode,
    required this.dueCardCount,
    required this.masteryProgress,
    this.isPriority = false,
  });

  final String id;
  final DashboardDeckSeed deck;
  final DashboardFolderSeed folder;
  final DashboardStudyMode mode;
  final int dueCardCount;
  final double masteryProgress;
  final bool isPriority;

  DashboardDueDeckItem copyWith({
    String? id,
    DashboardDeckSeed? deck,
    DashboardFolderSeed? folder,
    DashboardStudyMode? mode,
    int? dueCardCount,
    double? masteryProgress,
    bool? isPriority,
  }) {
    return DashboardDueDeckItem(
      id: id ?? this.id,
      deck: deck ?? this.deck,
      folder: folder ?? this.folder,
      mode: mode ?? this.mode,
      dueCardCount: dueCardCount ?? this.dueCardCount,
      masteryProgress: masteryProgress ?? this.masteryProgress,
      isPriority: isPriority ?? this.isPriority,
    );
  }
}

@immutable
class DashboardQuickActionItem {
  const DashboardQuickActionItem({required this.type, required this.icon});

  final DashboardQuickActionType type;
  final IconData icon;

  String get id => type.name;

  DashboardQuickActionItem copyWith({
    DashboardQuickActionType? type,
    IconData? icon,
  }) {
    return DashboardQuickActionItem(
      type: type ?? this.type,
      icon: icon ?? this.icon,
    );
  }
}

enum DashboardFocus {
  reviewSprint,
  captureMode,
  importQueue,
  inboxClear,
  laterQueue,
}

enum DashboardDeckSeed { verbs, medical, travel }

enum DashboardFolderSeed { languageLab, examPrep, dailyPractice }

enum DashboardStudyMode { recall, review, speedDrill }

enum DashboardQuickActionType { review, createDeck, importCards }
