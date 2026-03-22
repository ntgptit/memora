package com.memora.app.mapper;

import com.memora.app.dto.FlashcardLanguageDto;
import com.memora.app.entity.FlashcardLanguageEntity;

import lombok.experimental.UtilityClass;

@UtilityClass
public class FlashcardLanguageMapper {

    public FlashcardLanguageDto toDto(final FlashcardLanguageEntity entity) {
        if (entity == null) {
            return null;
        }
        return new FlashcardLanguageDto(
            entity.getId(),
            entity.getFlashcardId(),
            entity.getSide(),
            entity.getLanguageCode(),
            entity.getPronunciation(),
            entity.getCreatedAt(),
            entity.getUpdatedAt(),
            entity.getVersion()
        );
    }

    public FlashcardLanguageEntity toEntity(final FlashcardLanguageDto dto) {
        if (dto == null) {
            return null;
        }
        final FlashcardLanguageEntity entity = new FlashcardLanguageEntity();
        entity.setId(dto.id());
        entity.setFlashcardId(dto.flashcardId());
        entity.setSide(dto.side());
        entity.setLanguageCode(dto.languageCode());
        entity.setPronunciation(dto.pronunciation());
        entity.setCreatedAt(dto.createdAt());
        entity.setUpdatedAt(dto.updatedAt());
        entity.setVersion(dto.version());
        return entity;
    }
}
