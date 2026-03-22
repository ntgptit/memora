package com.memora.app.service;

import java.util.List;

import com.memora.app.dto.CreateDeckRequest;
import com.memora.app.dto.DeckDto;
import com.memora.app.dto.UpdateDeckRequest;

public interface DeckService {

    DeckDto createDeck(CreateDeckRequest request);

    DeckDto getDeck(Long deckId);

    List<DeckDto> getDecks(Long userId, Long folderId);

    DeckDto updateDeck(Long deckId, UpdateDeckRequest request);

    void deleteDeck(Long deckId);
}
