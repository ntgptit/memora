package com.memora.app.mapper;

import com.memora.app.dto.ReviewProfileDto;
import com.memora.app.entity.ReviewProfileEntity;

import lombok.experimental.UtilityClass;

@UtilityClass
public class ReviewProfileMapper {

    public ReviewProfileDto toDto(final ReviewProfileEntity entity) {
        if (entity == null) {
            return null;
        }
        return new ReviewProfileDto(
            entity.getId(),
            entity.getOwnerUserId(),
            entity.getName(),
            entity.getDescription(),
            entity.getAlgorithmType(),
            entity.isSystemProfile(),
            entity.isDefaultProfile(),
            entity.getCreatedAt(),
            entity.getUpdatedAt(),
            entity.getVersion()
        );
    }

    public ReviewProfileEntity toEntity(final ReviewProfileDto dto) {
        if (dto == null) {
            return null;
        }
        final ReviewProfileEntity entity = new ReviewProfileEntity();
        entity.setId(dto.id());
        entity.setOwnerUserId(dto.ownerUserId());
        entity.setName(dto.name());
        entity.setDescription(dto.description());
        entity.setAlgorithmType(dto.algorithmType());
        entity.setSystemProfile(dto.systemProfile());
        entity.setDefaultProfile(dto.defaultProfile());
        entity.setCreatedAt(dto.createdAt());
        entity.setUpdatedAt(dto.updatedAt());
        entity.setVersion(dto.version());
        return entity;
    }
}
