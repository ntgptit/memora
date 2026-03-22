package com.memora.app.service;

import java.util.List;

import com.memora.app.dto.CreateDeckReviewSettingsRequest;
import com.memora.app.dto.DeckReviewSettingsDto;
import com.memora.app.dto.UpdateDeckReviewSettingsRequest;

public interface DeckReviewSettingsService {

    DeckReviewSettingsDto createDeckReviewSettings(CreateDeckReviewSettingsRequest request);

    DeckReviewSettingsDto getDeckReviewSettingsById(Long deckReviewSettingsId);

    List<DeckReviewSettingsDto> getDeckReviewSettingsList(Long deckId);

    DeckReviewSettingsDto updateDeckReviewSettings(
        Long deckReviewSettingsId,
        UpdateDeckReviewSettingsRequest request
    );

    void deleteDeckReviewSettings(Long deckReviewSettingsId);
}
