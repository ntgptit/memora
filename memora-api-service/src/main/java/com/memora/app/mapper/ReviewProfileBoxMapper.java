package com.memora.app.mapper;

import com.memora.app.dto.response.review_profile_box.ReviewProfileBoxResponse;
import com.memora.app.entity.ReviewProfileBoxEntity;

import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.mapstruct.ReportingPolicy;

@Mapper(
    componentModel = MappingConstants.ComponentModel.SPRING,
    unmappedSourcePolicy = ReportingPolicy.IGNORE,
    unmappedTargetPolicy = ReportingPolicy.IGNORE
)
public interface ReviewProfileBoxMapper {

    ReviewProfileBoxResponse toDto(ReviewProfileBoxEntity entity);

    ReviewProfileBoxEntity toEntity(ReviewProfileBoxResponse dto);
}
