package com.memora.app.controller;

import java.util.List;

import com.memora.app.dto.request.deck.CreateDeckRequest;
import com.memora.app.dto.response.deck.DeckResponse;
import com.memora.app.dto.request.deck.UpdateDeckRequest;
import com.memora.app.service.DeckService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/**
 * REST endpoints for deck management.
 */
@Tag(name = "Decks", description = "CRUD APIs for Memora decks")
@RestController
@Validated
@RequestMapping("/api/v1/folders/{folderId}/decks")
@RequiredArgsConstructor
public class DeckController {

    private final DeckService deckService;

    /**
     * Create a deck inside a folder.
     *
     * @param folderId folder identifier
     * @param request deck payload
     * @return created deck
     */
    @Operation(summary = "Create deck")
    @ApiResponses({
        @ApiResponse(responseCode = "201", description = "Deck created"),
        @ApiResponse(responseCode = "400", description = "Request is invalid"),
        @ApiResponse(responseCode = "404", description = "Folder not found"),
        @ApiResponse(responseCode = "409", description = "Deck name already exists or folder is not a leaf")
    })
    @PostMapping
    public ResponseEntity<DeckResponse> createDeck(
        @PathVariable final Long folderId,
        @Valid @RequestBody final CreateDeckRequest request
    ) {
        return ResponseEntity.status(HttpStatus.CREATED).body(deckService.createDeck(folderId, request));
    }

    /**
     * Get a deck inside a folder by id.
     *
     * @param folderId folder identifier
     * @param deckId deck identifier
     * @return deck details
     */
    @Operation(summary = "Get deck by id")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Deck found"),
        @ApiResponse(responseCode = "404", description = "Deck not found")
    })
    @GetMapping("/{deckId}")
    public ResponseEntity<DeckResponse> getDeck(
        @PathVariable final Long folderId,
        @PathVariable final Long deckId
    ) {
        return ResponseEntity.ok(deckService.getDeck(folderId, deckId));
    }

    /**
     * List decks under a folder.
     *
     * @param folderId folder identifier
     * @param searchQuery optional search text
     * @param sortBy optional sort field
     * @param sortType optional sort direction
     * @param page optional page index
     * @param size optional page size
     * @return matching decks
     */
    @Operation(summary = "List decks")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Decks loaded")
    })
    @GetMapping
    public ResponseEntity<List<DeckResponse>> getDecks(
        @PathVariable final Long folderId,
        @RequestParam(required = false) final String searchQuery,
        @RequestParam(required = false, defaultValue = "NAME") final String sortBy,
        @RequestParam(required = false, defaultValue = "ASC") final String sortType,
        @RequestParam(required = false, defaultValue = "0") final Integer page,
        @RequestParam(required = false, defaultValue = "20") final Integer size
    ) {
        return ResponseEntity.ok(deckService.getDecks(folderId, searchQuery, sortBy, sortType, page, size));
    }

    /**
     * Update a deck inside a folder.
     *
     * @param folderId folder identifier
     * @param deckId deck identifier
     * @param request updated deck payload
     * @return updated deck
     */
    @Operation(summary = "Update deck")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Deck updated"),
        @ApiResponse(responseCode = "400", description = "Request is invalid"),
        @ApiResponse(responseCode = "404", description = "Deck or folder not found"),
        @ApiResponse(responseCode = "409", description = "Deck name already exists")
    })
    @PutMapping("/{deckId}")
    public ResponseEntity<DeckResponse> updateDeck(
        @PathVariable final Long folderId,
        @PathVariable final Long deckId,
        @Valid @RequestBody final UpdateDeckRequest request
    ) {
        return ResponseEntity.ok(deckService.updateDeck(folderId, deckId, request));
    }

    /**
     * Delete a deck inside a folder.
     *
     * @param folderId folder identifier
     * @param deckId deck identifier
     * @return empty response
     */
    @Operation(summary = "Delete deck")
    @ApiResponses({
        @ApiResponse(responseCode = "204", description = "Deck deleted"),
        @ApiResponse(responseCode = "404", description = "Deck not found")
    })
    @DeleteMapping("/{deckId}")
    public ResponseEntity<Void> deleteDeck(
        @PathVariable final Long folderId,
        @PathVariable final Long deckId
    ) {
        deckService.deleteDeck(folderId, deckId);
        return ResponseEntity.noContent().build();
    }
}



