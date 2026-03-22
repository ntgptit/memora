package com.memora.app.dto;

import java.time.OffsetDateTime;

import com.memora.app.enums.ReviewOutcome;
import com.memora.app.enums.StudyMode;

public record StudyAttemptDto(
    Long id,
    Long studySessionId,
    Long flashcardId,
    StudyMode studyMode,
    ReviewOutcome reviewOutcome,
    String submittedAnswer,
    OffsetDateTime createdAt
) {
}
