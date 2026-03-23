package com.memora.app.security;

import java.io.IOException;
import java.time.OffsetDateTime;
import java.util.List;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.memora.app.constant.ApiErrorCode;
import com.memora.app.constant.ApiMessageKey;
import com.memora.app.exception.ApiErrorResponse;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.web.access.AccessDeniedHandler;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class RestAccessDeniedHandler implements AccessDeniedHandler {

    private final MessageSource messageSource;
    private final ObjectMapper objectMapper;

    @Override
    public void handle(
        final HttpServletRequest request,
        final HttpServletResponse response,
        final AccessDeniedException accessDeniedException
    ) throws IOException, ServletException {
        response.setStatus(HttpStatus.FORBIDDEN.value());
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        objectMapper.writeValue(
            response.getOutputStream(),
            new ApiErrorResponse(
                ApiErrorCode.FORBIDDEN,
                resolveMessage(ApiMessageKey.AUTH_ACCESS_DENIED),
                List.of(),
                OffsetDateTime.now()
            )
        );
    }

    private String resolveMessage(final String messageKey, final Object... messageArguments) {
        // Return the localized authorization message rendered into the JSON error payload.
        return messageSource.getMessage(messageKey, messageArguments, messageKey, LocaleContextHolder.getLocale());
    }
}
