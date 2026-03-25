package com.memora.app.security;

import java.io.IOException;

import com.memora.app.entity.UserAccountEntity;
import com.memora.app.enums.user_account.AccountStatus;
import com.memora.app.repository.UserAccountRepository;

import io.jsonwebtoken.JwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.AuthorityUtils;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.web.filter.OncePerRequestFilter;

import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
public class AuthTokenAuthenticationFilter extends OncePerRequestFilter {

    private static final String AUTHORIZATION_HEADER = "Authorization";
    private static final String BEARER_PREFIX = "Bearer ";

    private final JwtAccessTokenService jwtAccessTokenService;
    private final UserAccountRepository userAccountRepository;

    @Override
    protected void doFilterInternal(
        final HttpServletRequest request,
        final HttpServletResponse response,
        final FilterChain filterChain
    ) throws ServletException, IOException {
        final String accessToken = resolveAccessToken(request);

        // Authenticate the request only when a bearer token exists and the security context is still empty.
        if (accessToken != null && SecurityContextHolder.getContext().getAuthentication() == null) {
            authenticateRequest(accessToken, request);
        }

        filterChain.doFilter(request, response);
    }

    private void authenticateRequest(final String accessToken, final HttpServletRequest request) {
        try {
            final Long userId = jwtAccessTokenService.extractUserId(accessToken);
            userAccountRepository.findByIdAndDeletedAtIsNull(userId)
                .filter(userAccount -> userAccount.getAccountStatus() == AccountStatus.ACTIVE)
                .map(this::toAuthenticatedUser)
                .ifPresent(user -> setAuthentication(user, request));
        } catch (JwtException | IllegalArgumentException exception) {
            SecurityContextHolder.clearContext();
        }
    }

    private void setAuthentication(final AuthenticatedUser authenticatedUser, final HttpServletRequest request) {
        final UsernamePasswordAuthenticationToken authentication =
            new UsernamePasswordAuthenticationToken(
                authenticatedUser,
                null,
                AuthorityUtils.NO_AUTHORITIES
            );
        authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

        final SecurityContext context = SecurityContextHolder.createEmptyContext();
        context.setAuthentication(authentication);
        SecurityContextHolder.setContext(context);
    }

    private AuthenticatedUser toAuthenticatedUser(final UserAccountEntity userAccount) {
        // Return the minimal authenticated principal model consumed by downstream services.
        return new AuthenticatedUser(
            userAccount.getId(),
            userAccount.getUsername(),
            userAccount.getEmail(),
            userAccount.getAccountStatus()
        );
    }

    private String resolveAccessToken(final HttpServletRequest request) {
        final String authorizationHeader = request.getHeader(AUTHORIZATION_HEADER);
        // Skip extraction when the request does not carry a bearer authorization header.
        if (StringUtils.isBlank(authorizationHeader) || !StringUtils.startsWith(authorizationHeader, BEARER_PREFIX)) {
            // Return null so the request continues as anonymous or through public-path rules.
            return null;
        }

        final String accessToken = StringUtils.trimToNull(authorizationHeader.substring(BEARER_PREFIX.length()));
        // Skip extraction when the bearer prefix is present but the token payload is still blank.
        if (StringUtils.isBlank(accessToken)) {
            // Return null so invalid empty bearer headers do not populate the security context.
            return null;
        }

        // Return the extracted bearer token for signature and user validation.
        return accessToken;
    }
}
