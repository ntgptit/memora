package com.memora.app.dto;

import java.time.OffsetDateTime;

import com.memora.app.enums.TokenStatus;

public record RefreshTokenDto(
    Long id,
    Long userId,
    String tokenHash,
    TokenStatus tokenStatus,
    OffsetDateTime expiresAt,
    OffsetDateTime revokedAt,
    String deviceLabel,
    OffsetDateTime createdAt,
    OffsetDateTime updatedAt,
    Long version
) {
}
