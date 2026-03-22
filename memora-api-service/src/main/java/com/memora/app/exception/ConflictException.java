package com.memora.app.exception;

import com.memora.app.constant.ApiErrorCode;

import org.springframework.http.HttpStatus;

public class ConflictException extends ApiException {

    private static final long serialVersionUID = 1L;

    public ConflictException(final String messageKey, final Object... messageArguments) {
        super(HttpStatus.CONFLICT, ApiErrorCode.CONFLICT, messageKey, messageArguments);
    }
}
