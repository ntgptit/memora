package com.memora.app.exception;

import java.time.OffsetDateTime;
import java.util.List;

import com.memora.app.constant.ApiErrorCode;
import com.memora.app.constant.ApiMessageKey;

import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import lombok.RequiredArgsConstructor;

@RestControllerAdvice
@RequiredArgsConstructor
public class GlobalExceptionHandler {

    private final MessageSource messageSource;

    @ExceptionHandler(ApiException.class)
    public ResponseEntity<ApiErrorResponse> handleApiException(final ApiException exception) {
        final ApiErrorResponse response = new ApiErrorResponse(
            exception.getCode(),
            resolveMessage(exception.getMessageKey(), exception.getMessageArguments()),
            List.of(),
            OffsetDateTime.now()
        );
        return ResponseEntity.status(exception.getHttpStatus()).body(response);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiErrorResponse> handleMethodArgumentNotValid(
        final MethodArgumentNotValidException exception
    ) {
        final List<ApiErrorField> fieldErrors = exception.getBindingResult()
            .getFieldErrors()
            .stream()
            .map(this::toApiErrorField)
            .toList();
        final String message = fieldErrors.stream()
            .findFirst()
            .map(ApiErrorField::message)
            .orElseGet(() -> resolveMessage(ApiMessageKey.VALIDATION_ERROR));
        final ApiErrorResponse response = new ApiErrorResponse(
            ApiErrorCode.VALIDATION_ERROR,
            message,
            fieldErrors,
            OffsetDateTime.now()
        );
        return ResponseEntity.badRequest().body(response);
    }

    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ApiErrorResponse> handleHttpMessageNotReadable(
        final HttpMessageNotReadableException exception
    ) {
        final ApiErrorResponse response = new ApiErrorResponse(
            ApiErrorCode.BAD_REQUEST,
            resolveMessage(ApiMessageKey.REQUEST_BODY_INVALID),
            List.of(),
            OffsetDateTime.now()
        );
        return ResponseEntity.badRequest().body(response);
    }

    @ExceptionHandler(DataIntegrityViolationException.class)
    public ResponseEntity<ApiErrorResponse> handleDataIntegrityViolation(
        final DataIntegrityViolationException exception
    ) {
        final ApiErrorResponse response = new ApiErrorResponse(
            ApiErrorCode.CONFLICT,
            resolveMessage(ApiMessageKey.DATA_CONFLICT),
            List.of(),
            OffsetDateTime.now()
        );
        return ResponseEntity.status(HttpStatus.CONFLICT).body(response);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiErrorResponse> handleException(final Exception exception) {
        final ApiErrorResponse response = new ApiErrorResponse(
            ApiErrorCode.INTERNAL_ERROR,
            resolveMessage(ApiMessageKey.INTERNAL_ERROR),
            List.of(),
            OffsetDateTime.now()
        );
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(response);
    }

    private ApiErrorField toApiErrorField(final FieldError fieldError) {
        return new ApiErrorField(
            fieldError.getField(),
            fieldError.getDefaultMessage() == null
                ? resolveMessage(ApiMessageKey.VALIDATION_ERROR)
                : fieldError.getDefaultMessage()
        );
    }

    private String resolveMessage(final String messageKey, final Object... messageArguments) {
        return messageSource.getMessage(messageKey, messageArguments, messageKey, LocaleContextHolder.getLocale());
    }
}
