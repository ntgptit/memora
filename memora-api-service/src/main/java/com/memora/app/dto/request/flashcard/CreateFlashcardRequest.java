package com.memora.app.dto.request.flashcard;

import com.memora.app.constant.ApiValidationMessage;
import com.memora.app.constant.ValidationSizeConstant;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record CreateFlashcardRequest(
    @NotBlank(message = ApiValidationMessage.NOT_BLANK)
    @Size(
        max = ValidationSizeConstant.FLASHCARD_FRONT_TEXT_MAX_LENGTH,
        message = ApiValidationMessage.SIZE_MAX_300
    )
    String term,
    @NotBlank(message = ApiValidationMessage.NOT_BLANK)
    @Size(
        max = ValidationSizeConstant.FLASHCARD_BACK_TEXT_MAX_LENGTH,
        message = ApiValidationMessage.SIZE_MAX_2000
    )
    String meaning,
    @Size(max = ValidationSizeConstant.LANGUAGE_CODE_MAX_LENGTH, message = ApiValidationMessage.SIZE_MAX_16)
    String frontLangCode,
    @Size(max = ValidationSizeConstant.LANGUAGE_CODE_MAX_LENGTH, message = ApiValidationMessage.SIZE_MAX_16)
    String backLangCode
) {
}


