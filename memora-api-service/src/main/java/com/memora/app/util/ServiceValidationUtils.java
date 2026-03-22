package com.memora.app.util;

import com.memora.app.exception.BadRequestException;

import org.apache.commons.lang3.StringUtils;

import lombok.experimental.UtilityClass;

@UtilityClass
public class ServiceValidationUtils {

    public static Long requirePositiveId(final Long id, final String messageKey) {
        // Reject null or non-positive identifiers before querying.
        if (id == null || id <= 0L) {
            throw new BadRequestException(messageKey);
        }
        return id;
    }

    public static String normalizeRequiredText(final String value, final String messageKey) {
        final String normalized = StringUtils.trimToNull(value);

        // Reject blank text after trimming input noise.
        if (normalized == null) {
            throw new BadRequestException(messageKey);
        }
        return normalized;
    }

    public static String normalizeOptionalText(final String value) {
        return StringUtils.trimToEmpty(value);
    }

    public static String normalizeOptionalNullableText(final String value) {
        return StringUtils.trimToNull(value);
    }
}
