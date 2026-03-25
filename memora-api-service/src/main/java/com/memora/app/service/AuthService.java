package com.memora.app.service;

import com.memora.app.dto.request.auth.AuthLoginRequest;
import com.memora.app.dto.request.auth.AuthLogoutRequest;
import com.memora.app.dto.request.auth.AuthRefreshRequest;
import com.memora.app.dto.request.auth.AuthRegisterRequest;
import com.memora.app.dto.response.auth.AuthResponse;
import com.memora.app.dto.response.auth.AuthUserResponse;

public interface AuthService {

    AuthResponse register(AuthRegisterRequest request);

    AuthResponse login(AuthLoginRequest request);

    AuthResponse refresh(AuthRefreshRequest request);

    void logout(AuthLogoutRequest request);

    AuthUserResponse getCurrentUser();
}



