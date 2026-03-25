package com.memora.app.dto.response.auth;

public record AuthResponse(
    AuthUserResponse user,
    String accessToken,
    String refreshToken,
    long expiresIn,
    boolean authenticated
) {
}



