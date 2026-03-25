package com.memora.app.dto.response.flashcard_language;

import java.time.OffsetDateTime;

import com.memora.app.enums.flashcard.FlashcardSide;

public record FlashcardLanguageResponse(
    Long id,
    Long flashcardId,
    FlashcardSide side,
    String languageCode,
    String pronunciation,
    OffsetDateTime createdAt,
    OffsetDateTime updatedAt,
    Long version
) {
}



