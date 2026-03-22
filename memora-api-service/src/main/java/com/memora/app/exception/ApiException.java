package com.memora.app.exception;

import org.springframework.http.HttpStatus;

public class ApiException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    private final String code;
    private final HttpStatus httpStatus;
    private final String messageKey;
    private final Object[] messageArguments;

    public ApiException(
        final HttpStatus httpStatus,
        final String code,
        final String messageKey,
        final Object... messageArguments
    ) {
        super(messageKey);
        this.httpStatus = httpStatus;
        this.code = code;
        this.messageKey = messageKey;
        this.messageArguments = messageArguments == null ? new Object[0] : messageArguments.clone();
    }

    public String getCode() {
        return code;
    }

    public HttpStatus getHttpStatus() {
        return httpStatus;
    }

    public String getMessageKey() {
        return messageKey;
    }

    public Object[] getMessageArguments() {
        return messageArguments.clone();
    }
}
