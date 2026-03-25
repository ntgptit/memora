package com.memora.app.dto.request.flashcard_language;

import com.memora.app.constant.ApiValidationMessage;
import com.memora.app.constant.ValidationSizeConstant;
import com.memora.app.enums.flashcard.FlashcardSide;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

public record CreateFlashcardLanguageRequest(
    @NotNull(message = ApiValidationMessage.NOT_NULL)
    @Positive(message = ApiValidationMessage.POSITIVE)
    Long flashcardId,
    @NotNull(message = ApiValidationMessage.NOT_NULL)
    FlashcardSide side,
    @NotBlank(message = ApiValidationMessage.NOT_BLANK)
    @Size(max = ValidationSizeConstant.LANGUAGE_CODE_MAX_LENGTH, message = ApiValidationMessage.SIZE_MAX_16)
    String languageCode,
    @Size(max = ValidationSizeConstant.PRONUNCIATION_MAX_LENGTH, message = ApiValidationMessage.SIZE_MAX_400)
    String pronunciation
) {
}


