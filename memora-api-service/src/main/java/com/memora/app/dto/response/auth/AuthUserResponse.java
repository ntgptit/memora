package com.memora.app.dto.response.auth;

import com.memora.app.enums.user_account.AccountStatus;

public record AuthUserResponse(
    Long id,
    String username,
    String email,
    AccountStatus accountStatus
) {
}



