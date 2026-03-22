package com.memora.app.dto;

import java.time.OffsetDateTime;

import com.memora.app.enums.ReviewOutcome;
import com.memora.app.enums.ReviewStateStatus;

public record ReviewCardStateDto(
    Long id,
    Long userId,
    Long flashcardId,
    Long reviewProfileId,
    ReviewStateStatus stateStatus,
    Integer currentBoxNumber,
    OffsetDateTime dueAt,
    OffsetDateTime lastReviewedAt,
    ReviewOutcome lastOutcome,
    Integer successStreak,
    Integer lapseCount,
    Integer reviewCount,
    OffsetDateTime suspendedAt,
    OffsetDateTime createdAt,
    OffsetDateTime updatedAt,
    Long version
) {
}
