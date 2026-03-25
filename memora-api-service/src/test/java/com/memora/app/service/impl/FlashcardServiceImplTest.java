package com.memora.app.service.impl;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.when;

import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import com.memora.app.dto.common.AuditDto;
import com.memora.app.dto.request.flashcard.CreateFlashcardRequest;
import com.memora.app.dto.response.flashcard.FlashcardResponse;
import com.memora.app.dto.response.flashcard.FlashcardPageResponse;
import com.memora.app.dto.request.flashcard.UpdateFlashcardRequest;
import com.memora.app.entity.DeckEntity;
import com.memora.app.entity.FlashcardEntity;
import com.memora.app.entity.FlashcardLanguageEntity;
import com.memora.app.enums.user_account.AccountStatus;
import com.memora.app.enums.flashcard.FlashcardSide;
import com.memora.app.exception.ResourceNotFoundException;
import com.memora.app.mapper.FlashcardMapper;
import com.memora.app.repository.DeckRepository;
import com.memora.app.repository.FlashcardLanguageRepository;
import com.memora.app.repository.FlashcardRepository;
import com.memora.app.security.AuthenticatedUser;
import com.memora.app.security.CurrentAuthenticatedUserService;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;

@ExtendWith(MockitoExtension.class)
class FlashcardServiceImplTest {
    @Mock
    private DeckRepository deckRepository;
    @Mock
    private FlashcardLanguageRepository flashcardLanguageRepository;
    @Mock
    private FlashcardRepository flashcardRepository;
    @Mock
    private CurrentAuthenticatedUserService currentAuthenticatedUserService;
    @Mock
    private FlashcardMapper flashcardMapper;
    @InjectMocks
    private FlashcardServiceImpl flashcardService;

    @Test
    void createFlashcardStoresFrontAndBackLanguageRows() {
        final DeckEntity deck = deckEntity(10L, 1L);
        final List<FlashcardLanguageEntity> storedLanguages = new ArrayList<>();

        when(currentAuthenticatedUserService.getCurrentUser()).thenReturn(currentUser(1L));
        when(deckRepository.findByIdAndDeletedAtIsNull(10L)).thenReturn(Optional.of(deck));
        when(flashcardRepository.save(any(FlashcardEntity.class))).thenAnswer(invocation -> {
            final FlashcardEntity entity = invocation.getArgument(0);
            entity.setId(100L);
            entity.setCreatedAt(OffsetDateTime.parse("2026-01-01T00:00:00Z"));
            entity.setUpdatedAt(OffsetDateTime.parse("2026-01-01T00:00:00Z"));
            entity.setVersion(0L);
            return entity;
        });
        when(flashcardLanguageRepository.findAllByFlashcardId(org.mockito.ArgumentMatchers.eq(100L), any(Sort.class))).thenAnswer(
            invocation -> List.copyOf(storedLanguages)
        );
        when(flashcardLanguageRepository.save(any(FlashcardLanguageEntity.class))).thenAnswer(invocation -> {
            final FlashcardLanguageEntity entity = invocation.getArgument(0);
            entity.setId(entity.getId() == null ? (long) storedLanguages.size() + 1 : entity.getId());
            entity.setCreatedAt(OffsetDateTime.parse("2026-01-01T00:00:00Z"));
            entity.setUpdatedAt(OffsetDateTime.parse("2026-01-01T00:00:00Z"));
            entity.setVersion(0L);
            storedLanguages.removeIf(existing -> existing.getSide() == entity.getSide());
            storedLanguages.add(entity);
            return entity;
        });
        stubFlashcardMapper();

        final FlashcardResponse response = flashcardService.createFlashcard(
            10L,
            new CreateFlashcardRequest("Front", "Back", "en", "vi")
        );

        assertThat(response.id()).isEqualTo(100L);
        assertThat(response.deckId()).isEqualTo(10L);
        assertThat(response.frontText()).isEqualTo("Front");
        assertThat(response.backText()).isEqualTo("Back");
        assertThat(response.frontLangCode()).isEqualTo("en");
        assertThat(response.backLangCode()).isEqualTo("vi");
        assertThat(response.pronunciation()).isEqualTo("");
        assertThat(response.note()).isEmpty();
        assertThat(response.isBookmarked()).isFalse();
        assertThat(response.audit()).isNotNull();
        assertThat(response.audit().version()).isZero();

        verify(flashcardLanguageRepository, times(2)).save(any(FlashcardLanguageEntity.class));
        verify(flashcardLanguageRepository, times(2)).findAllByFlashcardId(org.mockito.ArgumentMatchers.eq(100L), any(Sort.class));
    }

    @Test
    void getFlashcardsReturnsPagedContractResponse() {
        final DeckEntity deck = deckEntity(10L, 1L);
        final FlashcardEntity flashcard = flashcardEntity(100L, 10L, "Alpha", "Beta");
        flashcard.setNote("Gamma");
        flashcard.setCreatedAt(OffsetDateTime.parse("2026-01-01T00:00:00Z"));
        flashcard.setUpdatedAt(OffsetDateTime.parse("2026-01-02T00:00:00Z"));
        flashcard.setVersion(3L);

        final List<FlashcardLanguageEntity> languages = List.of(
            flashcardLanguageEntity(1L, 100L, FlashcardSide.TERM, "en", "a"),
            flashcardLanguageEntity(2L, 100L, FlashcardSide.MEANING, "vi", "")
        );

        when(currentAuthenticatedUserService.getCurrentUser()).thenReturn(currentUser(1L));
        when(deckRepository.findByIdAndDeletedAtIsNull(10L)).thenReturn(Optional.of(deck));
        when(flashcardRepository.findAll(any(Specification.class), any(Pageable.class))).thenReturn(
            new PageImpl<>(List.of(flashcard), PageRequest.of(1, 7, Sort.by("updatedAt")), 8L)
        );
        when(flashcardLanguageRepository.findAllByFlashcardId(org.mockito.ArgumentMatchers.eq(100L), any(Sort.class))).thenReturn(languages);
        stubFlashcardMapper();

        final FlashcardPageResponse response = flashcardService.getFlashcards(
            10L,
            "alp",
            "UPDATED_AT",
            "DESC",
            1,
            7
        );

        final ArgumentCaptor<Pageable> pageableCaptor = ArgumentCaptor.forClass(Pageable.class);
        verify(flashcardRepository).findAll(any(Specification.class), pageableCaptor.capture());

        assertThat(pageableCaptor.getValue().getPageNumber()).isEqualTo(1);
        assertThat(pageableCaptor.getValue().getPageSize()).isEqualTo(7);
        assertThat(pageableCaptor.getValue().getSort().getOrderFor("updatedAt").getDirection()).isEqualTo(Sort.Direction.DESC);
        assertThat(response.page()).isEqualTo(1);
        assertThat(response.size()).isEqualTo(7);
        assertThat(response.totalElements()).isEqualTo(8L);
        assertThat(response.totalPages()).isEqualTo(2);
        assertThat(response.hasNext()).isFalse();
        assertThat(response.hasPrevious()).isTrue();
        assertThat(response.items()).hasSize(1);
        assertThat(response.items().get(0).frontLangCode()).isEqualTo("en");
        assertThat(response.items().get(0).backLangCode()).isEqualTo("vi");
        assertThat(response.items().get(0).pronunciation()).isEqualTo("a");
    }

    @Test
    void updateFlashcardRejectsFlashcardOutsideDeckScope() {
        final DeckEntity deck = deckEntity(10L, 1L);

        when(currentAuthenticatedUserService.getCurrentUser()).thenReturn(currentUser(1L));
        when(deckRepository.findByIdAndDeletedAtIsNull(10L)).thenReturn(Optional.of(deck));
        when(flashcardRepository.findByIdAndDeckIdAndDeletedAtIsNull(100L, 10L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> flashcardService.updateFlashcard(
            10L,
            100L,
            new UpdateFlashcardRequest("Front", "Back", null, null)
        ))
            .isInstanceOf(ResourceNotFoundException.class);
    }
    @Test
    void deleteFlashcardSoftDeletesAndClearsLanguageRows() {
        final DeckEntity deck = deckEntity(10L, 1L);
        final FlashcardEntity flashcard = flashcardEntity(100L, 10L, "Alpha", "Beta");
        final List<FlashcardLanguageEntity> languages = new ArrayList<>(List.of(
            flashcardLanguageEntity(1L, 100L, FlashcardSide.TERM, "en", "a"),
            flashcardLanguageEntity(2L, 100L, FlashcardSide.MEANING, "vi", "")
        ));

        when(currentAuthenticatedUserService.getCurrentUser()).thenReturn(currentUser(1L));
        when(deckRepository.findByIdAndDeletedAtIsNull(10L)).thenReturn(Optional.of(deck));
        when(flashcardRepository.findByIdAndDeckIdAndDeletedAtIsNull(100L, 10L)).thenReturn(Optional.of(flashcard));
        when(flashcardLanguageRepository.removeByFlashcardId(100L)).thenAnswer(invocation -> {
            languages.clear();
            return 2L;
        });
        when(flashcardRepository.save(any(FlashcardEntity.class))).thenAnswer(invocation -> invocation.getArgument(0));

        flashcardService.deleteFlashcard(10L, 100L);

        assertThat(flashcard.getDeletedAt()).isNotNull();
        assertThat(languages).isEmpty();
    }

    @Test
    void createFlashcardRejectsDeckOutsideCurrentUserScope() {
        final DeckEntity foreignDeck = deckEntity(10L, 2L);

        when(currentAuthenticatedUserService.getCurrentUser()).thenReturn(currentUser(1L));
        when(deckRepository.findByIdAndDeletedAtIsNull(10L)).thenReturn(Optional.of(foreignDeck));

        assertThatThrownBy(() -> flashcardService.createFlashcard(
            10L,
            new CreateFlashcardRequest("Front", "Back", null, null)
        ))
            .isInstanceOf(ResourceNotFoundException.class);
    }
    private DeckEntity deckEntity(final Long id, final Long userId) {
        final DeckEntity deck = new DeckEntity();
        deck.setId(id);
        deck.setUserId(userId);
        return deck;
    }

    private AuthenticatedUser currentUser(final Long id) {
        return new AuthenticatedUser(id, "demo", "demo@memora.local", AccountStatus.ACTIVE);
    }

    private FlashcardEntity flashcardEntity(
        final Long id,
        final Long deckId,
        final String frontText,
        final String backText
    ) {
        final FlashcardEntity flashcard = new FlashcardEntity();
        flashcard.setId(id);
        flashcard.setDeckId(deckId);
        flashcard.setTerm(frontText);
        flashcard.setMeaning(backText);
        flashcard.setNote("");
        flashcard.setBookmarked(false);
        flashcard.setCreatedAt(OffsetDateTime.parse("2026-01-01T00:00:00Z"));
        flashcard.setUpdatedAt(OffsetDateTime.parse("2026-01-02T00:00:00Z"));
        flashcard.setVersion(1L);
        return flashcard;
    }

    private FlashcardLanguageEntity flashcardLanguageEntity(
        final Long id,
        final Long flashcardId,
        final FlashcardSide side,
        final String languageCode,
        final String pronunciation
    ) {
        final FlashcardLanguageEntity flashcardLanguage = new FlashcardLanguageEntity();
        flashcardLanguage.setId(id);
        flashcardLanguage.setFlashcardId(flashcardId);
        flashcardLanguage.setSide(side);
        flashcardLanguage.setLanguageCode(languageCode);
        flashcardLanguage.setPronunciation(pronunciation);
        flashcardLanguage.setCreatedAt(OffsetDateTime.parse("2026-01-01T00:00:00Z"));
        flashcardLanguage.setUpdatedAt(OffsetDateTime.parse("2026-01-02T00:00:00Z"));
        flashcardLanguage.setVersion(1L);
        return flashcardLanguage;
    }

    private void stubFlashcardMapper() {
        when(flashcardMapper.toDto(any(FlashcardEntity.class), any(), any(), any())).thenAnswer(invocation -> {
            final FlashcardEntity entity = invocation.getArgument(0);
            return new FlashcardResponse(
                entity.getId(),
                entity.getDeckId(),
                entity.getTerm(),
                entity.getMeaning(),
                invocation.getArgument(1),
                invocation.getArgument(2),
                invocation.getArgument(3),
                entity.getNote(),
                entity.isBookmarked(),
                new AuditDto(
                    entity.getCreatedAt(),
                    entity.getUpdatedAt(),
                    entity.getDeletedAt(),
                    entity.getVersion()
                )
            );
        });
    }
}



