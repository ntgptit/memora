package com.memora.app.service;

import java.util.List;

import com.memora.app.dto.request.deck.CreateDeckRequest;
import com.memora.app.dto.response.deck.DeckResponse;
import com.memora.app.dto.request.deck.UpdateDeckRequest;

public interface DeckService {

    DeckResponse createDeck(Long folderId, CreateDeckRequest request);

    DeckResponse getDeck(Long folderId, Long deckId);

    List<DeckResponse> getDecks(Long folderId, String searchQuery, String sortBy, String sortType, Integer page, Integer size);

    DeckResponse updateDeck(Long folderId, Long deckId, UpdateDeckRequest request);

    void deleteDeck(Long folderId, Long deckId);
}



