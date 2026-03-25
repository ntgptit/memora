package com.memora.app.properties;

import jakarta.validation.constraints.NotBlank;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

@ConfigurationProperties(prefix = "app.docs")
@Validated
public record DocsProperties(
    @NotBlank String title,
    @NotBlank String description,
    @NotBlank String version
) {
}
