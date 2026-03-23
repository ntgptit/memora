package com.memora.app.properties;

import java.util.List;

import org.apache.commons.lang3.StringUtils;
import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app.security")
public record SecurityProperties(
    List<String> publicPaths,
    String accessTokenSecret,
    long accessTokenExpiresInSeconds,
    long refreshTokenExpiresInSeconds,
    String tokenIssuer
) {

    private static final long DEFAULT_ACCESS_TOKEN_EXPIRES_IN_SECONDS = 28800L;
    private static final long DEFAULT_REFRESH_TOKEN_EXPIRES_IN_SECONDS = 2592000L;
    private static final String DEFAULT_TOKEN_ISSUER = "memora-api-service";

    public SecurityProperties {
        publicPaths = publicPaths == null ? List.of() : List.copyOf(publicPaths);
        accessTokenSecret = StringUtils.defaultIfBlank(
            accessTokenSecret,
            "memora-dev-access-token-secret-2026-change-me"
        );
        accessTokenExpiresInSeconds = accessTokenExpiresInSeconds <= 0
            ? DEFAULT_ACCESS_TOKEN_EXPIRES_IN_SECONDS
            : accessTokenExpiresInSeconds;
        refreshTokenExpiresInSeconds = refreshTokenExpiresInSeconds <= 0
            ? DEFAULT_REFRESH_TOKEN_EXPIRES_IN_SECONDS
            : refreshTokenExpiresInSeconds;
        tokenIssuer = StringUtils.defaultIfBlank(tokenIssuer, DEFAULT_TOKEN_ISSUER);
    }
}
