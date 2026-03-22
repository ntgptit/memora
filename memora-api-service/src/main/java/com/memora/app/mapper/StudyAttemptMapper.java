package com.memora.app.mapper;

import com.memora.app.dto.StudyAttemptDto;
import com.memora.app.entity.StudyAttemptEntity;

import lombok.experimental.UtilityClass;

@UtilityClass
public class StudyAttemptMapper {

    public StudyAttemptDto toDto(final StudyAttemptEntity entity) {
        if (entity == null) {
            return null;
        }
        return new StudyAttemptDto(
            entity.getId(),
            entity.getStudySessionId(),
            entity.getFlashcardId(),
            entity.getStudyMode(),
            entity.getReviewOutcome(),
            entity.getSubmittedAnswer(),
            entity.getCreatedAt()
        );
    }

    public StudyAttemptEntity toEntity(final StudyAttemptDto dto) {
        if (dto == null) {
            return null;
        }
        final StudyAttemptEntity entity = new StudyAttemptEntity();
        entity.setId(dto.id());
        entity.setStudySessionId(dto.studySessionId());
        entity.setFlashcardId(dto.flashcardId());
        entity.setStudyMode(dto.studyMode());
        entity.setReviewOutcome(dto.reviewOutcome());
        entity.setSubmittedAnswer(dto.submittedAnswer());
        entity.setCreatedAt(dto.createdAt());
        return entity;
    }
}
