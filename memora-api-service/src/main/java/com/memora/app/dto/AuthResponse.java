package com.memora.app.dto;

public record AuthResponse(
    AuthUserDto user,
    String accessToken,
    String refreshToken,
    long expiresIn,
    boolean authenticated
) {
}
