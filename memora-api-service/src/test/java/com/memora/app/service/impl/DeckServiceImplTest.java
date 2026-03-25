package com.memora.app.service.impl;

import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

import java.util.Optional;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.request.deck.CreateDeckRequest;
import com.memora.app.entity.FolderEntity;
import com.memora.app.enums.user_account.AccountStatus;
import com.memora.app.exception.ConflictException;
import com.memora.app.mapper.DeckMapper;
import com.memora.app.repository.DeckRepository;
import com.memora.app.repository.DeckReviewSettingsRepository;
import com.memora.app.repository.FlashcardLanguageRepository;
import com.memora.app.repository.FlashcardRepository;
import com.memora.app.repository.FolderRepository;
import com.memora.app.security.AuthenticatedUser;
import com.memora.app.security.CurrentAuthenticatedUserService;

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
    private CurrentAuthenticatedUserService currentAuthenticatedUserService;

    @Mock
    private DeckMapper deckMapper;

    @InjectMocks
    private DeckServiceImpl deckService;

    @Test
    void createDeckRejectsNonLeafFolder() {
        final FolderEntity folder = new FolderEntity();
        folder.setId(20L);
        folder.setUserId(1L);

        when(currentAuthenticatedUserService.getCurrentUser())
            .thenReturn(new AuthenticatedUser(1L, "demo", "demo@memora.local", AccountStatus.ACTIVE));
        when(folderRepository.findByIdAndDeletedAtIsNull(20L)).thenReturn(Optional.of(folder));
        when(folderRepository.existsByParentIdAndDeletedAtIsNull(20L)).thenReturn(true);

        assertThatThrownBy(() -> deckService.createDeck(20L, new CreateDeckRequest("Deck", "Desc")))
            .isInstanceOf(ConflictException.class)
            .hasMessageContaining(ApiMessageKey.FOLDER_NOT_LEAF_FOR_DECK);
    }
}


