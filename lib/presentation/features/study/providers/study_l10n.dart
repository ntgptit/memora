import 'package:flutter/material.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';

extension StudySessionTypeL10n on StudySessionType {
  String label(AppLocalizations l10n) {
    switch (this) {
      case StudySessionType.firstLearning:
        return l10n.studySessionTypeFirstLearning;
      case StudySessionType.review:
        return l10n.studySessionTypeReview;
    }
  }

  String subtitle(AppLocalizations l10n) {
    switch (this) {
      case StudySessionType.firstLearning:
        return l10n.studySessionTypeFirstLearningSubtitle;
      case StudySessionType.review:
        return l10n.studySessionTypeReviewSubtitle;
    }
  }
}

extension StudyModeL10n on StudyMode {
  String label(AppLocalizations l10n) {
    switch (this) {
      case StudyMode.review:
        return l10n.studyModeReview;
      case StudyMode.recall:
        return l10n.studyModeRecall;
      case StudyMode.guess:
        return l10n.studyModeGuess;
      case StudyMode.match:
        return l10n.studyModeMatch;
      case StudyMode.fill:
        return l10n.studyModeFill;
    }
  }

  String description(AppLocalizations l10n) {
    switch (this) {
      case StudyMode.review:
        return l10n.studyModeReviewDescription;
      case StudyMode.recall:
        return l10n.studyModeRecallDescription;
      case StudyMode.guess:
        return l10n.studyModeGuessDescription;
      case StudyMode.match:
        return l10n.studyModeMatchDescription;
      case StudyMode.fill:
        return l10n.studyModeFillDescription;
    }
  }

  IconData get icon {
    switch (this) {
      case StudyMode.review:
        return Icons.auto_stories_rounded;
      case StudyMode.recall:
        return Icons.psychology_alt_rounded;
      case StudyMode.guess:
        return Icons.ads_click_rounded;
      case StudyMode.match:
        return Icons.hub_rounded;
      case StudyMode.fill:
        return Icons.keyboard_rounded;
    }
  }
}

extension StudySessionLifecycleL10n on StudySessionLifecycle {
  String label(AppLocalizations l10n) {
    switch (this) {
      case StudySessionLifecycle.initialized:
        return l10n.studyLifecycleReady;
      case StudySessionLifecycle.inProgress:
        return l10n.studyLifecycleInProgress;
      case StudySessionLifecycle.waitingFeedback:
        return l10n.studyLifecycleFeedback;
      case StudySessionLifecycle.retryPending:
        return l10n.studyLifecycleRetryPending;
      case StudySessionLifecycle.completed:
        return l10n.studyLifecycleCompleted;
    }
  }
}

extension StudyModeFeedbackL10n on StudyModeFeedback {
  String titleText(AppLocalizations l10n) {
    return switch (copy) {
      StudyFeedbackCopy.lockedIn => l10n.studyFeedbackLockedInTitle,
      StudyFeedbackCopy.queued => l10n.studyFeedbackQueuedTitle,
      StudyFeedbackCopy.revealed => l10n.studyFeedbackRevealedTitle,
      StudyFeedbackCopy.guessCorrect => l10n.studyFeedbackGuessCorrectTitle,
      StudyFeedbackCopy.guessIncorrect => l10n.studyFeedbackGuessIncorrectTitle,
      StudyFeedbackCopy.matchCorrect => l10n.studyFeedbackMatchCorrectTitle,
      StudyFeedbackCopy.matchIncorrect => l10n.studyFeedbackMatchIncorrectTitle,
      StudyFeedbackCopy.exactRecall => l10n.studyFeedbackExactRecallTitle,
      StudyFeedbackCopy.keepWorking => l10n.studyFeedbackKeepWorkingTitle,
    };
  }

  String messageText(AppLocalizations l10n) {
    final resolvedAnswer = answerText ?? '';
    return switch (copy) {
      StudyFeedbackCopy.lockedIn => l10n.studyFeedbackLockedInMessage,
      StudyFeedbackCopy.queued => l10n.studyFeedbackQueuedMessage,
      StudyFeedbackCopy.revealed => l10n.studyFeedbackRevealedMessage,
      StudyFeedbackCopy.guessCorrect => l10n.studyFeedbackGuessCorrectMessage,
      StudyFeedbackCopy.guessIncorrect =>
        l10n.studyFeedbackGuessIncorrectMessage(resolvedAnswer),
      StudyFeedbackCopy.matchCorrect => l10n.studyFeedbackMatchCorrectMessage,
      StudyFeedbackCopy.matchIncorrect =>
        l10n.studyFeedbackMatchIncorrectMessage,
      StudyFeedbackCopy.exactRecall => l10n.studyFeedbackExactRecallMessage,
      StudyFeedbackCopy.keepWorking => l10n.studyFeedbackKeepWorkingMessage(
        resolvedAnswer,
      ),
    };
  }
}

extension StudyHistoryStatusL10n on StudyHistoryStatus {
  String label(AppLocalizations l10n) {
    switch (this) {
      case StudyHistoryStatus.completed:
        return l10n.studyHistoryCompleted;
      case StudyHistoryStatus.resumed:
        return l10n.studyHistoryResumed;
      case StudyHistoryStatus.interrupted:
        return l10n.studyHistoryInterrupted;
    }
  }
}
