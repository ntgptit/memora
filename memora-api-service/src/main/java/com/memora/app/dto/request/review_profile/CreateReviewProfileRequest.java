package com.memora.app.dto.request.review_profile;

import com.memora.app.constant.ApiValidationMessage;
import com.memora.app.constant.ValidationSizeConstant;
import com.memora.app.enums.review.ReviewAlgorithmType;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

public record CreateReviewProfileRequest(
    @NotNull(message = ApiValidationMessage.NOT_NULL)
    @Positive(message = ApiValidationMessage.POSITIVE)
    Long ownerUserId,
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


