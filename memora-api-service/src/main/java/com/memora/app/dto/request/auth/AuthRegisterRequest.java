package com.memora.app.dto.request.auth;

import com.memora.app.constant.ApiValidationMessage;
import com.memora.app.constant.ValidationRegexConstant;
import com.memora.app.constant.ValidationSizeConstant;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record AuthRegisterRequest(
    @NotBlank(message = ApiValidationMessage.NOT_BLANK)
    @Size(
        min = ValidationSizeConstant.USERNAME_MIN_LENGTH,
        max = ValidationSizeConstant.USERNAME_MAX_LENGTH,
        message = ApiValidationMessage.SIZE_BETWEEN_3_AND_40
    )
    @Pattern(regexp = ValidationRegexConstant.USERNAME, message = ApiValidationMessage.PATTERN_USERNAME)
    String username,
    @NotBlank(message = ApiValidationMessage.NOT_BLANK)
    @Email(message = ApiValidationMessage.EMAIL)
    @Size(max = ValidationSizeConstant.EMAIL_MAX_LENGTH, message = ApiValidationMessage.SIZE_MAX_120)
    String email,
    @NotBlank(message = ApiValidationMessage.NOT_BLANK)
    @Size(
        min = ValidationSizeConstant.PASSWORD_MIN_LENGTH,
        max = ValidationSizeConstant.PASSWORD_MAX_LENGTH,
        message = ApiValidationMessage.SIZE_BETWEEN_8_AND_240
    )
    String password
) {
}


