package com.memora.app.mapper;

import com.memora.app.dto.RefreshTokenDto;
import com.memora.app.entity.RefreshTokenEntity;

import lombok.experimental.UtilityClass;

@UtilityClass
public class RefreshTokenMapper {

    public RefreshTokenDto toDto(final RefreshTokenEntity entity) {
        if (entity == null) {
            return null;
        }
        return new RefreshTokenDto(
            entity.getId(),
            entity.getUserId(),
            entity.getTokenHash(),
            entity.getTokenStatus(),
            entity.getExpiresAt(),
            entity.getRevokedAt(),
            entity.getDeviceLabel(),
            entity.getCreatedAt(),
            entity.getUpdatedAt(),
            entity.getVersion()
        );
    }

    public RefreshTokenEntity toEntity(final RefreshTokenDto dto) {
        if (dto == null) {
            return null;
        }
        final RefreshTokenEntity entity = new RefreshTokenEntity();
        entity.setId(dto.id());
        entity.setUserId(dto.userId());
        entity.setTokenHash(dto.tokenHash());
        entity.setTokenStatus(dto.tokenStatus());
        entity.setExpiresAt(dto.expiresAt());
        entity.setRevokedAt(dto.revokedAt());
        entity.setDeviceLabel(dto.deviceLabel());
        entity.setCreatedAt(dto.createdAt());
        entity.setUpdatedAt(dto.updatedAt());
        entity.setVersion(dto.version());
        return entity;
    }
}
