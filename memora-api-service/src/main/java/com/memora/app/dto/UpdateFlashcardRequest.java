package com.memora.app.dto;

import com.memora.app.constant.ApiValidationMessage;
import com.memora.app.constant.ValidationSizeConstant;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

public record UpdateFlashcardRequest(
    @NotNull(message = ApiValidationMessage.NOT_NULL)
    @Positive(message = ApiValidationMessage.POSITIVE)
    Long deckId,
    @NotBlank(message = ApiValidationMessage.NOT_BLANK)
    @Size(max = ValidationSizeConstant.FLASHCARD_TERM_MAX_LENGTH, message = ApiValidationMessage.SIZE_MAX_300)
    String term,
    @NotBlank(message = ApiValidationMessage.NOT_BLANK)
    String meaning,
    String note,
    @NotNull(message = ApiValidationMessage.NOT_NULL)
    Boolean bookmarked
) {
}
