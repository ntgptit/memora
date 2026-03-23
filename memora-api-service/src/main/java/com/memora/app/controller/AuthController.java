package com.memora.app.controller;

import com.memora.app.dto.AuthLoginRequest;
import com.memora.app.dto.AuthLogoutRequest;
import com.memora.app.dto.AuthRefreshRequest;
import com.memora.app.dto.AuthRegisterRequest;
import com.memora.app.dto.AuthResponse;
import com.memora.app.dto.AuthUserDto;
import com.memora.app.service.AuthService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * REST endpoints for account authentication and session lifecycle management.
 */
@Tag(name = "Auth", description = "Authentication APIs for session lifecycle")
@RestController
@RequestMapping("/api/v1/auth")
@RequiredArgsConstructor
public class AuthController {

    private final AuthService authService;

    /**
     * Register a new account and create the initial authenticated session.
     *
     * @param request registration payload
     * @return authenticated session payload
     */
    @Operation(summary = "Register account and create an authenticated session")
    @ApiResponses({
        @ApiResponse(responseCode = "201", description = "Account registered and session created"),
        @ApiResponse(responseCode = "400", description = "Request is invalid"),
        @ApiResponse(responseCode = "409", description = "Username or email already exists")
    })
    @PostMapping("/register")
    public ResponseEntity<AuthResponse> register(@Valid @RequestBody final AuthRegisterRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(authService.register(request));
    }

    /**
     * Login using username or email plus password.
     *
     * @param request login payload
     * @return authenticated session payload
     */
    @Operation(summary = "Login with username or email")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Session created"),
        @ApiResponse(responseCode = "400", description = "Request is invalid"),
        @ApiResponse(responseCode = "401", description = "Credentials are invalid")
    })
    @PostMapping("/login")
    public ResponseEntity<AuthResponse> login(@Valid @RequestBody final AuthLoginRequest request) {
        return ResponseEntity.ok(authService.login(request));
    }

    /**
     * Refresh the current authenticated session by rotating the refresh token.
     *
     * @param request refresh-token payload
     * @return replacement authenticated session payload
     */
    @Operation(summary = "Refresh an authenticated session")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Session refreshed"),
        @ApiResponse(responseCode = "400", description = "Request is invalid"),
        @ApiResponse(responseCode = "401", description = "Refresh token is invalid or expired")
    })
    @PostMapping("/refresh")
    public ResponseEntity<AuthResponse> refresh(@Valid @RequestBody final AuthRefreshRequest request) {
        return ResponseEntity.ok(authService.refresh(request));
    }

    /**
     * Logout the current session by revoking the submitted refresh token.
     *
     * @param request logout payload
     * @return empty response when revocation completes
     */
    @Operation(summary = "Logout the current session")
    @ApiResponses({
        @ApiResponse(responseCode = "204", description = "Session revoked"),
        @ApiResponse(responseCode = "400", description = "Request is invalid")
    })
    @PostMapping("/logout")
    public ResponseEntity<Void> logout(@Valid @RequestBody final AuthLogoutRequest request) {
        authService.logout(request);
        return ResponseEntity.noContent().build();
    }

    /**
     * Get the currently authenticated user profile.
     *
     * @return current authenticated user payload
     */
    @Operation(summary = "Get current authenticated user")
    @SecurityRequirement(name = "bearerAuth")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Current user loaded"),
        @ApiResponse(responseCode = "401", description = "Access token is missing or invalid")
    })
    @GetMapping("/me")
    public ResponseEntity<AuthUserDto> getCurrentUser() {
        return ResponseEntity.ok(authService.getCurrentUser());
    }
}
