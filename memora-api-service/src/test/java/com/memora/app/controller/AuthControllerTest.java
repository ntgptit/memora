package com.memora.app.controller;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.request.auth.AuthLoginRequest;
import com.memora.app.dto.request.auth.AuthLogoutRequest;
import com.memora.app.dto.request.auth.AuthRefreshRequest;
import com.memora.app.dto.request.auth.AuthRegisterRequest;
import com.memora.app.dto.response.auth.AuthResponse;
import com.memora.app.dto.response.auth.AuthUserResponse;
import com.memora.app.exception.BadRequestException;
import com.memora.app.exception.ConflictException;
import com.memora.app.exception.UnauthorizedException;
import com.memora.app.service.AuthService;
import com.memora.app.support.RecordFixtureFactory;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;

@ExtendWith(MockitoExtension.class)
class AuthControllerTest {

    @Mock
    private AuthService authService;

    @InjectMocks
    private AuthController authController;

    @Test
    void registerReturnsCreatedWhenServiceSucceeds() {
        final AuthRegisterRequest request = RecordFixtureFactory.createRecord(AuthRegisterRequest.class);
        final AuthResponse expectedResponse = RecordFixtureFactory.createRecord(AuthResponse.class);

        when(authService.register(request)).thenReturn(expectedResponse);

        final var response = authController.register(request);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void registerPropagatesBadRequestScenario() {
        final AuthRegisterRequest request = RecordFixtureFactory.createRecord(AuthRegisterRequest.class);

        when(authService.register(request)).thenThrow(new BadRequestException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> authController.register(request)).isInstanceOf(BadRequestException.class);
    }

    @Test
    void registerPropagatesConflictScenario() {
        final AuthRegisterRequest request = RecordFixtureFactory.createRecord(AuthRegisterRequest.class);

        when(authService.register(request)).thenThrow(new ConflictException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> authController.register(request)).isInstanceOf(ConflictException.class);
    }

    @Test
    void loginReturnsOkWhenServiceSucceeds() {
        final AuthLoginRequest request = RecordFixtureFactory.createRecord(AuthLoginRequest.class);
        final AuthResponse expectedResponse = RecordFixtureFactory.createRecord(AuthResponse.class);

        when(authService.login(request)).thenReturn(expectedResponse);

        final var response = authController.login(request);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void loginPropagatesBadRequestScenario() {
        final AuthLoginRequest request = RecordFixtureFactory.createRecord(AuthLoginRequest.class);

        when(authService.login(request)).thenThrow(new BadRequestException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> authController.login(request)).isInstanceOf(BadRequestException.class);
    }

    @Test
    void loginPropagatesUnauthorizedScenario() {
        final AuthLoginRequest request = RecordFixtureFactory.createRecord(AuthLoginRequest.class);

        when(authService.login(request)).thenThrow(new UnauthorizedException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> authController.login(request)).isInstanceOf(UnauthorizedException.class);
    }

    @Test
    void refreshReturnsOkWhenServiceSucceeds() {
        final AuthRefreshRequest request = RecordFixtureFactory.createRecord(AuthRefreshRequest.class);
        final AuthResponse expectedResponse = RecordFixtureFactory.createRecord(AuthResponse.class);

        when(authService.refresh(request)).thenReturn(expectedResponse);

        final var response = authController.refresh(request);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void refreshPropagatesBadRequestScenario() {
        final AuthRefreshRequest request = RecordFixtureFactory.createRecord(AuthRefreshRequest.class);

        when(authService.refresh(request)).thenThrow(new BadRequestException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> authController.refresh(request)).isInstanceOf(BadRequestException.class);
    }

    @Test
    void refreshPropagatesUnauthorizedScenario() {
        final AuthRefreshRequest request = RecordFixtureFactory.createRecord(AuthRefreshRequest.class);

        when(authService.refresh(request)).thenThrow(new UnauthorizedException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> authController.refresh(request)).isInstanceOf(UnauthorizedException.class);
    }

    @Test
    void logoutReturnsNoContentWhenServiceSucceeds() {
        final AuthLogoutRequest request = RecordFixtureFactory.createRecord(AuthLogoutRequest.class);

        final var response = authController.logout(request);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NO_CONTENT);
        assertThat(response.getBody()).isNull();
    }

    @Test
    void logoutPropagatesBadRequestScenario() {
        final AuthLogoutRequest request = RecordFixtureFactory.createRecord(AuthLogoutRequest.class);

        org.mockito.Mockito.doThrow(new BadRequestException(ApiMessageKey.INTERNAL_ERROR))
            .when(authService)
            .logout(request);

        assertThatThrownBy(() -> authController.logout(request)).isInstanceOf(BadRequestException.class);
    }

    @Test
    void getCurrentUserReturnsOkWhenServiceSucceeds() {
        final AuthUserResponse expectedResponse = RecordFixtureFactory.createRecord(AuthUserResponse.class);

        when(authService.getCurrentUser()).thenReturn(expectedResponse);

        final var response = authController.getCurrentUser();

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void getCurrentUserPropagatesUnauthorizedScenario() {
        when(authService.getCurrentUser()).thenThrow(new UnauthorizedException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> authController.getCurrentUser()).isInstanceOf(UnauthorizedException.class);
    }
}
