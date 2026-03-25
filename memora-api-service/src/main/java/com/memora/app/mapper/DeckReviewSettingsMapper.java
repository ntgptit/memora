package com.memora.app.mapper;

import com.memora.app.dto.response.deck_review_settings.DeckReviewSettingsResponse;
import com.memora.app.entity.DeckReviewSettingsEntity;

import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.mapstruct.ReportingPolicy;

@Mapper(
    componentModel = MappingConstants.ComponentModel.SPRING,
    unmappedSourcePolicy = ReportingPolicy.IGNORE,
    unmappedTargetPolicy = ReportingPolicy.IGNORE
)
public interface DeckReviewSettingsMapper {

    DeckReviewSettingsResponse toDto(DeckReviewSettingsEntity entity);

    DeckReviewSettingsEntity toEntity(DeckReviewSettingsResponse dto);
}
