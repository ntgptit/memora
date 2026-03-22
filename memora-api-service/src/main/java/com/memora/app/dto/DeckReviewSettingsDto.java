package com.memora.app.dto;

import java.time.OffsetDateTime;

public record DeckReviewSettingsDto(
    Long id,
    Long deckId,
    Long reviewProfileId,
    Integer newCardsPerDay,
    Integer reviewsPerDay,
    boolean burySiblings,
    Integer leechThreshold,
    boolean suspendLeechCards,
    OffsetDateTime createdAt,
    OffsetDateTime updatedAt,
    Long version
) {
}
