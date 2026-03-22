package com.memora.app.dto;

import java.time.OffsetDateTime;

import com.memora.app.enums.AccountStatus;

public record UserAccountDto(
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
