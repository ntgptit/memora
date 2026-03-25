package com.memora.app.dto.response.review_profile;

import java.time.OffsetDateTime;

import com.memora.app.enums.review.ReviewAlgorithmType;

public record ReviewProfileResponse(
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



