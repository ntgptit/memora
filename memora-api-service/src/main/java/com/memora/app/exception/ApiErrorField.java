package com.memora.app.exception;

public record ApiErrorField(
    String field,
    String message
) {
}
