package com.memora.app.service.impl;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.Mockito.when;

import java.time.OffsetDateTime;
import java.util.Optional;

import com.memora.app.dto.CreateFolderRequest;
import com.memora.app.entity.FolderEntity;
import com.memora.app.entity.UserAccountEntity;
import com.memora.app.enums.AccountStatus;
import com.memora.app.repository.DeckRepository;
import com.memora.app.repository.DeckReviewSettingsRepository;
import com.memora.app.repository.FlashcardLanguageRepository;
import com.memora.app.repository.FlashcardRepository;
import com.memora.app.repository.FolderRepository;
import com.memora.app.repository.UserAccountRepository;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class FolderServiceImplTest {

    @Mock
    private DeckRepository deckRepository;

    @Mock
    private DeckReviewSettingsRepository deckReviewSettingsRepository;

    @Mock
    private FlashcardLanguageRepository flashcardLanguageRepository;

    @Mock
    private FlashcardRepository flashcardRepository;

    @Mock
    private FolderRepository folderRepository;

    @Mock
    private UserAccountRepository userAccountRepository;

    @InjectMocks
    private FolderServiceImpl folderService;

    @Test
    void createFolderUsesCurrentUserAndReturnsDerivedMetadata() {
        final UserAccountEntity currentUser = new UserAccountEntity();
        currentUser.setId(1L);
        currentUser.setAccountStatus(AccountStatus.ACTIVE);

        when(userAccountRepository.findFirstByAccountStatusAndDeletedAtIsNullOrderByIdAsc(AccountStatus.ACTIVE))
            .thenReturn(Optional.of(currentUser));
        when(folderRepository.existsByUserIdAndParentIdAndNameIgnoreCaseAndDeletedAtIsNull(1L, null, "Root"))
            .thenReturn(false);
        when(folderRepository.save(any(FolderEntity.class))).thenAnswer(invocation -> {
            final FolderEntity entity = invocation.getArgument(0);
            entity.setId(10L);
            entity.setCreatedAt(OffsetDateTime.parse("2026-01-01T00:00:00Z"));
            entity.setUpdatedAt(OffsetDateTime.parse("2026-01-01T00:00:00Z"));
            return entity;
        });
        when(folderRepository.countByParentIdAndDeletedAtIsNull(10L)).thenReturn(0L);

        final var response = folderService.createFolder(new CreateFolderRequest("Root", "Main folder", null));

        assertThat(response.id()).isEqualTo(10L);
        assertThat(response.name()).isEqualTo("Root");
        assertThat(response.colorHex()).isNotBlank();
        assertThat(response.childFolderCount()).isZero();
        assertThat(response.audit()).isNotNull();
    }
}
