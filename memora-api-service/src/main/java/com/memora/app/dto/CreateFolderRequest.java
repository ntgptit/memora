package com.memora.app.dto;

import com.memora.app.constant.ApiValidationMessage;
import com.memora.app.constant.ValidationSizeConstant;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;

public record CreateFolderRequest(
    @NotNull(message = ApiValidationMessage.NOT_NULL)
    @Positive(message = ApiValidationMessage.POSITIVE)
    Long userId,
    @Positive(message = ApiValidationMessage.POSITIVE)
    Long parentId,
    @NotBlank(message = ApiValidationMessage.NOT_BLANK)
    @Size(max = ValidationSizeConstant.FOLDER_NAME_MAX_LENGTH, message = ApiValidationMessage.SIZE_MAX_150)
    String name,
    @Size(max = ValidationSizeConstant.DESCRIPTION_MAX_LENGTH, message = ApiValidationMessage.SIZE_MAX_400)
    String description
) {
}
