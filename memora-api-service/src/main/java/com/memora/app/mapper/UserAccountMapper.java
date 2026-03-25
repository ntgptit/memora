package com.memora.app.mapper;

import com.memora.app.dto.response.user_account.UserAccountResponse;
import com.memora.app.entity.UserAccountEntity;

import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.mapstruct.ReportingPolicy;

@Mapper(
    componentModel = MappingConstants.ComponentModel.SPRING,
    unmappedSourcePolicy = ReportingPolicy.IGNORE,
    unmappedTargetPolicy = ReportingPolicy.IGNORE
)
public interface UserAccountMapper {

    UserAccountResponse toDto(UserAccountEntity entity);

    UserAccountEntity toEntity(UserAccountResponse dto);
}
