package com.memora.app.properties;

import java.util.List;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app.cors")
public record CorsProperties(
    List<String> allowedOrigins,
    List<String> allowedOriginPatterns,
    List<String> allowedMethods,
    List<String> allowedHeaders,
    List<String> exposedHeaders,
    boolean allowCredentials,
    long maxAgeSeconds
) {

    public CorsProperties {
        allowedOrigins = normalize(allowedOrigins);
        allowedOriginPatterns = normalize(allowedOriginPatterns);
        allowedMethods = normalize(allowedMethods);
        allowedHeaders = normalize(allowedHeaders);
        exposedHeaders = normalize(exposedHeaders);
    }

    private static List<String> normalize(final List<String> values) {
        return values == null ? List.of() : List.copyOf(values);
    }
}
