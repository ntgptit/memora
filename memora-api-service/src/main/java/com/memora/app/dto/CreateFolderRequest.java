package com.memora.app.dto;

import com.memora.app.constant.ApiValidationMessage;
import com.memora.app.constant.ValidationSizeConstant;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

public record CreateFolderRequest(
        @NotBlank(message = ApiValidationMessage.NOT_BLANK)
        @Size(max = ValidationSizeConstant.FOLDER_NAME_MAX_LENGTH, message = ApiValidationMessage.SIZE_MAX_120) String name,
        @Size(max = ValidationSizeConstant.DESCRIPTION_MAX_LENGTH, message = ApiValidationMessage.SIZE_MAX_400) String description,
        @Positive(message = ApiValidationMessage.POSITIVE) Long parentId) {
}
