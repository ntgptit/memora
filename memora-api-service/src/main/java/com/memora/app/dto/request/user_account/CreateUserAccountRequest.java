package com.memora.app.dto.request.user_account;

import com.memora.app.constant.ApiValidationMessage;
import com.memora.app.constant.ValidationSizeConstant;
import com.memora.app.enums.user_account.AccountStatus;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record CreateUserAccountRequest(
    @NotBlank(message = ApiValidationMessage.NOT_BLANK)
    @Size(max = ValidationSizeConstant.USERNAME_MAX_LENGTH, message = ApiValidationMessage.SIZE_MAX_40)
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
    String password,
    AccountStatus accountStatus
) {
}


