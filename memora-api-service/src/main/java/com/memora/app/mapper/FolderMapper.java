package com.memora.app.mapper;

import com.memora.app.dto.FolderDto;
import com.memora.app.entity.FolderEntity;

import lombok.experimental.UtilityClass;

@UtilityClass
public class FolderMapper {

    public FolderDto toDto(final FolderEntity entity, final String colorHex, final Long childFolderCount) {
        if (entity == null) {
            return null;
        }
        return new FolderDto(
            entity.getId(),
            entity.getName(),
            entity.getDescription(),
            colorHex,
            entity.getParentId(),
            entity.getDepth(),
            childFolderCount,
            new com.memora.app.dto.AuditDto(
                entity.getCreatedAt(),
                entity.getUpdatedAt(),
                entity.getDeletedAt(),
                entity.getVersion()
            )
        );
    }

    public FolderEntity toEntity(final FolderDto dto) {
        if (dto == null) {
            return null;
        }
        final FolderEntity entity = new FolderEntity();
        entity.setId(dto.id());
        entity.setParentId(dto.parentId());
        entity.setName(dto.name());
        entity.setDescription(dto.description());
        entity.setDepth(dto.depth());
        return entity;
    }
}
