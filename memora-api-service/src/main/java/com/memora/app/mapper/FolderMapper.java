package com.memora.app.mapper;

import com.memora.app.dto.FolderDto;
import com.memora.app.entity.FolderEntity;

import lombok.experimental.UtilityClass;

@UtilityClass
public class FolderMapper {

    public FolderDto toDto(final FolderEntity entity) {
        if (entity == null) {
            return null;
        }
        return new FolderDto(
            entity.getId(),
            entity.getUserId(),
            entity.getParentId(),
            entity.getName(),
            entity.getDescription(),
            entity.getDepth(),
            entity.getDeletedAt(),
            entity.getCreatedAt(),
            entity.getUpdatedAt(),
            entity.getVersion()
        );
    }

    public FolderEntity toEntity(final FolderDto dto) {
        if (dto == null) {
            return null;
        }
        final FolderEntity entity = new FolderEntity();
        entity.setId(dto.id());
        entity.setUserId(dto.userId());
        entity.setParentId(dto.parentId());
        entity.setName(dto.name());
        entity.setDescription(dto.description());
        entity.setDepth(dto.depth());
        entity.setDeletedAt(dto.deletedAt());
        entity.setCreatedAt(dto.createdAt());
        entity.setUpdatedAt(dto.updatedAt());
        entity.setVersion(dto.version());
        return entity;
    }
}
