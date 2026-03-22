package com.memora.app.dto;

import java.time.OffsetDateTime;

public record FlashcardDto(
    Long id,
    Long deckId,
    String term,
    String meaning,
    String note,
    boolean bookmarked,
    OffsetDateTime deletedAt,
    OffsetDateTime createdAt,
    OffsetDateTime updatedAt,
    Long version
) {
}
