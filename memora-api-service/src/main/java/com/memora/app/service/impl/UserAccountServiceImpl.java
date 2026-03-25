package com.memora.app.service.impl;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Locale;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.request.user_account.CreateUserAccountRequest;
import com.memora.app.dto.request.user_account.UpdateUserAccountRequest;
import com.memora.app.dto.response.user_account.UserAccountResponse;
import com.memora.app.entity.UserAccountEntity;
import com.memora.app.enums.user_account.AccountStatus;
import com.memora.app.exception.ConflictException;
import com.memora.app.exception.ResourceNotFoundException;
import com.memora.app.mapper.UserAccountMapper;
import com.memora.app.repository.FolderRepository;
import com.memora.app.repository.ReviewProfileRepository;
import com.memora.app.repository.UserAccountRepository;
import com.memora.app.service.UserAccountService;
import com.memora.app.util.ServiceValidationUtils;

import org.apache.commons.lang3.StringUtils;
import org.springframework.data.domain.Sort;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserAccountServiceImpl implements UserAccountService {

    private static final Sort ID_ASC_SORT = Sort.by(Sort.Order.asc("id"));

    private final FolderRepository folderRepository;
    private final PasswordEncoder passwordEncoder;
    private final ReviewProfileRepository reviewProfileRepository;
    private final UserAccountRepository userAccountRepository;
    private final UserAccountMapper userAccountMapper;

    @Override
    @Transactional
    public UserAccountResponse createUserAccount(final CreateUserAccountRequest request) {
        final String username = ServiceValidationUtils.normalizeRequiredText(
            request.username(),
            ApiMessageKey.USERNAME_REQUIRED
        );
        final String email = normalizeEmail(request.email());
        final String password = ServiceValidationUtils.normalizeRequiredText(
            request.password(),
            ApiMessageKey.PASSWORD_REQUIRED
        );

        assertUsernameAvailable(username, null);
        assertEmailAvailable(email, null);

        final UserAccountEntity entity = UserAccountEntity.builder()
            .username(username)
            .email(email)
            .passwordHash(passwordEncoder.encode(password))
            .accountStatus(resolveAccountStatus(request.accountStatus()))
            .build();
        // Return the persisted user account without exposing the password hash.
        return userAccountMapper.toDto(userAccountRepository.save(entity));
    }

    @Override
    @Transactional(readOnly = true)
    public UserAccountResponse getUserAccount(final Long userAccountId) {
        // Return the requested active user account.
        return userAccountMapper.toDto(getActiveUserAccount(userAccountId));
    }

    @Override
    @Transactional(readOnly = true)
    public List<UserAccountResponse> getUserAccounts(final AccountStatus accountStatus) {
        // Return every active account when the caller does not filter by status.
        if (accountStatus == null) {
            // Return all active accounts.
            return userAccountRepository.findAllByDeletedAtIsNull(ID_ASC_SORT)
                // Convert persisted account rows into DTOs for the API layer.
                .stream()
                .map(userAccountMapper::toDto)
                .toList();
        }
        // Return only active accounts in the requested status.
        return userAccountRepository.findAllByAccountStatusAndDeletedAtIsNull(accountStatus, ID_ASC_SORT)
            // Convert persisted account rows into DTOs for the API layer.
            .stream()
            .map(userAccountMapper::toDto)
            .toList();
    }

    @Override
    @Transactional
    public UserAccountResponse updateUserAccount(final Long userAccountId, final UpdateUserAccountRequest request) {
        final UserAccountEntity entity = getActiveUserAccount(userAccountId);
        final String username = ServiceValidationUtils.normalizeRequiredText(
            request.username(),
            ApiMessageKey.USERNAME_REQUIRED
        );
        final String email = normalizeEmail(request.email());

        assertUsernameAvailable(username, entity.getId());
        assertEmailAvailable(email, entity.getId());

        entity.setUsername(username);
        entity.setEmail(email);
        entity.setAccountStatus(request.accountStatus());

        // Re-hash the password only when the caller provides a replacement.
        if (request.password() != null) {
            final String password = ServiceValidationUtils.normalizeRequiredText(
                request.password(),
                ApiMessageKey.PASSWORD_REQUIRED
            );
            entity.setPasswordHash(passwordEncoder.encode(password));
        }

        // Return the updated user account snapshot.
        return userAccountMapper.toDto(userAccountRepository.save(entity));
    }

    @Override
    @Transactional
    public void deleteUserAccount(final Long userAccountId) {
        final UserAccountEntity entity = getActiveUserAccount(userAccountId);

        // Block deletion while the user still owns active folders.
        if (!folderRepository.findAllByUserIdAndDeletedAtIsNull(entity.getId(), ID_ASC_SORT).isEmpty()) {
            // Reject deletion when active folders still reference the user.
            throw new ConflictException(ApiMessageKey.USER_ACCOUNT_DELETE_HAS_ACTIVE_FOLDERS);
        }

        // Block deletion while the user still owns custom review profiles.
        if (!reviewProfileRepository.findAllByOwnerUserId(entity.getId(), ID_ASC_SORT).isEmpty()) {
            // Reject deletion when custom review profiles still reference the user.
            throw new ConflictException(ApiMessageKey.USER_ACCOUNT_DELETE_HAS_CUSTOM_REVIEW_PROFILES);
        }

        entity.setDeletedAt(OffsetDateTime.now());
        userAccountRepository.save(entity);
    }

    private UserAccountEntity getActiveUserAccount(final Long userAccountId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(
            userAccountId,
            ApiMessageKey.USER_ACCOUNT_ID_POSITIVE
        );
        // Return the active user account or fail when the row is missing or soft-deleted.
        return userAccountRepository.findByIdAndDeletedAtIsNull(validatedId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.USER_ACCOUNT_NOT_FOUND, validatedId));
    }

    private void assertUsernameAvailable(final String username, final Long userAccountId) {
        final boolean alreadyExists = userAccountId == null
            ? userAccountRepository.existsByUsernameIgnoreCaseAndDeletedAtIsNull(username)
            : userAccountRepository.existsByUsernameIgnoreCaseAndDeletedAtIsNullAndIdNot(username, userAccountId);

        // Reject duplicate usernames among active accounts.
        if (alreadyExists) {
            // Stop the write when another account already uses the same username.
            throw new ConflictException(ApiMessageKey.USERNAME_EXISTS);
        }
    }

    private void assertEmailAvailable(final String email, final Long userAccountId) {
        final boolean alreadyExists = userAccountId == null
            ? userAccountRepository.existsByEmailIgnoreCaseAndDeletedAtIsNull(email)
            : userAccountRepository.existsByEmailIgnoreCaseAndDeletedAtIsNullAndIdNot(email, userAccountId);

        // Reject duplicate emails among active accounts.
        if (alreadyExists) {
            // Stop the write when another account already uses the same email.
            throw new ConflictException(ApiMessageKey.EMAIL_EXISTS);
        }
    }

    private String normalizeEmail(final String email) {
        // Return a normalized email value that is stable for uniqueness checks.
        return StringUtils.lowerCase(
            ServiceValidationUtils.normalizeRequiredText(email, ApiMessageKey.EMAIL_REQUIRED),
            Locale.ROOT
        );
    }

    private AccountStatus resolveAccountStatus(final AccountStatus accountStatus) {
        // Default missing status values to the onboarding state.
        if (accountStatus == null) {
            // Return the initial status for newly created accounts.
            return AccountStatus.PENDING;
        }
        // Return the caller-provided status unchanged.
        return accountStatus;
    }
}



