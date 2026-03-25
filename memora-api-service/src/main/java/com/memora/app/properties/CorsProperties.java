package com.memora.app.properties;

import java.util.List;

import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PositiveOrZero;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

@ConfigurationProperties(prefix = "app.cors")
@Validated
public record CorsProperties(
    @NotNull List<String> allowedOrigins,
    @NotNull List<String> allowedOriginPatterns,
    @NotNull List<String> allowedMethods,
    @NotNull List<String> allowedHeaders,
    @NotNull List<String> exposedHeaders,
    boolean allowCredentials,
    @PositiveOrZero long maxAgeSeconds
) {

    public CorsProperties {
        allowedOrigins = List.copyOf(allowedOrigins);
        allowedOriginPatterns = List.copyOf(allowedOriginPatterns);
        allowedMethods = List.copyOf(allowedMethods);
        allowedHeaders = List.copyOf(allowedHeaders);
        exposedHeaders = List.copyOf(exposedHeaders);
    }
}
