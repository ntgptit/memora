package com.memora.app.controller;

import java.util.List;

import com.memora.app.dto.CreateFlashcardRequest;
import com.memora.app.dto.FlashcardDto;
import com.memora.app.dto.UpdateFlashcardRequest;
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
@RequestMapping("/api/v1/flashcards")
@RequiredArgsConstructor
public class FlashcardController {

    private final FlashcardService flashcardService;

    /**
     * Create a flashcard.
     *
     * @param request flashcard payload
     * @return created flashcard
     */
    @Operation(summary = "Create flashcard")
    @ApiResponses({
        @ApiResponse(responseCode = "201", description = "Flashcard created"),
        @ApiResponse(responseCode = "400", description = "Request is invalid"),
        @ApiResponse(responseCode = "404", description = "Deck not found")
    })
    @PostMapping
    public ResponseEntity<FlashcardDto> createFlashcard(
        @Valid @RequestBody final CreateFlashcardRequest request
    ) {
        return ResponseEntity.status(HttpStatus.CREATED).body(flashcardService.createFlashcard(request));
    }

    /**
     * Get a flashcard by id.
     *
     * @param flashcardId flashcard identifier
     * @return flashcard details
     */
    @Operation(summary = "Get flashcard by id")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Flashcard found"),
        @ApiResponse(responseCode = "404", description = "Flashcard not found")
    })
    @GetMapping("/{flashcardId}")
    public ResponseEntity<FlashcardDto> getFlashcard(@PathVariable final Long flashcardId) {
        return ResponseEntity.ok(flashcardService.getFlashcard(flashcardId));
    }

    /**
     * List flashcards.
     *
     * @param deckId optional deck filter
     * @return matching flashcards
     */
    @Operation(summary = "List flashcards")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Flashcards loaded")
    })
    @GetMapping
    public ResponseEntity<List<FlashcardDto>> getFlashcards(
        @RequestParam(required = false) final Long deckId
    ) {
        return ResponseEntity.ok(flashcardService.getFlashcards(deckId));
    }

    /**
     * Update a flashcard.
     *
     * @param flashcardId flashcard identifier
     * @param request updated flashcard payload
     * @return updated flashcard
     */
    @Operation(summary = "Update flashcard")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Flashcard updated"),
        @ApiResponse(responseCode = "400", description = "Request is invalid"),
        @ApiResponse(responseCode = "404", description = "Flashcard or deck not found")
    })
    @PutMapping("/{flashcardId}")
    public ResponseEntity<FlashcardDto> updateFlashcard(
        @PathVariable final Long flashcardId,
        @Valid @RequestBody final UpdateFlashcardRequest request
    ) {
        return ResponseEntity.ok(flashcardService.updateFlashcard(flashcardId, request));
    }

    /**
     * Soft delete a flashcard.
     *
     * @param flashcardId flashcard identifier
     * @return empty response
     */
    @Operation(summary = "Delete flashcard")
    @ApiResponses({
        @ApiResponse(responseCode = "204", description = "Flashcard deleted"),
        @ApiResponse(responseCode = "404", description = "Flashcard not found")
    })
    @DeleteMapping("/{flashcardId}")
    public ResponseEntity<Void> deleteFlashcard(@PathVariable final Long flashcardId) {
        flashcardService.deleteFlashcard(flashcardId);
        return ResponseEntity.noContent().build();
    }
}
