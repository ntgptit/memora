package com.memora.app.mapper;

import com.memora.app.dto.StudySessionDto;
import com.memora.app.entity.StudySessionEntity;

import lombok.experimental.UtilityClass;

@UtilityClass
public class StudySessionMapper {

    public StudySessionDto toDto(final StudySessionEntity entity) {
        if (entity == null) {
            return null;
        }
        return new StudySessionDto(
            entity.getId(),
            entity.getUserId(),
            entity.getDeckId(),
            entity.getReviewProfileId(),
            entity.getSessionType(),
            entity.getModePlan(),
            entity.getCurrentModeIndex(),
            entity.getSessionState(),
            entity.getCurrentItemIndex(),
            entity.getCreatedAt(),
            entity.getUpdatedAt(),
            entity.getVersion()
        );
    }

    public StudySessionEntity toEntity(final StudySessionDto dto) {
        if (dto == null) {
            return null;
        }
        final StudySessionEntity entity = new StudySessionEntity();
        entity.setId(dto.id());
        entity.setUserId(dto.userId());
        entity.setDeckId(dto.deckId());
        entity.setReviewProfileId(dto.reviewProfileId());
        entity.setSessionType(dto.sessionType());
        entity.setModePlan(dto.modePlan());
        entity.setCurrentModeIndex(dto.currentModeIndex());
        entity.setSessionState(dto.sessionState());
        entity.setCurrentItemIndex(dto.currentItemIndex());
        entity.setCreatedAt(dto.createdAt());
        entity.setUpdatedAt(dto.updatedAt());
        entity.setVersion(dto.version());
        return entity;
    }
}
