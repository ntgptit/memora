package com.memora.app.security;

import com.memora.app.enums.AccountStatus;

public record AuthenticatedUser(
    Long userId,
    String username,
    String email,
    AccountStatus accountStatus
) {
}
