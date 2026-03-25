package com.memora.app.mapper;

import com.memora.app.dto.response.review_profile.ReviewProfileResponse;
import com.memora.app.entity.ReviewProfileEntity;

import org.mapstruct.Mapper;
import org.mapstruct.MappingConstants;
import org.mapstruct.ReportingPolicy;

@Mapper(
    componentModel = MappingConstants.ComponentModel.SPRING,
    unmappedSourcePolicy = ReportingPolicy.IGNORE,
    unmappedTargetPolicy = ReportingPolicy.IGNORE
)
public interface ReviewProfileMapper {

    ReviewProfileResponse toDto(ReviewProfileEntity entity);

    ReviewProfileEntity toEntity(ReviewProfileResponse dto);
}
