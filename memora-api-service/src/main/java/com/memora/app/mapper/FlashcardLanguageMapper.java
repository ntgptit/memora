package com.memora.app.mapper;

import com.memora.app.dto.response.flashcard_language.FlashcardLanguageResponse;
import com.memora.app.entity.FlashcardLanguageEntity;

import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.mapstruct.ReportingPolicy;

@Mapper(
    componentModel = MappingConstants.ComponentModel.SPRING,
    unmappedSourcePolicy = ReportingPolicy.IGNORE,
    unmappedTargetPolicy = ReportingPolicy.IGNORE
)
public interface FlashcardLanguageMapper {

    FlashcardLanguageResponse toDto(FlashcardLanguageEntity entity);

    FlashcardLanguageEntity toEntity(FlashcardLanguageResponse dto);
}
