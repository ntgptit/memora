package com.memora.app.controller;

import java.util.List;

import com.memora.app.dto.request.deck_review_settings.CreateDeckReviewSettingsRequest;
import com.memora.app.dto.response.deck_review_settings.DeckReviewSettingsResponse;
import com.memora.app.dto.request.deck_review_settings.UpdateDeckReviewSettingsRequest;
import com.memora.app.service.DeckReviewSettingsService;

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
 * REST endpoints for deck review settings management.
 */
@Tag(name = "Deck Review Settings", description = "CRUD APIs for deck-specific review settings")
@RestController
@RequestMapping("/api/v1/deck-review-settings")
@RequiredArgsConstructor
public class DeckReviewSettingsController {

    private final DeckReviewSettingsService deckReviewSettingsService;

    /**
     * Create deck review settings.
     *
     * @param request deck review settings payload
     * @return created deck review settings
     */
    @Operation(summary = "Create deck review settings")
    @ApiResponses({
        @ApiResponse(responseCode = "201", description = "Deck review settings created"),
        @ApiResponse(responseCode = "400", description = "Request is invalid"),
        @ApiResponse(responseCode = "404", description = "Deck or review profile not found"),
        @ApiResponse(responseCode = "409", description = "Deck review settings already exist or profile is not accessible")
    })
    @PostMapping
    public ResponseEntity<DeckReviewSettingsResponse> createDeckReviewSettings(
        @Valid @RequestBody final CreateDeckReviewSettingsRequest request
    ) {
        return ResponseEntity.status(HttpStatus.CREATED).body(
            deckReviewSettingsService.createDeckReviewSettings(request)
        );
    }

    /**
     * Get deck review settings by id.
     *
     * @param deckReviewSettingsId deck review settings identifier
     * @return deck review settings details
     */
    @Operation(summary = "Get deck review settings by id")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Deck review settings found"),
        @ApiResponse(responseCode = "404", description = "Deck review settings not found")
    })
    @GetMapping("/{deckReviewSettingsId}")
    public ResponseEntity<DeckReviewSettingsResponse> getDeckReviewSettingsById(
        @PathVariable final Long deckReviewSettingsId
    ) {
        return ResponseEntity.ok(deckReviewSettingsService.getDeckReviewSettingsById(deckReviewSettingsId));
    }

    /**
     * List deck review settings.
     *
     * @param deckId optional deck filter
     * @return matching deck review settings
     */
    @Operation(summary = "List deck review settings")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Deck review settings loaded")
    })
    @GetMapping
    public ResponseEntity<List<DeckReviewSettingsResponse>> getDeckReviewSettingsList(
        @RequestParam(required = false) final Long deckId
    ) {
        return ResponseEntity.ok(deckReviewSettingsService.getDeckReviewSettingsList(deckId));
    }

    /**
     * Update deck review settings.
     *
     * @param deckReviewSettingsId deck review settings identifier
     * @param request updated deck review settings payload
     * @return updated deck review settings
     */
    @Operation(summary = "Update deck review settings")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Deck review settings updated"),
        @ApiResponse(responseCode = "400", description = "Request is invalid"),
        @ApiResponse(responseCode = "404", description = "Deck review settings or review profile not found"),
        @ApiResponse(responseCode = "409", description = "Review profile is not accessible for the selected deck")
    })
    @PutMapping("/{deckReviewSettingsId}")
    public ResponseEntity<DeckReviewSettingsResponse> updateDeckReviewSettings(
        @PathVariable final Long deckReviewSettingsId,
        @Valid @RequestBody final UpdateDeckReviewSettingsRequest request
    ) {
        return ResponseEntity.ok(
            deckReviewSettingsService.updateDeckReviewSettings(deckReviewSettingsId, request)
        );
    }

    /**
     * Delete deck review settings.
     *
     * @param deckReviewSettingsId deck review settings identifier
     * @return empty response
     */
    @Operation(summary = "Delete deck review settings")
    @ApiResponses({
        @ApiResponse(responseCode = "204", description = "Deck review settings deleted"),
        @ApiResponse(responseCode = "404", description = "Deck review settings not found")
    })
    @DeleteMapping("/{deckReviewSettingsId}")
    public ResponseEntity<Void> deleteDeckReviewSettings(@PathVariable final Long deckReviewSettingsId) {
        deckReviewSettingsService.deleteDeckReviewSettings(deckReviewSettingsId);
        return ResponseEntity.noContent().build();
    }
}



