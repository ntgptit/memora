package com.memora.app.exception;

import com.memora.app.constant.ApiErrorCode;

import org.springframework.http.HttpStatus;

public class ResourceNotFoundException extends ApiException {

    private static final long serialVersionUID = 1L;

    public ResourceNotFoundException(final String messageKey, final Object... messageArguments) {
        super(HttpStatus.NOT_FOUND, ApiErrorCode.RESOURCE_NOT_FOUND, messageKey, messageArguments);
    }
}
