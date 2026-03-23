package com.memora.app.exception;

import com.memora.app.constant.ApiErrorCode;

import org.springframework.http.HttpStatus;

public class UnauthorizedException extends ApiException {

    private static final long serialVersionUID = 1L;

    public UnauthorizedException(final String messageKey, final Object... messageArguments) {
        super(HttpStatus.UNAUTHORIZED, ApiErrorCode.UNAUTHORIZED, messageKey, messageArguments);
    }
}
