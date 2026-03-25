package com.memora.app.dto.request.review_profile_box;

import com.memora.app.constant.ApiValidationMessage;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.PositiveOrZero;

public record CreateReviewProfileBoxRequest(
    @NotNull(message = ApiValidationMessage.NOT_NULL)
    @Positive(message = ApiValidationMessage.POSITIVE)
    Long reviewProfileId,
    @NotNull(message = ApiValidationMessage.NOT_NULL)
    @Positive(message = ApiValidationMessage.POSITIVE)
    Integer boxNumber,
    @NotNull(message = ApiValidationMessage.NOT_NULL)
    @PositiveOrZero(message = ApiValidationMessage.POSITIVE_OR_ZERO)
    Long intervalSeconds,
    @NotNull(message = ApiValidationMessage.NOT_NULL)
    @Positive(message = ApiValidationMessage.POSITIVE)
    Integer incorrectBoxNumber,
    @NotNull(message = ApiValidationMessage.NOT_NULL)
    @Positive(message = ApiValidationMessage.POSITIVE)
    Integer correctBoxNumber
) {
}


