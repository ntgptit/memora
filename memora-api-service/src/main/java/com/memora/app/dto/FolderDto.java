package com.memora.app.dto;

import java.time.OffsetDateTime;

public record FolderDto(
    Long id,
    Long userId,
    Long parentId,
    String name,
    String description,
    Integer depth,
    OffsetDateTime deletedAt,
    OffsetDateTime createdAt,
    OffsetDateTime updatedAt,
    Long version
) {
}
