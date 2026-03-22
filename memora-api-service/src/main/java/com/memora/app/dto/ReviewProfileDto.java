package com.memora.app.dto;

import java.time.OffsetDateTime;

import com.memora.app.enums.ReviewAlgorithmType;

public record ReviewProfileDto(
    Long id,
    Long ownerUserId,
    String name,
    String description,
    ReviewAlgorithmType algorithmType,
    boolean systemProfile,
    boolean defaultProfile,
    OffsetDateTime createdAt,
    OffsetDateTime updatedAt,
    Long version
) {
}
