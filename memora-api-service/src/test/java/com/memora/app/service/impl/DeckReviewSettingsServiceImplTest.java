package com.memora.app.service.impl;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

import java.util.List;
import java.util.Optional;

import com.memora.app.dto.request.deck_review_settings.CreateDeckReviewSettingsRequest;
import com.memora.app.dto.response.deck_review_settings.DeckReviewSettingsResponse;
import com.memora.app.entity.DeckEntity;
import com.memora.app.entity.DeckReviewSettingsEntity;
import com.memora.app.exception.ConflictException;
import com.memora.app.mapper.DeckReviewSettingsMapper;
import com.memora.app.repository.DeckRepository;
import com.memora.app.repository.DeckReviewSettingsRepository;
import com.memora.app.repository.ReviewProfileRepository;
import com.memora.app.support.RecordFixtureFactory;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class DeckReviewSettingsServiceImplTest {

    @Mock
    private DeckRepository deckRepository;

    @Mock
    private DeckReviewSettingsRepository deckReviewSettingsRepository;

    @Mock
    private ReviewProfileRepository reviewProfileRepository;

    @Mock
    private DeckReviewSettingsMapper deckReviewSettingsMapper;

    @InjectMocks
    private DeckReviewSettingsServiceImpl deckReviewSettingsService;

    @Test
    void createDeckReviewSettingsRejectsDuplicateSettingsForDeck() {
        final DeckEntity deck = new DeckEntity();
        deck.setId(10L);
        deck.setUserId(20L);

        when(deckRepository.findByIdAndDeletedAtIsNull(10L)).thenReturn(Optional.of(deck));
        when(deckReviewSettingsRepository.existsByDeckId(10L)).thenReturn(true);

        assertThatThrownBy(() -> deckReviewSettingsService.createDeckReviewSettings(
            new CreateDeckReviewSettingsRequest(10L, 30L, 20, 100, true, 8, false)
        ))
            .isInstanceOf(ConflictException.class);
    }

    @Test
    void getDeckReviewSettingsListReturnsDeckScopedRowsWhenDeckIdProvided() {
        final DeckReviewSettingsEntity entity = new DeckReviewSettingsEntity();
        entity.setId(1L);
        entity.setDeckId(10L);
        final DeckReviewSettingsResponse expectedResponse = RecordFixtureFactory.createRecord(
            DeckReviewSettingsResponse.class
        );

        when(deckReviewSettingsRepository.findByDeckId(10L)).thenReturn(Optional.of(entity));
        when(deckReviewSettingsMapper.toDto(entity)).thenReturn(expectedResponse);

        final List<DeckReviewSettingsResponse> response = deckReviewSettingsService.getDeckReviewSettingsList(10L);

        assertThat(response).containsExactly(expectedResponse);
    }
}
