package com.memora.app.service.impl;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

import java.util.Optional;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.CreateDeckRequest;
import com.memora.app.entity.FolderEntity;
import com.memora.app.entity.UserAccountEntity;
import com.memora.app.enums.AccountStatus;
import com.memora.app.exception.ConflictException;
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
class DeckServiceImplTest {

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
    private DeckServiceImpl deckService;

    @Test
    void createDeckRejectsNonLeafFolder() {
        final UserAccountEntity currentUser = new UserAccountEntity();
        currentUser.setId(1L);
        currentUser.setAccountStatus(AccountStatus.ACTIVE);
        final FolderEntity folder = new FolderEntity();
        folder.setId(20L);
        folder.setUserId(1L);

        when(userAccountRepository.findFirstByAccountStatusAndDeletedAtIsNullOrderByIdAsc(AccountStatus.ACTIVE))
            .thenReturn(Optional.of(currentUser));
        when(folderRepository.findByIdAndDeletedAtIsNull(20L)).thenReturn(Optional.of(folder));
        when(folderRepository.existsByParentIdAndDeletedAtIsNull(20L)).thenReturn(true);

        assertThatThrownBy(() -> deckService.createDeck(20L, new CreateDeckRequest("Deck", "Desc")))
            .isInstanceOf(ConflictException.class)
            .hasMessageContaining(ApiMessageKey.FOLDER_NOT_LEAF_FOR_DECK);
    }
}
