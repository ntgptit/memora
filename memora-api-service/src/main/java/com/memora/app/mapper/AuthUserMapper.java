package com.memora.app.mapper;

import com.memora.app.dto.response.auth.AuthUserResponse;
import com.memora.app.entity.UserAccountEntity;
import com.memora.app.security.AuthenticatedUser;

import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.mapstruct.ReportingPolicy;

@Mapper(
    componentModel = MappingConstants.ComponentModel.SPRING,
    unmappedSourcePolicy = ReportingPolicy.IGNORE,
    unmappedTargetPolicy = ReportingPolicy.IGNORE
)
public interface AuthUserMapper {

    AuthUserResponse toDto(UserAccountEntity entity);

    default AuthUserResponse toDto(final AuthenticatedUser authenticatedUser) {
        return new AuthUserResponse(
            authenticatedUser.userId(),
            authenticatedUser.username(),
            authenticatedUser.email(),
            authenticatedUser.accountStatus()
        );
    }
}
