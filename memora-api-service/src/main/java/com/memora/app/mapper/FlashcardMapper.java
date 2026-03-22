package com.memora.app.mapper;

import com.memora.app.dto.FlashcardDto;
import com.memora.app.entity.FlashcardEntity;

import lombok.experimental.UtilityClass;

@UtilityClass
public class FlashcardMapper {

    public FlashcardDto toDto(final FlashcardEntity entity) {
        if (entity == null) {
            return null;
        }
        return new FlashcardDto(
            entity.getId(),
            entity.getDeckId(),
            entity.getTerm(),
            entity.getMeaning(),
            entity.getNote(),
            entity.isBookmarked(),
            entity.getDeletedAt(),
            entity.getCreatedAt(),
            entity.getUpdatedAt(),
            entity.getVersion()
        );
    }

    public FlashcardEntity toEntity(final FlashcardDto dto) {
        if (dto == null) {
            return null;
        }
        final FlashcardEntity entity = new FlashcardEntity();
        entity.setId(dto.id());
        entity.setDeckId(dto.deckId());
        entity.setTerm(dto.term());
        entity.setMeaning(dto.meaning());
        entity.setNote(dto.note());
        entity.setBookmarked(dto.bookmarked());
        entity.setDeletedAt(dto.deletedAt());
        entity.setCreatedAt(dto.createdAt());
        entity.setUpdatedAt(dto.updatedAt());
        entity.setVersion(dto.version());
        return entity;
    }
}
