package com.memora.app.mapper;

import com.memora.app.dto.AuthUserDto;
import com.memora.app.entity.UserAccountEntity;
import com.memora.app.security.AuthenticatedUser;

import lombok.experimental.UtilityClass;

@UtilityClass
public class AuthUserMapper {

    public static AuthUserDto toDto(final UserAccountEntity entity) {
        if (entity == null) {
            return null;
        }

        return new AuthUserDto(
            entity.getId(),
            entity.getUsername(),
            entity.getEmail(),
            entity.getAccountStatus()
        );
    }

    public static AuthUserDto toDto(final AuthenticatedUser authenticatedUser) {
        if (authenticatedUser == null) {
            return null;
        }

        return new AuthUserDto(
            authenticatedUser.userId(),
            authenticatedUser.username(),
            authenticatedUser.email(),
            authenticatedUser.accountStatus()
        );
    }
}
