package com.memora.app.exception;

import com.memora.app.constant.ApiErrorCode;

import org.springframework.http.HttpStatus;

public class BadRequestException extends ApiException {

    private static final long serialVersionUID = 1L;

    public BadRequestException(final String messageKey, final Object... messageArguments) {
        super(HttpStatus.BAD_REQUEST, ApiErrorCode.BAD_REQUEST, messageKey, messageArguments);
    }
}
