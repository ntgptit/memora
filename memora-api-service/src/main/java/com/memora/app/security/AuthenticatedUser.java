package com.memora.app.security;

import com.memora.app.enums.user_account.AccountStatus;

public record AuthenticatedUser(
    Long userId,
    String username,
    String email,
    AccountStatus accountStatus
) {
}
