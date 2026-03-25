package com.memora.app.dto.request.folder;

import com.memora.app.constant.ApiValidationMessage;
import com.memora.app.constant.ValidationSizeConstant;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public record RenameFolderRequest(
    @NotBlank(message = ApiValidationMessage.NOT_BLANK)
    @Size(max = ValidationSizeConstant.FOLDER_NAME_MAX_LENGTH, message = ApiValidationMessage.SIZE_MAX_120)
    String name
) {
}


