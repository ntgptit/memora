package com.memora.app.security;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.exception.UnauthorizedException;

import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;

@Service
public class CurrentAuthenticatedUserService {

    public AuthenticatedUser getCurrentUser() {
        final Authentication authentication = SecurityContextHolder.getContext().getAuthentication();

        // Reject requests that do not yet hold an authenticated security context.
        if (authentication == null || !authentication.isAuthenticated()) {
            // Stop the flow when the request does not carry a valid authenticated principal.
            throw new UnauthorizedException(ApiMessageKey.AUTHENTICATION_REQUIRED);
        }

        // Reject anonymous principals because downstream services require a real authenticated user.
        if (authentication instanceof AnonymousAuthenticationToken) {
            // Stop the flow when only the anonymous authentication placeholder is present.
            throw new UnauthorizedException(ApiMessageKey.AUTHENTICATION_REQUIRED);
        }

        // Return the principal only when the security context stores the expected authenticated-user model.
        if (authentication.getPrincipal() instanceof AuthenticatedUser authenticatedUser) {
            // Return the authenticated user identity consumed by service-layer ownership checks.
            return authenticatedUser;
        }

        // Stop the flow when the principal type is not the auth model expected by the application.
        throw new UnauthorizedException(ApiMessageKey.AUTHENTICATION_REQUIRED);
    }
}
