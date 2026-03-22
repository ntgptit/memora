package com.memora.app.service.impl;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Locale;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.CreateUserAccountRequest;
import com.memora.app.dto.UpdateUserAccountRequest;
import com.memora.app.dto.UserAccountDto;
import com.memora.app.entity.UserAccountEntity;
import com.memora.app.enums.AccountStatus;
import com.memora.app.exception.ConflictException;
import com.memora.app.exception.ResourceNotFoundException;
import com.memora.app.mapper.UserAccountMapper;
import com.memora.app.repository.FolderRepository;
import com.memora.app.repository.ReviewProfileRepository;
import com.memora.app.repository.UserAccountRepository;
import com.memora.app.service.UserAccountService;
import com.memora.app.util.ServiceValidationUtils;

import org.apache.commons.lang3.StringUtils;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UserAccountServiceImpl implements UserAccountService {

    private final FolderRepository folderRepository;
    private final PasswordEncoder passwordEncoder;
    private final ReviewProfileRepository reviewProfileRepository;
    private final UserAccountRepository userAccountRepository;

    @Override
    @Transactional
    public UserAccountDto createUserAccount(final CreateUserAccountRequest request) {
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

        final UserAccountEntity entity = new UserAccountEntity();
        entity.setUsername(username);
        entity.setEmail(email);
        entity.setPasswordHash(passwordEncoder.encode(password));
        entity.setAccountStatus(resolveAccountStatus(request.accountStatus()));
        return UserAccountMapper.toDto(userAccountRepository.save(entity));
    }

    @Override
    @Transactional(readOnly = true)
    public UserAccountDto getUserAccount(final Long userAccountId) {
        return UserAccountMapper.toDto(getActiveUserAccount(userAccountId));
    }

    @Override
    @Transactional(readOnly = true)
    public List<UserAccountDto> getUserAccounts(final AccountStatus accountStatus) {
        if (accountStatus == null) {
            return userAccountRepository.findAllByDeletedAtIsNullOrderByIdAsc()
                .stream()
                .map(UserAccountMapper::toDto)
                .toList();
        }
        return userAccountRepository.findAllByAccountStatusAndDeletedAtIsNullOrderByIdAsc(accountStatus)
            .stream()
            .map(UserAccountMapper::toDto)
            .toList();
    }

    @Override
    @Transactional
    public UserAccountDto updateUserAccount(final Long userAccountId, final UpdateUserAccountRequest request) {
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

        if (request.password() != null) {
            final String password = ServiceValidationUtils.normalizeRequiredText(
                request.password(),
                ApiMessageKey.PASSWORD_REQUIRED
            );
            entity.setPasswordHash(passwordEncoder.encode(password));
        }

        return UserAccountMapper.toDto(userAccountRepository.save(entity));
    }

    @Override
    @Transactional
    public void deleteUserAccount(final Long userAccountId) {
        final UserAccountEntity entity = getActiveUserAccount(userAccountId);

        if (!folderRepository.findAllByUserIdAndDeletedAtIsNullOrderByIdAsc(entity.getId()).isEmpty()) {
            throw new ConflictException(ApiMessageKey.USER_ACCOUNT_DELETE_HAS_ACTIVE_FOLDERS);
        }

        if (!reviewProfileRepository.findAllByOwnerUserIdOrderByIdAsc(entity.getId()).isEmpty()) {
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
        return userAccountRepository.findByIdAndDeletedAtIsNull(validatedId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.USER_ACCOUNT_NOT_FOUND, validatedId));
    }

    private void assertUsernameAvailable(final String username, final Long userAccountId) {
        final boolean alreadyExists = userAccountId == null
            ? userAccountRepository.existsByUsernameIgnoreCaseAndDeletedAtIsNull(username)
            : userAccountRepository.existsByUsernameIgnoreCaseAndDeletedAtIsNullAndIdNot(username, userAccountId);

        if (alreadyExists) {
            throw new ConflictException(ApiMessageKey.USERNAME_EXISTS);
        }
    }

    private void assertEmailAvailable(final String email, final Long userAccountId) {
        final boolean alreadyExists = userAccountId == null
            ? userAccountRepository.existsByEmailIgnoreCaseAndDeletedAtIsNull(email)
            : userAccountRepository.existsByEmailIgnoreCaseAndDeletedAtIsNullAndIdNot(email, userAccountId);

        if (alreadyExists) {
            throw new ConflictException(ApiMessageKey.EMAIL_EXISTS);
        }
    }

    private String normalizeEmail(final String email) {
        return StringUtils.lowerCase(
            ServiceValidationUtils.normalizeRequiredText(email, ApiMessageKey.EMAIL_REQUIRED),
            Locale.ROOT
        );
    }

    private AccountStatus resolveAccountStatus(final AccountStatus accountStatus) {
        if (accountStatus == null) {
            return AccountStatus.PENDING;
        }
        return accountStatus;
    }
}
