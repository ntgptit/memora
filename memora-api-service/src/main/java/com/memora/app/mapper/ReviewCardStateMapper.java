package com.memora.app.mapper;

import com.memora.app.dto.ReviewCardStateDto;
import com.memora.app.entity.ReviewCardStateEntity;

import lombok.experimental.UtilityClass;

@UtilityClass
public class ReviewCardStateMapper {

    public ReviewCardStateDto toDto(final ReviewCardStateEntity entity) {
        if (entity == null) {
            return null;
        }
        return new ReviewCardStateDto(
            entity.getId(),
            entity.getUserId(),
            entity.getFlashcardId(),
            entity.getReviewProfileId(),
            entity.getStateStatus(),
            entity.getCurrentBoxNumber(),
            entity.getDueAt(),
            entity.getLastReviewedAt(),
            entity.getLastOutcome(),
            entity.getSuccessStreak(),
            entity.getLapseCount(),
            entity.getReviewCount(),
            entity.getSuspendedAt(),
            entity.getCreatedAt(),
            entity.getUpdatedAt(),
            entity.getVersion()
        );
    }

    public ReviewCardStateEntity toEntity(final ReviewCardStateDto dto) {
        if (dto == null) {
            return null;
        }
        final ReviewCardStateEntity entity = new ReviewCardStateEntity();
        entity.setId(dto.id());
        entity.setUserId(dto.userId());
        entity.setFlashcardId(dto.flashcardId());
        entity.setReviewProfileId(dto.reviewProfileId());
        entity.setStateStatus(dto.stateStatus());
        entity.setCurrentBoxNumber(dto.currentBoxNumber());
        entity.setDueAt(dto.dueAt());
        entity.setLastReviewedAt(dto.lastReviewedAt());
        entity.setLastOutcome(dto.lastOutcome());
        entity.setSuccessStreak(dto.successStreak());
        entity.setLapseCount(dto.lapseCount());
        entity.setReviewCount(dto.reviewCount());
        entity.setSuspendedAt(dto.suspendedAt());
        entity.setCreatedAt(dto.createdAt());
        entity.setUpdatedAt(dto.updatedAt());
        entity.setVersion(dto.version());
        return entity;
    }
}
