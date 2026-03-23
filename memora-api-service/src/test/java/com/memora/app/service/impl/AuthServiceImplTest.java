package com.memora.app.service.impl;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.OffsetDateTime;
import java.util.Optional;

import com.memora.app.dto.AuthLoginRequest;
import com.memora.app.dto.AuthRefreshRequest;
import com.memora.app.dto.AuthRegisterRequest;
import com.memora.app.entity.RefreshTokenEntity;
import com.memora.app.entity.UserAccountEntity;
import com.memora.app.enums.AccountStatus;
import com.memora.app.enums.TokenStatus;
import com.memora.app.exception.UnauthorizedException;
import com.memora.app.properties.SecurityProperties;
import com.memora.app.repository.RefreshTokenRepository;
import com.memora.app.repository.UserAccountRepository;
import com.memora.app.security.CurrentAuthenticatedUserService;
import com.memora.app.security.JwtAccessTokenService;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

@ExtendWith(MockitoExtension.class)
class AuthServiceImplTest {

    @Mock
    private CurrentAuthenticatedUserService currentAuthenticatedUserService;

    @Mock
    private JwtAccessTokenService jwtAccessTokenService;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private RefreshTokenRepository refreshTokenRepository;

    @Mock
    private SecurityProperties securityProperties;

    @Mock
    private UserAccountRepository userAccountRepository;

    @InjectMocks
    private AuthServiceImpl authService;

    @Test
    void registerCreatesActiveAccountAndReturnsAuthenticatedSession() {
        final UserAccountEntity savedUser = new UserAccountEntity();
        savedUser.setId(10L);
        savedUser.setUsername("demo");
        savedUser.setEmail("demo@memora.local");
        savedUser.setAccountStatus(AccountStatus.ACTIVE);

        when(userAccountRepository.existsByUsernameIgnoreCaseAndDeletedAtIsNull("demo")).thenReturn(false);
        when(userAccountRepository.existsByEmailIgnoreCaseAndDeletedAtIsNull("demo@memora.local")).thenReturn(false);
        when(passwordEncoder.encode("demo12345")).thenReturn("encoded-password");
        when(userAccountRepository.save(any(UserAccountEntity.class))).thenReturn(savedUser);
        when(jwtAccessTokenService.generateToken(savedUser)).thenReturn("access-token");
        when(jwtAccessTokenService.expiresInSeconds()).thenReturn(28800L);
        when(securityProperties.refreshTokenExpiresInSeconds()).thenReturn(2592000L);

        final var response = authService.register(
            new AuthRegisterRequest("demo", "demo@memora.local", "demo12345")
        );

        final ArgumentCaptor<UserAccountEntity> userCaptor = ArgumentCaptor.forClass(UserAccountEntity.class);
        verify(userAccountRepository).save(userCaptor.capture());
        assertThat(userCaptor.getValue().getAccountStatus()).isEqualTo(AccountStatus.ACTIVE);
        assertThat(userCaptor.getValue().getPasswordHash()).isEqualTo("encoded-password");

        verify(refreshTokenRepository).save(any(RefreshTokenEntity.class));
        assertThat(response.authenticated()).isTrue();
        assertThat(response.accessToken()).isEqualTo("access-token");
        assertThat(response.refreshToken()).isNotBlank();
        assertThat(response.user().username()).isEqualTo("demo");
    }

    @Test
    void loginRejectsInvalidPassword() {
        final UserAccountEntity savedUser = new UserAccountEntity();
        savedUser.setId(1L);
        savedUser.setUsername("demo");
        savedUser.setEmail("demo@memora.local");
        savedUser.setPasswordHash("encoded-password");
        savedUser.setAccountStatus(AccountStatus.ACTIVE);

        when(userAccountRepository.findByUsernameIgnoreCaseAndDeletedAtIsNull("demo"))
            .thenReturn(Optional.of(savedUser));
        when(passwordEncoder.matches("wrong-password", "encoded-password")).thenReturn(false);

        assertThatThrownBy(() -> authService.login(new AuthLoginRequest("demo", "wrong-password")))
            .isInstanceOf(UnauthorizedException.class);
    }

    @Test
    void refreshRotatesCurrentTokenAndCreatesNewSession() {
        final UserAccountEntity savedUser = new UserAccountEntity();
        savedUser.setId(1L);
        savedUser.setUsername("demo");
        savedUser.setEmail("demo@memora.local");
        savedUser.setAccountStatus(AccountStatus.ACTIVE);

        final RefreshTokenEntity refreshTokenEntity = new RefreshTokenEntity();
        refreshTokenEntity.setId(9L);
        refreshTokenEntity.setUserId(1L);
        refreshTokenEntity.setTokenStatus(TokenStatus.ACTIVE);
        refreshTokenEntity.setExpiresAt(OffsetDateTime.now().plusDays(3));

        when(refreshTokenRepository.findByTokenHash(anyString())).thenReturn(Optional.of(refreshTokenEntity));
        when(userAccountRepository.findByIdAndDeletedAtIsNull(1L)).thenReturn(Optional.of(savedUser));
        when(jwtAccessTokenService.generateToken(savedUser)).thenReturn("refreshed-access-token");
        when(jwtAccessTokenService.expiresInSeconds()).thenReturn(28800L);
        when(securityProperties.refreshTokenExpiresInSeconds()).thenReturn(2592000L);

        final var response = authService.refresh(new AuthRefreshRequest("refresh-token"));

        verify(refreshTokenRepository, times(2)).save(any(RefreshTokenEntity.class));
        assertThat(refreshTokenEntity.getTokenStatus()).isEqualTo(TokenStatus.ROTATED);
        assertThat(refreshTokenEntity.getRevokedAt()).isNotNull();
        assertThat(response.accessToken()).isEqualTo("refreshed-access-token");
        assertThat(response.refreshToken()).isNotBlank();
        assertThat(response.authenticated()).isTrue();
    }
}
