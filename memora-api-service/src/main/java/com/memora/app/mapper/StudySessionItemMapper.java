package com.memora.app.mapper;

import com.memora.app.dto.StudySessionItemDto;
import com.memora.app.entity.StudySessionItemEntity;

import lombok.experimental.UtilityClass;

@UtilityClass
public class StudySessionItemMapper {

    public StudySessionItemDto toDto(final StudySessionItemEntity entity) {
        if (entity == null) {
            return null;
        }
        return new StudySessionItemDto(
            entity.getId(),
            entity.getStudySessionId(),
            entity.getFlashcardId(),
            entity.getSequenceIndex(),
            entity.getTermSnapshot(),
            entity.getMeaningSnapshot(),
            entity.getNoteSnapshot(),
            entity.getTermPronunciationSnapshot(),
            entity.getMeaningPronunciationSnapshot(),
            entity.getLastOutcome(),
            entity.isCurrentModeCompleted(),
            entity.isRetryPending(),
            entity.getIncorrectAttemptCount(),
            entity.getCreatedAt(),
            entity.getUpdatedAt(),
            entity.getVersion()
        );
    }

    public StudySessionItemEntity toEntity(final StudySessionItemDto dto) {
        if (dto == null) {
            return null;
        }
        final StudySessionItemEntity entity = new StudySessionItemEntity();
        entity.setId(dto.id());
        entity.setStudySessionId(dto.studySessionId());
        entity.setFlashcardId(dto.flashcardId());
        entity.setSequenceIndex(dto.sequenceIndex());
        entity.setTermSnapshot(dto.termSnapshot());
        entity.setMeaningSnapshot(dto.meaningSnapshot());
        entity.setNoteSnapshot(dto.noteSnapshot());
        entity.setTermPronunciationSnapshot(dto.termPronunciationSnapshot());
        entity.setMeaningPronunciationSnapshot(dto.meaningPronunciationSnapshot());
        entity.setLastOutcome(dto.lastOutcome());
        entity.setCurrentModeCompleted(dto.currentModeCompleted());
        entity.setRetryPending(dto.retryPending());
        entity.setIncorrectAttemptCount(dto.incorrectAttemptCount());
        entity.setCreatedAt(dto.createdAt());
        entity.setUpdatedAt(dto.updatedAt());
        entity.setVersion(dto.version());
        return entity;
    }
}
