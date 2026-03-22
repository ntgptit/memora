package com.memora.app.dto;

import java.time.OffsetDateTime;

import com.memora.app.enums.ReviewOutcome;

public record StudySessionItemDto(
    Long id,
    Long studySessionId,
    Long flashcardId,
    Integer sequenceIndex,
    String termSnapshot,
    String meaningSnapshot,
    String noteSnapshot,
    String termPronunciationSnapshot,
    String meaningPronunciationSnapshot,
    ReviewOutcome lastOutcome,
    boolean currentModeCompleted,
    boolean retryPending,
    Integer incorrectAttemptCount,
    OffsetDateTime createdAt,
    OffsetDateTime updatedAt,
    Long version
) {
}
