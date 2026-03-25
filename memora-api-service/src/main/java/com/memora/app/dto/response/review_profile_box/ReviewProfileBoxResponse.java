package com.memora.app.dto.response.review_profile_box;

import java.time.OffsetDateTime;

public record ReviewProfileBoxResponse(
    Long id,
    Long reviewProfileId,
    Integer boxNumber,
    Long intervalSeconds,
    Integer incorrectBoxNumber,
    Integer correctBoxNumber,
    OffsetDateTime createdAt,
    OffsetDateTime updatedAt,
    Long version
) {
}



