package com.memora.app.mapper;

import com.memora.app.dto.DeckDto;
import com.memora.app.entity.DeckEntity;

import lombok.experimental.UtilityClass;

@UtilityClass
public class DeckMapper {

    public DeckDto toDto(final DeckEntity entity) {
        if (entity == null) {
            return null;
        }
        return new DeckDto(
            entity.getId(),
            entity.getUserId(),
            entity.getFolderId(),
            entity.getName(),
            entity.getDescription(),
            entity.getDeletedAt(),
            entity.getCreatedAt(),
            entity.getUpdatedAt(),
            entity.getVersion()
        );
    }

    public DeckEntity toEntity(final DeckDto dto) {
        if (dto == null) {
            return null;
        }
        final DeckEntity entity = new DeckEntity();
        entity.setId(dto.id());
        entity.setUserId(dto.userId());
        entity.setFolderId(dto.folderId());
        entity.setName(dto.name());
        entity.setDescription(dto.description());
        entity.setDeletedAt(dto.deletedAt());
        entity.setCreatedAt(dto.createdAt());
        entity.setUpdatedAt(dto.updatedAt());
        entity.setVersion(dto.version());
        return entity;
    }
}
