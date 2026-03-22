package com.memora.app.dto;

import java.time.OffsetDateTime;

import com.memora.app.enums.FlashcardSide;

public record FlashcardLanguageDto(
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
