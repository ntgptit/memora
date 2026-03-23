package com.memora.app.mapper;

import com.memora.app.dto.DeckDto;
import com.memora.app.entity.DeckEntity;

import lombok.experimental.UtilityClass;

@UtilityClass
public class DeckMapper {

    public DeckDto toDto(final DeckEntity entity, final Long flashcardCount) {
        if (entity == null) {
            return null;
        }
        return new DeckDto(
            entity.getId(),
            entity.getFolderId(),
            entity.getName(),
            entity.getDescription(),
            flashcardCount,
            new com.memora.app.dto.AuditDto(
                entity.getCreatedAt(),
                entity.getUpdatedAt(),
                entity.getDeletedAt(),
                entity.getVersion()
            )
        );
    }

    public DeckEntity toEntity(final DeckDto dto) {
        if (dto == null) {
            return null;
        }
        final DeckEntity entity = new DeckEntity();
        entity.setId(dto.id());
        entity.setFolderId(dto.folderId());
        entity.setName(dto.name());
        entity.setDescription(dto.description());
        return entity;
    }
}
