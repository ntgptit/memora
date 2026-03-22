package com.memora.app.mapper;

import com.memora.app.dto.UserAccountDto;
import com.memora.app.entity.UserAccountEntity;

import lombok.experimental.UtilityClass;

@UtilityClass
public class UserAccountMapper {

    public UserAccountDto toDto(final UserAccountEntity entity) {
        if (entity == null) {
            return null;
        }
        return new UserAccountDto(
            entity.getId(),
            entity.getUsername(),
            entity.getEmail(),
            entity.getAccountStatus(),
            entity.getDeletedAt(),
            entity.getCreatedAt(),
            entity.getUpdatedAt(),
            entity.getVersion()
        );
    }

    public UserAccountEntity toEntity(final UserAccountDto dto) {
        if (dto == null) {
            return null;
        }
        final UserAccountEntity entity = new UserAccountEntity();
        entity.setId(dto.id());
        entity.setUsername(dto.username());
        entity.setEmail(dto.email());
        entity.setAccountStatus(dto.accountStatus());
        entity.setDeletedAt(dto.deletedAt());
        entity.setCreatedAt(dto.createdAt());
        entity.setUpdatedAt(dto.updatedAt());
        entity.setVersion(dto.version());
        return entity;
    }
}
