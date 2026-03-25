package com.memora.app.controller;

import com.memora.app.dto.request.flashcard.CreateFlashcardRequest;
import com.memora.app.dto.response.flashcard.FlashcardResponse;
import com.memora.app.dto.response.flashcard.FlashcardPageResponse;
import com.memora.app.dto.request.flashcard.UpdateFlashcardRequest;
import com.memora.app.service.FlashcardService;

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
 * REST endpoints for flashcard management.
 */
@Tag(name = "Flashcards", description = "CRUD APIs for Memora flashcards")
@RestController
@RequestMapping("/api/v1/decks/{deckId}/flashcards")
@RequiredArgsConstructor
public class FlashcardController {

    private final FlashcardService flashcardService;

    /**
     * Create a flashcard inside the requested deck scope.
     *
     * @param deckId deck identifier
     * @param request flashcard payload
     * @return created flashcard snapshot
     */
    @Operation(summary = "Create flashcard")
    @ApiResponses({
        @ApiResponse(responseCode = "201", description = "Flashcard created"),
        @ApiResponse(responseCode = "400", description = "Request is invalid"),
        @ApiResponse(responseCode = "404", description = "Deck not found")
    })
    @PostMapping
    public ResponseEntity<FlashcardResponse> createFlashcard(
        @PathVariable final Long deckId,
        @Valid @RequestBody final CreateFlashcardRequest request
    ) {
        return ResponseEntity.status(HttpStatus.CREATED).body(flashcardService.createFlashcard(deckId, request));
    }

    /**
     * List flashcards for the requested deck using paging and search.
     *
     * @param deckId deck identifier
     * @param searchQuery optional search text
     * @param sortBy optional sort field
     * @param sortType optional sort direction
     * @param page optional page index
     * @param size optional page size
     * @return paged flashcard response
     */
    @Operation(summary = "List flashcards")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Flashcards loaded"),
        @ApiResponse(responseCode = "404", description = "Deck not found")
    })
    @GetMapping
    public ResponseEntity<FlashcardPageResponse> getFlashcards(
        @PathVariable final Long deckId,
        @RequestParam(required = false) final String searchQuery,
        @RequestParam(required = false) final String sortBy,
        @RequestParam(required = false) final String sortType,
        @RequestParam(required = false) final Integer page,
        @RequestParam(required = false) final Integer size
    ) {
        return ResponseEntity.ok(flashcardService.getFlashcards(deckId, searchQuery, sortBy, sortType, page, size));
    }

    /**
     * Update a flashcard inside the requested deck scope.
     *
     * @param deckId deck identifier
     * @param flashcardId flashcard identifier
     * @param request updated flashcard payload
     * @return updated flashcard snapshot
     */
    @Operation(summary = "Update flashcard")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Flashcard updated"),
        @ApiResponse(responseCode = "400", description = "Request is invalid"),
        @ApiResponse(responseCode = "404", description = "Flashcard or deck not found")
    })
    @PutMapping("/{flashcardId}")
    public ResponseEntity<FlashcardResponse> updateFlashcard(
        @PathVariable final Long deckId,
        @PathVariable final Long flashcardId,
        @Valid @RequestBody final UpdateFlashcardRequest request
    ) {
        return ResponseEntity.ok(flashcardService.updateFlashcard(deckId, flashcardId, request));
    }

    /**
     * Soft delete a flashcard inside the requested deck scope.
     *
     * @param deckId deck identifier
     * @param flashcardId flashcard identifier
     * @return empty response
     */
    @Operation(summary = "Delete flashcard")
    @ApiResponses({
        @ApiResponse(responseCode = "204", description = "Flashcard deleted"),
        @ApiResponse(responseCode = "404", description = "Flashcard or deck not found")
    })
    @DeleteMapping("/{flashcardId}")
    public ResponseEntity<Void> deleteFlashcard(
        @PathVariable final Long deckId,
        @PathVariable final Long flashcardId
    ) {
        flashcardService.deleteFlashcard(deckId, flashcardId);
        return ResponseEntity.noContent().build();
    }
}



