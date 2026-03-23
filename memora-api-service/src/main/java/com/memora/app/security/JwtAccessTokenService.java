package com.memora.app.security;

import java.nio.charset.StandardCharsets;
import java.time.Instant;
import java.util.Date;

import javax.crypto.SecretKey;

import com.memora.app.entity.UserAccountEntity;
import com.memora.app.properties.SecurityProperties;

import org.springframework.stereotype.Component;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import lombok.RequiredArgsConstructor;

@Component
@RequiredArgsConstructor
public class JwtAccessTokenService {

    private final SecurityProperties securityProperties;

    public String generateToken(final UserAccountEntity userAccount) {
        final Instant issuedAt = Instant.now();
        final Instant expiresAt = issuedAt.plusSeconds(securityProperties.accessTokenExpiresInSeconds());

        // Return the signed access token consumed by the frontend on authenticated requests.
        return Jwts.builder()
            .issuer(securityProperties.tokenIssuer())
            .subject(String.valueOf(userAccount.getId()))
            .claim("username", userAccount.getUsername())
            .claim("email", userAccount.getEmail())
            .claim("accountStatus", userAccount.getAccountStatus().name())
            .issuedAt(Date.from(issuedAt))
            .expiration(Date.from(expiresAt))
            .signWith(resolveSigningKey())
            .compact();
    }

    public Long extractUserId(final String accessToken) {
        // Return the authenticated user id encoded into the signed access token subject claim.
        return Long.valueOf(parseClaims(accessToken).getSubject());
    }

    public long expiresInSeconds() {
        // Return the configured access-token lifetime that the frontend stores with each session.
        return securityProperties.accessTokenExpiresInSeconds();
    }

    private Claims parseClaims(final String accessToken) {
        // Return the validated JWT claims after signature, issuer, and expiration checks succeed.
        return Jwts.parser()
            .verifyWith(resolveSigningKey())
            .requireIssuer(securityProperties.tokenIssuer())
            .build()
            .parseSignedClaims(accessToken)
            .getPayload();
    }

    private SecretKey resolveSigningKey() {
        // Return the HMAC signing key derived from the configured access-token secret.
        return Keys.hmacShaKeyFor(securityProperties.accessTokenSecret().getBytes(StandardCharsets.UTF_8));
    }
}
