package com.memora.app.controller;

import java.util.List;

import com.memora.app.dto.CreateReviewProfileBoxRequest;
import com.memora.app.dto.ReviewProfileBoxDto;
import com.memora.app.dto.UpdateReviewProfileBoxRequest;
import com.memora.app.service.ReviewProfileBoxService;

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
 * REST endpoints for review profile box management.
 */
@Tag(name = "Review Profile Boxes", description = "CRUD APIs for review profile box transitions")
@RestController
@RequestMapping("/api/v1/review-profile-boxes")
@RequiredArgsConstructor
public class ReviewProfileBoxController {

    private final ReviewProfileBoxService reviewProfileBoxService;

    /**
     * Create a review profile box.
     *
     * @param request review profile box payload
     * @return created review profile box
     */
    @Operation(summary = "Create review profile box")
    @ApiResponses({
        @ApiResponse(responseCode = "201", description = "Review profile box created"),
        @ApiResponse(responseCode = "400", description = "Request is invalid"),
        @ApiResponse(responseCode = "404", description = "Review profile not found"),
        @ApiResponse(responseCode = "409", description = "System profile is immutable or box number already exists")
    })
    @PostMapping
    public ResponseEntity<ReviewProfileBoxDto> createReviewProfileBox(
        @Valid @RequestBody final CreateReviewProfileBoxRequest request
    ) {
        return ResponseEntity.status(HttpStatus.CREATED).body(reviewProfileBoxService.createReviewProfileBox(request));
    }

    /**
     * Get a review profile box by id.
     *
     * @param reviewProfileBoxId review profile box identifier
     * @return review profile box details
     */
    @Operation(summary = "Get review profile box by id")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Review profile box found"),
        @ApiResponse(responseCode = "404", description = "Review profile box not found")
    })
    @GetMapping("/{reviewProfileBoxId}")
    public ResponseEntity<ReviewProfileBoxDto> getReviewProfileBox(
        @PathVariable final Long reviewProfileBoxId
    ) {
        return ResponseEntity.ok(reviewProfileBoxService.getReviewProfileBox(reviewProfileBoxId));
    }

    /**
     * List review profile boxes.
     *
     * @param reviewProfileId optional review profile filter
     * @return matching review profile boxes
     */
    @Operation(summary = "List review profile boxes")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Review profile boxes loaded")
    })
    @GetMapping
    public ResponseEntity<List<ReviewProfileBoxDto>> getReviewProfileBoxes(
        @RequestParam(required = false) final Long reviewProfileId
    ) {
        return ResponseEntity.ok(reviewProfileBoxService.getReviewProfileBoxes(reviewProfileId));
    }

    /**
     * Update a review profile box.
     *
     * @param reviewProfileBoxId review profile box identifier
     * @param request updated review profile box payload
     * @return updated review profile box
     */
    @Operation(summary = "Update review profile box")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Review profile box updated"),
        @ApiResponse(responseCode = "400", description = "Request is invalid"),
        @ApiResponse(responseCode = "404", description = "Review profile box or profile not found"),
        @ApiResponse(responseCode = "409", description = "System profile is immutable or box number already exists")
    })
    @PutMapping("/{reviewProfileBoxId}")
    public ResponseEntity<ReviewProfileBoxDto> updateReviewProfileBox(
        @PathVariable final Long reviewProfileBoxId,
        @Valid @RequestBody final UpdateReviewProfileBoxRequest request
    ) {
        return ResponseEntity.ok(reviewProfileBoxService.updateReviewProfileBox(reviewProfileBoxId, request));
    }

    /**
     * Delete a review profile box.
     *
     * @param reviewProfileBoxId review profile box identifier
     * @return empty response
     */
    @Operation(summary = "Delete review profile box")
    @ApiResponses({
        @ApiResponse(responseCode = "204", description = "Review profile box deleted"),
        @ApiResponse(responseCode = "404", description = "Review profile box not found"),
        @ApiResponse(responseCode = "409", description = "System profile is immutable")
    })
    @DeleteMapping("/{reviewProfileBoxId}")
    public ResponseEntity<Void> deleteReviewProfileBox(@PathVariable final Long reviewProfileBoxId) {
        reviewProfileBoxService.deleteReviewProfileBox(reviewProfileBoxId);
        return ResponseEntity.noContent().build();
    }
}
