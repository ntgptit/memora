package com.memora.app.dto;

import java.time.OffsetDateTime;

public record ReviewProfileBoxDto(
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
