package com.memora.app.dto;

import com.memora.app.enums.AccountStatus;

public record AuthUserDto(
    Long id,
    String username,
    String email,
    AccountStatus accountStatus
) {
}
