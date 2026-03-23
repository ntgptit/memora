package com.memora.app.dto;

import com.memora.app.constant.ApiValidationMessage;
import com.memora.app.constant.ValidationSizeConstant;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record AuthLoginRequest(
    @NotBlank(message = ApiValidationMessage.NOT_BLANK)
    String identifier,
    @NotBlank(message = ApiValidationMessage.NOT_BLANK)
    @Size(
        min = ValidationSizeConstant.PASSWORD_MIN_LENGTH,
        max = ValidationSizeConstant.PASSWORD_MAX_LENGTH,
        message = ApiValidationMessage.SIZE_BETWEEN_8_AND_240
    )
    String password
) {
}
