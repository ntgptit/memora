package com.memora.app.mapper;

import com.memora.app.dto.response.deck.DeckResponse;
import com.memora.app.entity.DeckEntity;

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
public interface DeckMapper {

    @Mapping(target = "flashcardCount", source = "flashcardCount")
    @Mapping(target = "audit", source = "entity")
    DeckResponse toDto(DeckEntity entity, Long flashcardCount);

    DeckEntity toEntity(DeckResponse dto);
}
