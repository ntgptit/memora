package com.memora.app.dto;

import com.memora.app.constant.ApiValidationMessage;
import com.memora.app.constant.ValidationSizeConstant;
import com.memora.app.enums.ReviewAlgorithmType;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

public record UpdateReviewProfileRequest(
    @NotBlank(message = ApiValidationMessage.NOT_BLANK)
    @Size(max = ValidationSizeConstant.REVIEW_PROFILE_NAME_MAX_LENGTH, message = ApiValidationMessage.SIZE_MAX_120)
    String name,
    @Size(max = ValidationSizeConstant.DESCRIPTION_MAX_LENGTH, message = ApiValidationMessage.SIZE_MAX_400)
    String description,
    @NotNull(message = ApiValidationMessage.NOT_NULL)
    ReviewAlgorithmType algorithmType,
    boolean defaultProfile
) {
}
