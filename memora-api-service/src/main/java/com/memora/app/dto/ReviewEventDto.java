package com.memora.app.dto;

import java.time.OffsetDateTime;

import com.fasterxml.jackson.databind.JsonNode;
import com.memora.app.enums.ReviewEventType;
import com.memora.app.enums.ReviewOutcome;
import com.memora.app.enums.ReviewStateStatus;

public record ReviewEventDto(
    Long id,
    Long userId,
    Long flashcardId,
    Long reviewProfileId,
    Long studyAttemptId,
    ReviewEventType eventType,
    ReviewStateStatus stateStatusBefore,
    ReviewStateStatus stateStatusAfter,
    Integer boxBefore,
    Integer boxAfter,
    OffsetDateTime dueAtBefore,
    OffsetDateTime dueAtAfter,
    ReviewOutcome reviewOutcome,
    Long intervalSecondsApplied,
    JsonNode algorithmSnapshotJson,
    OffsetDateTime createdAt
) {
}
