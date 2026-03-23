package com.memora.app.service.impl;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.time.OffsetDateTime;
import java.util.HexFormat;
import java.util.Locale;
import java.util.UUID;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.AuthLoginRequest;
import com.memora.app.dto.AuthLogoutRequest;
import com.memora.app.dto.AuthRefreshRequest;
import com.memora.app.dto.AuthRegisterRequest;
import com.memora.app.dto.AuthResponse;
import com.memora.app.dto.AuthUserDto;
import com.memora.app.entity.RefreshTokenEntity;
import com.memora.app.entity.UserAccountEntity;
import com.memora.app.enums.AccountStatus;
import com.memora.app.enums.TokenStatus;
import com.memora.app.exception.ConflictException;
import com.memora.app.exception.UnauthorizedException;
import com.memora.app.mapper.AuthUserMapper;
import com.memora.app.properties.SecurityProperties;
import com.memora.app.repository.RefreshTokenRepository;
import com.memora.app.repository.UserAccountRepository;
import com.memora.app.security.CurrentAuthenticatedUserService;
import com.memora.app.security.JwtAccessTokenService;
import com.memora.app.service.AuthService;
import com.memora.app.util.ServiceValidationUtils;

import org.apache.commons.lang3.StringUtils;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AuthServiceImpl implements AuthService {

    private final CurrentAuthenticatedUserService currentAuthenticatedUserService;
    private final JwtAccessTokenService jwtAccessTokenService;
    private final PasswordEncoder passwordEncoder;
    private final RefreshTokenRepository refreshTokenRepository;
    private final SecurityProperties securityProperties;
    private final UserAccountRepository userAccountRepository;

    @Override
    @Transactional
    public AuthResponse register(final AuthRegisterRequest request) {
        final String username = normalizeUsername(request.username());
        final String email = normalizeEmail(request.email());
        final String password = ServiceValidationUtils.normalizeRequiredText(
            request.password(),
            ApiMessageKey.PASSWORD_REQUIRED
        );

        assertUsernameAvailable(username);
        assertEmailAvailable(email);

        final UserAccountEntity entity = new UserAccountEntity();
        entity.setUsername(username);
        entity.setEmail(email);
        entity.setPasswordHash(passwordEncoder.encode(password));
        entity.setAccountStatus(AccountStatus.ACTIVE);

        final UserAccountEntity saved = userAccountRepository.save(entity);
        // Return the newly created account together with an authenticated session.
        return createSession(saved);
    }

    @Override
    @Transactional(readOnly = true)
    public AuthResponse login(final AuthLoginRequest request) {
        final String identifier = ServiceValidationUtils.normalizeRequiredText(
            request.identifier(),
            ApiMessageKey.IDENTIFIER_REQUIRED
        );
        final String password = ServiceValidationUtils.normalizeRequiredText(
            request.password(),
            ApiMessageKey.PASSWORD_REQUIRED
        );

        final UserAccountEntity userAccount = resolveUserAccountByIdentifier(identifier);

        assertAccountActive(userAccount);

        // Stop the login flow when the submitted password does not match the stored hash.
        if (!passwordEncoder.matches(password, userAccount.getPasswordHash())) {
            // Reject invalid credentials without exposing which field mismatched.
            throw new UnauthorizedException(ApiMessageKey.AUTH_INVALID_CREDENTIALS);
        }

        // Return a fresh authenticated session after the credential check succeeds.
        return createSession(userAccount);
    }

    @Override
    @Transactional
    public AuthResponse refresh(final AuthRefreshRequest request) {
        final String refreshToken = ServiceValidationUtils.normalizeRequiredText(
            request.refreshToken(),
            ApiMessageKey.REFRESH_TOKEN_REQUIRED
        );
        final OffsetDateTime now = OffsetDateTime.now();
        final RefreshTokenEntity currentToken = refreshTokenRepository.findByTokenHash(hashToken(refreshToken))
            .orElseThrow(() -> new UnauthorizedException(ApiMessageKey.AUTH_REFRESH_TOKEN_INVALID));

        // Reject refresh requests that attempt to reuse a rotated, revoked, or expired token row.
        if (currentToken.getTokenStatus() != TokenStatus.ACTIVE) {
            // Stop the refresh flow when the persisted token is no longer active.
            throw new UnauthorizedException(ApiMessageKey.AUTH_REFRESH_TOKEN_INVALID);
        }

        // Expire the token row before returning an unauthorized response when the token has aged out.
        if (currentToken.getExpiresAt().isBefore(now)) {
            currentToken.setTokenStatus(TokenStatus.EXPIRED);
            refreshTokenRepository.save(currentToken);
            // Reject the refresh flow once the token lifetime has elapsed.
            throw new UnauthorizedException(ApiMessageKey.AUTH_REFRESH_TOKEN_INVALID);
        }

        final UserAccountEntity userAccount = getActiveUserAccount(currentToken.getUserId());

        currentToken.setTokenStatus(TokenStatus.ROTATED);
        currentToken.setRevokedAt(now);
        refreshTokenRepository.save(currentToken);

        // Return a replacement session after rotating the active refresh token.
        return createSession(userAccount);
    }

    @Override
    @Transactional
    public void logout(final AuthLogoutRequest request) {
        final String refreshToken = ServiceValidationUtils.normalizeRequiredText(
            request.refreshToken(),
            ApiMessageKey.REFRESH_TOKEN_REQUIRED
        );
        final OffsetDateTime now = OffsetDateTime.now();

        refreshTokenRepository.findByTokenHash(hashToken(refreshToken)).ifPresent(token -> {
            // Ignore duplicate logout requests once the token is no longer active.
            if (token.getTokenStatus() != TokenStatus.ACTIVE) {
                // Return early because the session has already been ended.
                return;
            }

            // Mark stale active tokens as expired instead of revoked when their lifetime already ended.
            if (token.getExpiresAt().isBefore(now)) {
                token.setTokenStatus(TokenStatus.EXPIRED);
                refreshTokenRepository.save(token);
                // Return after persisting the expired state because no revocation is needed.
                return;
            }

            token.setTokenStatus(TokenStatus.REVOKED);
            token.setRevokedAt(now);
            refreshTokenRepository.save(token);
        });
    }

    @Override
    @Transactional(readOnly = true)
    public AuthUserDto getCurrentUser() {
        // Return the authenticated user identity resolved from the security context.
        return AuthUserMapper.toDto(currentAuthenticatedUserService.getCurrentUser());
    }

    private AuthResponse createSession(final UserAccountEntity userAccount) {
        final String accessToken = jwtAccessTokenService.generateToken(userAccount);
        final String refreshToken = generateRefreshToken();

        final RefreshTokenEntity refreshTokenEntity = new RefreshTokenEntity();
        refreshTokenEntity.setUserId(userAccount.getId());
        refreshTokenEntity.setTokenHash(hashToken(refreshToken));
        refreshTokenEntity.setTokenStatus(TokenStatus.ACTIVE);
        refreshTokenEntity.setExpiresAt(
            OffsetDateTime.now().plusSeconds(securityProperties.refreshTokenExpiresInSeconds())
        );
        refreshTokenEntity.setDeviceLabel(null);
        refreshTokenRepository.save(refreshTokenEntity);

        // Return the transport payload expected by the frontend auth contract.
        return new AuthResponse(
            AuthUserMapper.toDto(userAccount),
            accessToken,
            refreshToken,
            jwtAccessTokenService.expiresInSeconds(),
            true
        );
    }

    private UserAccountEntity getActiveUserAccount(final Long userId) {
        final UserAccountEntity userAccount = userAccountRepository.findByIdAndDeletedAtIsNull(userId)
            .orElseThrow(() -> new UnauthorizedException(ApiMessageKey.AUTH_REFRESH_TOKEN_INVALID));
        assertAccountActive(userAccount);
        // Return the active persisted account linked to the current token.
        return userAccount;
    }

    private void assertAccountActive(final UserAccountEntity userAccount) {
        // Reject authentication flows for accounts that are not currently active.
        if (userAccount.getAccountStatus() != AccountStatus.ACTIVE) {
            // Stop the auth flow when the account is not allowed to create a session.
            throw new UnauthorizedException(ApiMessageKey.AUTH_ACCOUNT_INACTIVE);
        }
    }

    private void assertUsernameAvailable(final String username) {
        // Reject registering a username that is already claimed by another active account.
        if (userAccountRepository.existsByUsernameIgnoreCaseAndDeletedAtIsNull(username)) {
            // Stop the write when another account already owns the requested username.
            throw new ConflictException(ApiMessageKey.USERNAME_EXISTS);
        }
    }

    private void assertEmailAvailable(final String email) {
        // Reject registering an email that is already claimed by another active account.
        if (userAccountRepository.existsByEmailIgnoreCaseAndDeletedAtIsNull(email)) {
            // Stop the write when another account already owns the requested email.
            throw new ConflictException(ApiMessageKey.EMAIL_EXISTS);
        }
    }

    private String normalizeUsername(final String username) {
        // Return the normalized username value used for uniqueness checks and persistence.
        return ServiceValidationUtils.normalizeRequiredText(username, ApiMessageKey.USERNAME_REQUIRED);
    }

    private String normalizeEmail(final String email) {
        // Return the normalized lowercase email value used for uniqueness checks and login lookups.
        return StringUtils.lowerCase(
            ServiceValidationUtils.normalizeRequiredText(email, ApiMessageKey.EMAIL_REQUIRED),
            Locale.ROOT
        );
    }

    private String generateRefreshToken() {
        // Return a high-entropy opaque refresh token value for the client session.
        return UUID.randomUUID().toString().replace("-", "")
            + UUID.randomUUID().toString().replace("-", "");
    }

    private UserAccountEntity resolveUserAccountByIdentifier(final String identifier) {
        final String normalizedIdentifier = StringUtils.lowerCase(identifier, Locale.ROOT);
        final var usernameMatch = userAccountRepository.findByUsernameIgnoreCaseAndDeletedAtIsNull(normalizedIdentifier);
        // Return early when the identifier matches an existing username.
        if (usernameMatch.isPresent()) {
            // Return the matching account when the identifier maps to an existing username.
            return usernameMatch.get();
        }

        final var emailMatch = userAccountRepository.findByEmailIgnoreCaseAndDeletedAtIsNull(normalizedIdentifier);
        // Return early when the identifier matches an existing email address.
        if (emailMatch.isPresent()) {
            // Return the matching account when the identifier maps to an existing email.
            return emailMatch.get();
        }

        // Reject login requests that do not match any active username or email.
        throw new UnauthorizedException(ApiMessageKey.AUTH_INVALID_CREDENTIALS);
    }

    private String hashToken(final String value) {
        try {
            final MessageDigest messageDigest = MessageDigest.getInstance("SHA-256");
            final byte[] digest = messageDigest.digest(value.getBytes(StandardCharsets.UTF_8));
            // Return the stable hexadecimal token hash stored in the refresh token table.
            return HexFormat.of().formatHex(digest);
        } catch (NoSuchAlgorithmException exception) {
            // Fail fast when the runtime cannot provide the hashing algorithm required by token persistence.
            throw new IllegalStateException(ApiMessageKey.INTERNAL_ERROR, exception);
        }
    }
}
