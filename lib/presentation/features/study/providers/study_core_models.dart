import 'package:flutter/foundation.dart';

enum StudySessionType { firstLearning, review }

enum StudyMode { review, recall, guess, match, fill }

enum StudySessionLifecycle {
  initialized,
  inProgress,
  waitingFeedback,
  retryPending,
  completed,
}

enum StudyActionType {
  submitAnswer,
  revealAnswer,
  markRemembered,
  retryItem,
  goNext,
  resetCurrentMode,
}

enum StudyFeedbackKind { correct, incorrect, neutral }

enum StudyFeedbackCopy {
  lockedIn,
  queued,
  revealed,
  guessCorrect,
  guessIncorrect,
  matchCorrect,
  matchIncorrect,
  exactRecall,
  keepWorking,
}

enum StudyHistoryStatus { completed, resumed, interrupted }

@immutable
class StudyDeckSummary {
  const StudyDeckSummary({
    required this.deckId,
    required this.title,
    required this.folderLabel,
    required this.availableCards,
    required this.dueCards,
    required this.estimatedMinutes,
    required this.masteryRatio,
  });

  final int deckId;
  final String title;
  final String folderLabel;
  final int availableCards;
  final int dueCards;
  final int estimatedMinutes;
  final double masteryRatio;
}

@immutable
class StudyChoiceOption {
  const StudyChoiceOption({required this.id, required this.label, this.detail});

  final String id;
  final String label;
  final String? detail;
}

@immutable
class StudyMatchOption {
  const StudyMatchOption({required this.id, required this.label, this.detail});

  final String id;
  final String label;
  final String? detail;
}

@immutable
class StudyMatchPair {
  const StudyMatchPair({required this.left, required this.right});

  final StudyMatchOption left;
  final StudyMatchOption right;
}

@immutable
class StudyMatchedPair {
  const StudyMatchedPair({required this.leftId, required this.rightId});

  final String leftId;
  final String rightId;
}

@immutable
class StudySessionItem {
  const StudySessionItem({
    required this.id,
    required this.prompt,
    required this.answer,
    required this.instruction,
    this.note,
    this.pronunciation,
    this.inputPlaceholder,
    this.speechLabel,
    this.choices = const [],
    this.matchPairs = const [],
    this.correctChoiceId,
  });

  final String id;
  final String prompt;
  final String answer;
  final String instruction;
  final String? note;
  final String? pronunciation;
  final String? inputPlaceholder;
  final String? speechLabel;
  final List<StudyChoiceOption> choices;
  final List<StudyMatchPair> matchPairs;
  final String? correctChoiceId;

  bool get supportsAudio => speechLabel != null && speechLabel!.isNotEmpty;
}

@immutable
class StudyModeFeedback {
  const StudyModeFeedback({
    required this.kind,
    required this.copy,
    this.answerText,
    this.actionLabel,
  });

  final StudyFeedbackKind kind;
  final StudyFeedbackCopy copy;
  final String? answerText;
  final String? actionLabel;
}
