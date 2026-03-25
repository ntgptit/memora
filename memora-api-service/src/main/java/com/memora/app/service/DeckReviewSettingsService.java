package com.memora.app.service;

import java.util.List;

import com.memora.app.dto.request.deck_review_settings.CreateDeckReviewSettingsRequest;
import com.memora.app.dto.response.deck_review_settings.DeckReviewSettingsResponse;
import com.memora.app.dto.request.deck_review_settings.UpdateDeckReviewSettingsRequest;

public interface DeckReviewSettingsService {

    DeckReviewSettingsResponse createDeckReviewSettings(CreateDeckReviewSettingsRequest request);

    DeckReviewSettingsResponse getDeckReviewSettingsById(Long deckReviewSettingsId);

    List<DeckReviewSettingsResponse> getDeckReviewSettingsList(Long deckId);

    DeckReviewSettingsResponse updateDeckReviewSettings(
        Long deckReviewSettingsId,
        UpdateDeckReviewSettingsRequest request
    );

    void deleteDeckReviewSettings(Long deckReviewSettingsId);
}



