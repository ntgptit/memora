package com.memora.app.properties;

import java.util.List;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

@ConfigurationProperties(prefix = "app.security")
@Validated
public record SecurityProperties(
    @NotNull List<String> publicPaths,
    @NotBlank String accessTokenSecret,
    @Positive long accessTokenExpiresInSeconds,
    @Positive long refreshTokenExpiresInSeconds,
    @NotBlank String tokenIssuer
) {

    public SecurityProperties {
        publicPaths = List.copyOf(publicPaths);
    }
}
