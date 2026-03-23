package com.memora.app.service;

import java.util.List;

import com.memora.app.dto.CreateDeckRequest;
import com.memora.app.dto.DeckDto;
import com.memora.app.dto.UpdateDeckRequest;

public interface DeckService {

    DeckDto createDeck(Long folderId, CreateDeckRequest request);

    DeckDto getDeck(Long folderId, Long deckId);

    List<DeckDto> getDecks(Long folderId, String searchQuery, String sortBy, String sortType, Integer page, Integer size);

    DeckDto updateDeck(Long folderId, Long deckId, UpdateDeckRequest request);

    void deleteDeck(Long folderId, Long deckId);
}
