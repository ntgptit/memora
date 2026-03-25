package com.memora.app.service.impl;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyLong;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.when;

import java.time.OffsetDateTime;
import java.util.Optional;

import com.memora.app.dto.common.AuditDto;
import com.memora.app.dto.request.folder.CreateFolderRequest;
import com.memora.app.dto.response.folder.FolderResponse;
import com.memora.app.entity.FolderEntity;
import com.memora.app.mapper.FolderMapper;
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
    private CurrentAuthenticatedUserService currentAuthenticatedUserService;

    @Mock
    private FolderMapper folderMapper;

    @InjectMocks
    private FolderServiceImpl folderService;

    @Test
    void createFolderUsesCurrentUserAndReturnsDerivedMetadata() {
        final AuthenticatedUser currentUser = new AuthenticatedUser(1L, "demo", "demo@memora.local", null);

        when(currentAuthenticatedUserService.getCurrentUser()).thenReturn(currentUser);
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
        when(folderMapper.toDto(any(FolderEntity.class), anyString(), anyLong())).thenAnswer(invocation -> {
            final FolderEntity entity = invocation.getArgument(0);
            return new FolderResponse(
                entity.getId(),
                entity.getName(),
                entity.getDescription(),
                invocation.getArgument(1),
                entity.getParentId(),
                entity.getDepth(),
                invocation.getArgument(2),
                new AuditDto(
                    entity.getCreatedAt(),
                    entity.getUpdatedAt(),
                    entity.getDeletedAt(),
                    entity.getVersion()
                )
            );
        });

        final var response = folderService.createFolder(new CreateFolderRequest("Root", "Main folder", null));

        assertThat(response.id()).isEqualTo(10L);
        assertThat(response.name()).isEqualTo("Root");
        assertThat(response.colorHex()).isNotBlank();
        assertThat(response.childFolderCount()).isZero();
        assertThat(response.audit()).isNotNull();
    }
}


