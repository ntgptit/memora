package com.memora.app.mapper;

import com.memora.app.dto.ReviewEventDto;
import com.memora.app.entity.ReviewEventEntity;

import lombok.experimental.UtilityClass;

@UtilityClass
public class ReviewEventMapper {

    public ReviewEventDto toDto(final ReviewEventEntity entity) {
        if (entity == null) {
            return null;
        }
        return new ReviewEventDto(
            entity.getId(),
            entity.getUserId(),
            entity.getFlashcardId(),
            entity.getReviewProfileId(),
            entity.getStudyAttemptId(),
            entity.getEventType(),
            entity.getStateStatusBefore(),
            entity.getStateStatusAfter(),
            entity.getBoxBefore(),
            entity.getBoxAfter(),
            entity.getDueAtBefore(),
            entity.getDueAtAfter(),
            entity.getReviewOutcome(),
            entity.getIntervalSecondsApplied(),
            entity.getAlgorithmSnapshotJson(),
            entity.getCreatedAt()
        );
    }

    public ReviewEventEntity toEntity(final ReviewEventDto dto) {
        if (dto == null) {
            return null;
        }
        final ReviewEventEntity entity = new ReviewEventEntity();
        entity.setId(dto.id());
        entity.setUserId(dto.userId());
        entity.setFlashcardId(dto.flashcardId());
        entity.setReviewProfileId(dto.reviewProfileId());
        entity.setStudyAttemptId(dto.studyAttemptId());
        entity.setEventType(dto.eventType());
        entity.setStateStatusBefore(dto.stateStatusBefore());
        entity.setStateStatusAfter(dto.stateStatusAfter());
        entity.setBoxBefore(dto.boxBefore());
        entity.setBoxAfter(dto.boxAfter());
        entity.setDueAtBefore(dto.dueAtBefore());
        entity.setDueAtAfter(dto.dueAtAfter());
        entity.setReviewOutcome(dto.reviewOutcome());
        entity.setIntervalSecondsApplied(dto.intervalSecondsApplied());
        entity.setAlgorithmSnapshotJson(dto.algorithmSnapshotJson());
        entity.setCreatedAt(dto.createdAt());
        return entity;
    }
}
