package com.memora.app.dto.request.auth;

import com.memora.app.constant.ApiValidationMessage;

import jakarta.validation.constraints.NotBlank;

public record AuthLogoutRequest(
    @NotBlank(message = ApiValidationMessage.NOT_BLANK)
    String refreshToken
) {
}


