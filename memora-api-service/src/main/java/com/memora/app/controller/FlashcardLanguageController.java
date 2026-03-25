package com.memora.app.controller;

import java.util.List;

import com.memora.app.dto.request.flashcard_language.CreateFlashcardLanguageRequest;
import com.memora.app.dto.response.flashcard_language.FlashcardLanguageResponse;
import com.memora.app.dto.request.flashcard_language.UpdateFlashcardLanguageRequest;
import com.memora.app.service.FlashcardLanguageService;

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
 * REST endpoints for flashcard language management.
 */
@Tag(name = "Flashcard Languages", description = "CRUD APIs for flashcard side language metadata")
@RestController
@RequestMapping("/api/v1/flashcard-languages")
@RequiredArgsConstructor
public class FlashcardLanguageController {

    private final FlashcardLanguageService flashcardLanguageService;

    /**
     * Create a flashcard language.
     *
     * @param request flashcard language payload
     * @return created flashcard language
     */
    @Operation(summary = "Create flashcard language")
    @ApiResponses({
        @ApiResponse(responseCode = "201", description = "Flashcard language created"),
        @ApiResponse(responseCode = "400", description = "Request is invalid"),
        @ApiResponse(responseCode = "404", description = "Flashcard not found"),
        @ApiResponse(responseCode = "409", description = "Flashcard side language already exists")
    })
    @PostMapping
    public ResponseEntity<FlashcardLanguageResponse> createFlashcardLanguage(
        @Valid @RequestBody final CreateFlashcardLanguageRequest request
    ) {
        return ResponseEntity.status(HttpStatus.CREATED).body(flashcardLanguageService.createFlashcardLanguage(request));
    }

    /**
     * Get a flashcard language by id.
     *
     * @param flashcardLanguageId flashcard language identifier
     * @return flashcard language details
     */
    @Operation(summary = "Get flashcard language by id")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Flashcard language found"),
        @ApiResponse(responseCode = "404", description = "Flashcard language not found")
    })
    @GetMapping("/{flashcardLanguageId}")
    public ResponseEntity<FlashcardLanguageResponse> getFlashcardLanguage(
        @PathVariable final Long flashcardLanguageId
    ) {
        return ResponseEntity.ok(flashcardLanguageService.getFlashcardLanguage(flashcardLanguageId));
    }

    /**
     * List flashcard languages.
     *
     * @param flashcardId optional flashcard filter
     * @return matching flashcard languages
     */
    @Operation(summary = "List flashcard languages")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Flashcard languages loaded")
    })
    @GetMapping
    public ResponseEntity<List<FlashcardLanguageResponse>> getFlashcardLanguages(
        @RequestParam(required = false) final Long flashcardId
    ) {
        return ResponseEntity.ok(flashcardLanguageService.getFlashcardLanguages(flashcardId));
    }

    /**
     * Update a flashcard language.
     *
     * @param flashcardLanguageId flashcard language identifier
     * @param request updated flashcard language payload
     * @return updated flashcard language
     */
    @Operation(summary = "Update flashcard language")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Flashcard language updated"),
        @ApiResponse(responseCode = "400", description = "Request is invalid"),
        @ApiResponse(responseCode = "404", description = "Flashcard language or flashcard not found"),
        @ApiResponse(responseCode = "409", description = "Flashcard side language already exists")
    })
    @PutMapping("/{flashcardLanguageId}")
    public ResponseEntity<FlashcardLanguageResponse> updateFlashcardLanguage(
        @PathVariable final Long flashcardLanguageId,
        @Valid @RequestBody final UpdateFlashcardLanguageRequest request
    ) {
        return ResponseEntity.ok(
            flashcardLanguageService.updateFlashcardLanguage(flashcardLanguageId, request)
        );
    }

    /**
     * Delete a flashcard language.
     *
     * @param flashcardLanguageId flashcard language identifier
     * @return empty response
     */
    @Operation(summary = "Delete flashcard language")
    @ApiResponses({
        @ApiResponse(responseCode = "204", description = "Flashcard language deleted"),
        @ApiResponse(responseCode = "404", description = "Flashcard language not found")
    })
    @DeleteMapping("/{flashcardLanguageId}")
    public ResponseEntity<Void> deleteFlashcardLanguage(@PathVariable final Long flashcardLanguageId) {
        flashcardLanguageService.deleteFlashcardLanguage(flashcardLanguageId);
        return ResponseEntity.noContent().build();
    }
}



