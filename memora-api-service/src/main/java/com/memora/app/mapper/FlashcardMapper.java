package com.memora.app.mapper;

import com.memora.app.dto.response.flashcard.FlashcardResponse;
import com.memora.app.entity.FlashcardEntity;

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
public interface FlashcardMapper {

    @Mapping(target = "frontLangCode", source = "frontLangCode")
    @Mapping(target = "backLangCode", source = "backLangCode")
    @Mapping(target = "pronunciation", source = "pronunciation")
    @Mapping(target = "audit", source = "entity")
    FlashcardResponse toDto(
        FlashcardEntity entity,
        String frontLangCode,
        String backLangCode,
        String pronunciation
    );

    FlashcardEntity toEntity(FlashcardResponse dto);
}
