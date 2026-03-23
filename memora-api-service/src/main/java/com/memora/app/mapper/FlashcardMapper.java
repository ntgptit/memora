package com.memora.app.mapper;

import com.memora.app.dto.FlashcardDto;
import com.memora.app.entity.FlashcardEntity;

import lombok.experimental.UtilityClass;

@UtilityClass
public class FlashcardMapper {

    public FlashcardDto toDto(
        final FlashcardEntity entity,
        final String frontLangCode,
        final String backLangCode,
        final String pronunciation
    ) {
        if (entity == null) {
            return null;
        }
        return new FlashcardDto(
            entity.getId(),
            entity.getDeckId(),
            entity.getTerm(),
            entity.getMeaning(),
            frontLangCode,
            backLangCode,
            pronunciation,
            entity.getNote(),
            entity.isBookmarked(),
            new com.memora.app.dto.AuditDto(
                entity.getCreatedAt(),
                entity.getUpdatedAt(),
                entity.getDeletedAt(),
                entity.getVersion()
            )
        );
    }

    public FlashcardEntity toEntity(final FlashcardDto dto) {
        if (dto == null) {
            return null;
        }
        final FlashcardEntity entity = new FlashcardEntity();
        entity.setId(dto.id());
        entity.setDeckId(dto.deckId());
        entity.setTerm(dto.frontText());
        entity.setMeaning(dto.backText());
        entity.setNote(dto.note());
        entity.setBookmarked(dto.isBookmarked());
        if (dto.audit() != null) {
            entity.setCreatedAt(dto.audit().createdAt());
            entity.setUpdatedAt(dto.audit().updatedAt());
            entity.setDeletedAt(dto.audit().deletedAt());
            entity.setVersion(dto.audit().version());
        }
        return entity;
    }
}
