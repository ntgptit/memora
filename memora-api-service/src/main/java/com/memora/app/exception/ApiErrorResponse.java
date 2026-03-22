package com.memora.app.exception;

import java.time.OffsetDateTime;
import java.util.List;

public record ApiErrorResponse(
    String code,
    String message,
    List<ApiErrorField> fieldErrors,
    OffsetDateTime timestamp
) {
}
