package com.memora.app.dto.response.user_account;

import java.time.OffsetDateTime;

import com.memora.app.enums.user_account.AccountStatus;

public record UserAccountResponse(
    Long id,
    String username,
    String email,
    AccountStatus accountStatus,
    OffsetDateTime deletedAt,
    OffsetDateTime createdAt,
    OffsetDateTime updatedAt,
    Long version
) {
}



