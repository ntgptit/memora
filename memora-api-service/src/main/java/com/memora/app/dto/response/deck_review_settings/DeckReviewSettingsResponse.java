package com.memora.app.dto.response.deck_review_settings;

import java.time.OffsetDateTime;

public record DeckReviewSettingsResponse(
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



