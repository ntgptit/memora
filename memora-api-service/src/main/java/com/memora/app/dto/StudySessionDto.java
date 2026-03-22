package com.memora.app.dto;

import java.time.OffsetDateTime;

import com.fasterxml.jackson.databind.JsonNode;
import com.memora.app.enums.StudySessionState;
import com.memora.app.enums.StudySessionType;

public record StudySessionDto(
    Long id,
    Long userId,
    Long deckId,
    Long reviewProfileId,
    StudySessionType sessionType,
    JsonNode modePlan,
    Integer currentModeIndex,
    StudySessionState sessionState,
    Integer currentItemIndex,
    OffsetDateTime createdAt,
    OffsetDateTime updatedAt,
    Long version
) {
}
