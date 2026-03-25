package com.memora.app.service.impl;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.time.OffsetDateTime;
import java.util.List;
import java.util.Optional;

import com.memora.app.dto.request.user_account.UpdateUserAccountRequest;
import com.memora.app.dto.response.user_account.UserAccountResponse;
import com.memora.app.entity.FolderEntity;
import com.memora.app.entity.ReviewProfileEntity;
import com.memora.app.entity.UserAccountEntity;
import com.memora.app.enums.user_account.AccountStatus;
import com.memora.app.exception.ConflictException;
import com.memora.app.mapper.UserAccountMapper;
import com.memora.app.repository.FolderRepository;
import com.memora.app.repository.ReviewProfileRepository;
import com.memora.app.repository.UserAccountRepository;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Sort;
import org.springframework.security.crypto.password.PasswordEncoder;

@ExtendWith(MockitoExtension.class)
class UserAccountServiceImplTest {

    @Mock
    private FolderRepository folderRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private ReviewProfileRepository reviewProfileRepository;

    @Mock
    private UserAccountRepository userAccountRepository;

    @Mock
    private UserAccountMapper userAccountMapper;

    @InjectMocks
    private UserAccountServiceImpl userAccountService;

    @Test
    void getUserAccountsReturnsAllActiveAccountsWhenStatusMissing() {
        final UserAccountEntity entity = userAccountEntity(1L, "demo", "demo@memora.local");
        final UserAccountResponse expectedResponse = userAccountResponse(entity);

        when(userAccountRepository.findAllByDeletedAtIsNull(any(Sort.class))).thenReturn(List.of(entity));
        when(userAccountMapper.toDto(entity)).thenReturn(expectedResponse);

        final List<UserAccountResponse> response = userAccountService.getUserAccounts(null);

        assertThat(response).containsExactly(expectedResponse);
    }

    @Test
    void updateUserAccountRehashesPasswordWhenReplacementIsProvided() {
        final UserAccountEntity entity = userAccountEntity(1L, "demo", "demo@memora.local");

        when(userAccountRepository.findByIdAndDeletedAtIsNull(1L)).thenReturn(Optional.of(entity));
        when(userAccountRepository.existsByUsernameIgnoreCaseAndDeletedAtIsNullAndIdNot("updated-user", 1L)).thenReturn(false);
        when(userAccountRepository.existsByEmailIgnoreCaseAndDeletedAtIsNullAndIdNot("updated@memora.local", 1L))
            .thenReturn(false);
        when(passwordEncoder.encode("new-password")).thenReturn("encoded-password");
        when(userAccountRepository.save(any(UserAccountEntity.class))).thenAnswer(invocation -> invocation.getArgument(0));
        when(userAccountMapper.toDto(any(UserAccountEntity.class))).thenAnswer(invocation -> {
            final UserAccountEntity savedEntity = invocation.getArgument(0);
            return userAccountResponse(savedEntity);
        });

        final UserAccountResponse response = userAccountService.updateUserAccount(
            1L,
            new UpdateUserAccountRequest("updated-user", "UPDATED@memora.local", "new-password", AccountStatus.ACTIVE)
        );

        verify(passwordEncoder).encode("new-password");
        assertThat(entity.getPasswordHash()).isEqualTo("encoded-password");
        assertThat(response.username()).isEqualTo("updated-user");
        assertThat(response.email()).isEqualTo("updated@memora.local");
    }

    @Test
    void deleteUserAccountRejectsWhenActiveFoldersExist() {
        final UserAccountEntity entity = userAccountEntity(1L, "demo", "demo@memora.local");
        final FolderEntity folder = new FolderEntity();
        folder.setId(10L);

        when(userAccountRepository.findByIdAndDeletedAtIsNull(1L)).thenReturn(Optional.of(entity));
        when(folderRepository.findAllByUserIdAndDeletedAtIsNull(org.mockito.ArgumentMatchers.eq(1L), any(Sort.class)))
            .thenReturn(List.of(folder));

        assertThatThrownBy(() -> userAccountService.deleteUserAccount(1L)).isInstanceOf(ConflictException.class);
    }

    @Test
    void deleteUserAccountRejectsWhenCustomReviewProfilesExist() {
        final UserAccountEntity entity = userAccountEntity(1L, "demo", "demo@memora.local");
        final ReviewProfileEntity reviewProfile = new ReviewProfileEntity();
        reviewProfile.setId(20L);

        when(userAccountRepository.findByIdAndDeletedAtIsNull(1L)).thenReturn(Optional.of(entity));
        when(folderRepository.findAllByUserIdAndDeletedAtIsNull(org.mockito.ArgumentMatchers.eq(1L), any(Sort.class)))
            .thenReturn(List.of());
        when(reviewProfileRepository.findAllByOwnerUserId(org.mockito.ArgumentMatchers.eq(1L), any(Sort.class)))
            .thenReturn(List.of(reviewProfile));

        assertThatThrownBy(() -> userAccountService.deleteUserAccount(1L)).isInstanceOf(ConflictException.class);
    }

    private UserAccountEntity userAccountEntity(final Long id, final String username, final String email) {
        final UserAccountEntity entity = new UserAccountEntity();
        entity.setId(id);
        entity.setUsername(username);
        entity.setEmail(email);
        entity.setPasswordHash("stored-password");
        entity.setAccountStatus(AccountStatus.ACTIVE);
        entity.setCreatedAt(OffsetDateTime.parse("2026-01-01T00:00:00Z"));
        entity.setUpdatedAt(OffsetDateTime.parse("2026-01-01T00:00:00Z"));
        entity.setVersion(1L);
        return entity;
    }

    private UserAccountResponse userAccountResponse(final UserAccountEntity entity) {
        return new UserAccountResponse(
            entity.getId(),
            entity.getUsername(),
            entity.getEmail(),
            entity.getAccountStatus(),
            entity.getDeletedAt(),
            entity.getCreatedAt(),
            entity.getUpdatedAt(),
            entity.getVersion()
        );
    }
}
