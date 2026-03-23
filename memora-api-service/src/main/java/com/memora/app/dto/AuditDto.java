package com.memora.app.dto;

import java.time.OffsetDateTime;

public record AuditDto(
    OffsetDateTime createdAt,
    OffsetDateTime updatedAt,
    OffsetDateTime deletedAt,
    Long version
) {
}
