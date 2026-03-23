package com.memora.app.service;

import com.memora.app.dto.AuthLoginRequest;
import com.memora.app.dto.AuthLogoutRequest;
import com.memora.app.dto.AuthRefreshRequest;
import com.memora.app.dto.AuthRegisterRequest;
import com.memora.app.dto.AuthResponse;
import com.memora.app.dto.AuthUserDto;

public interface AuthService {

    AuthResponse register(AuthRegisterRequest request);

    AuthResponse login(AuthLoginRequest request);

    AuthResponse refresh(AuthRefreshRequest request);

    void logout(AuthLogoutRequest request);

    AuthUserDto getCurrentUser();
}
