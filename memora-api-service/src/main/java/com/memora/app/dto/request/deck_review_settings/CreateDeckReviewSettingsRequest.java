package com.memora.app.dto.request.deck_review_settings;

import com.memora.app.constant.ApiValidationMessage;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.PositiveOrZero;

public record CreateDeckReviewSettingsRequest(
    @NotNull(message = ApiValidationMessage.NOT_NULL)
    @Positive(message = ApiValidationMessage.POSITIVE)
    Long deckId,
    @NotNull(message = ApiValidationMessage.NOT_NULL)
    @Positive(message = ApiValidationMessage.POSITIVE)
    Long reviewProfileId,
    @NotNull(message = ApiValidationMessage.NOT_NULL)
    @PositiveOrZero(message = ApiValidationMessage.POSITIVE_OR_ZERO)
    Integer newCardsPerDay,
    @NotNull(message = ApiValidationMessage.NOT_NULL)
    @PositiveOrZero(message = ApiValidationMessage.POSITIVE_OR_ZERO)
    Integer reviewsPerDay,
    boolean burySiblings,
    @NotNull(message = ApiValidationMessage.NOT_NULL)
    @Positive(message = ApiValidationMessage.POSITIVE)
    Integer leechThreshold,
    boolean suspendLeechCards
) {
}


