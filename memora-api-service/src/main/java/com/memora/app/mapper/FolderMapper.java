package com.memora.app.mapper;

import com.memora.app.dto.response.folder.FolderResponse;
import com.memora.app.entity.FolderEntity;

import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.MappingConstants;
import org.mapstruct.ReportingPolicy;

@Mapper(
    componentModel = MappingConstants.ComponentModel.SPRING,
    uses = AuditMapper.class,
    unmappedSourcePolicy = ReportingPolicy.IGNORE,
    unmappedTargetPolicy = ReportingPolicy.IGNORE
)
public interface FolderMapper {

    @Mapping(target = "colorHex", source = "colorHex")
    @Mapping(target = "childFolderCount", source = "childFolderCount")
    @Mapping(target = "audit", source = "entity")
    FolderResponse toDto(FolderEntity entity, String colorHex, Long childFolderCount);

    FolderEntity toEntity(FolderResponse dto);
}
