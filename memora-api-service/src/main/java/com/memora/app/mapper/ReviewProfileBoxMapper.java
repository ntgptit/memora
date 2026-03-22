package com.memora.app.mapper;

import com.memora.app.dto.ReviewProfileBoxDto;
import com.memora.app.entity.ReviewProfileBoxEntity;

import lombok.experimental.UtilityClass;

@UtilityClass
public class ReviewProfileBoxMapper {

    public ReviewProfileBoxDto toDto(final ReviewProfileBoxEntity entity) {
        if (entity == null) {
            return null;
        }
        return new ReviewProfileBoxDto(
            entity.getId(),
            entity.getReviewProfileId(),
            entity.getBoxNumber(),
            entity.getIntervalSeconds(),
            entity.getIncorrectBoxNumber(),
            entity.getCorrectBoxNumber(),
            entity.getCreatedAt(),
            entity.getUpdatedAt(),
            entity.getVersion()
        );
    }

    public ReviewProfileBoxEntity toEntity(final ReviewProfileBoxDto dto) {
        if (dto == null) {
            return null;
        }
        final ReviewProfileBoxEntity entity = new ReviewProfileBoxEntity();
        entity.setId(dto.id());
        entity.setReviewProfileId(dto.reviewProfileId());
        entity.setBoxNumber(dto.boxNumber());
        entity.setIntervalSeconds(dto.intervalSeconds());
        entity.setIncorrectBoxNumber(dto.incorrectBoxNumber());
        entity.setCorrectBoxNumber(dto.correctBoxNumber());
        entity.setCreatedAt(dto.createdAt());
        entity.setUpdatedAt(dto.updatedAt());
        entity.setVersion(dto.version());
        return entity;
    }
}
