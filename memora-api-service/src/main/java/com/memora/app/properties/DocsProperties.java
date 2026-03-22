package com.memora.app.properties;

import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app.docs")
public record DocsProperties(
    String title,
    String description,
    String version
) {

    public DocsProperties {
        title = normalize(title, "Memora API Service");
        description = normalize(description, "REST API for Memora.");
        version = normalize(version, "v1");
    }

    private static String normalize(final String value, final String fallback) {
        return value == null || value.isBlank() ? fallback : value;
    }
}
