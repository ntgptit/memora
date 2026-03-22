package com.memora.app.dto;

import java.time.OffsetDateTime;

public record DeckDto(
    Long id,
    Long userId,
    Long folderId,
    String name,
    String description,
    OffsetDateTime deletedAt,
    OffsetDateTime createdAt,
    OffsetDateTime updatedAt,
    Long version
) {
}
