package com.memora.app.controller;

import java.util.List;

import com.memora.app.dto.CreateDeckRequest;
import com.memora.app.dto.DeckDto;
import com.memora.app.dto.UpdateDeckRequest;
import com.memora.app.service.DeckService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
@RequestMapping("/api/v1/decks")
@RequiredArgsConstructor
public class DeckController {

    private final DeckService deckService;

    /**
     * Create a deck.
     *
     * @param request deck payload
     * @return created deck
     */
    @Operation(summary = "Create deck")
    @ApiResponses({
        @ApiResponse(responseCode = "201", description = "Deck created"),
        @ApiResponse(responseCode = "400", description = "Request is invalid"),
        @ApiResponse(responseCode = "404", description = "Folder not found"),
        @ApiResponse(responseCode = "409", description = "Deck name already exists")
    })
    @PostMapping
    public ResponseEntity<DeckDto> createDeck(@Valid @RequestBody final CreateDeckRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(deckService.createDeck(request));
    }

    /**
     * Get a deck by id.
     *
     * @param deckId deck identifier
     * @return deck details
     */
    @Operation(summary = "Get deck by id")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Deck found"),
        @ApiResponse(responseCode = "404", description = "Deck not found")
    })
    @GetMapping("/{deckId}")
    public ResponseEntity<DeckDto> getDeck(@PathVariable final Long deckId) {
        return ResponseEntity.ok(deckService.getDeck(deckId));
    }

    /**
     * List decks.
     *
     * @param userId optional owner filter
     * @param folderId optional folder filter
     * @return matching decks
     */
    @Operation(summary = "List decks")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Decks loaded")
    })
    @GetMapping
    public ResponseEntity<List<DeckDto>> getDecks(
        @RequestParam(required = false) final Long userId,
        @RequestParam(required = false) final Long folderId
    ) {
        return ResponseEntity.ok(deckService.getDecks(userId, folderId));
    }

    /**
     * Update a deck.
     *
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
    public ResponseEntity<DeckDto> updateDeck(
        @PathVariable final Long deckId,
        @Valid @RequestBody final UpdateDeckRequest request
    ) {
        return ResponseEntity.ok(deckService.updateDeck(deckId, request));
    }

    /**
     * Soft delete a deck and its flashcards.
     *
     * @param deckId deck identifier
     * @return empty response
     */
    @Operation(summary = "Delete deck")
    @ApiResponses({
        @ApiResponse(responseCode = "204", description = "Deck deleted"),
        @ApiResponse(responseCode = "404", description = "Deck not found")
    })
    @DeleteMapping("/{deckId}")
    public ResponseEntity<Void> deleteDeck(@PathVariable final Long deckId) {
        deckService.deleteDeck(deckId);
        return ResponseEntity.noContent().build();
    }
}
