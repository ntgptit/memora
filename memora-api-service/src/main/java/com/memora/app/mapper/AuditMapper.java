package com.memora.app.mapper;

import com.memora.app.dto.common.AuditDto;
import com.memora.app.entity.common.SoftDeletableAuditableEntity;

import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;

@Mapper(componentModel = MappingConstants.ComponentModel.SPRING)
public interface AuditMapper {

    AuditDto toDto(SoftDeletableAuditableEntity entity);
}
