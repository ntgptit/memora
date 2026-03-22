package com.memora.app.controller;

import java.util.List;

import com.memora.app.dto.CreateReviewProfileRequest;
import com.memora.app.dto.ReviewProfileDto;
import com.memora.app.dto.UpdateReviewProfileRequest;
import com.memora.app.service.ReviewProfileService;

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
 * REST endpoints for review profile management.
 */
@Tag(name = "Review Profiles", description = "CRUD APIs for review profile configuration")
@RestController
@RequestMapping("/api/v1/review-profiles")
@RequiredArgsConstructor
public class ReviewProfileController {

    private final ReviewProfileService reviewProfileService;

    /**
     * Create a review profile.
     *
     * @param request review profile payload
     * @return created review profile
     */
    @Operation(summary = "Create review profile")
    @ApiResponses({
        @ApiResponse(responseCode = "201", description = "Review profile created"),
        @ApiResponse(responseCode = "400", description = "Request is invalid"),
        @ApiResponse(responseCode = "404", description = "Owner user not found"),
        @ApiResponse(responseCode = "409", description = "Review profile name already exists")
    })
    @PostMapping
    public ResponseEntity<ReviewProfileDto> createReviewProfile(
        @Valid @RequestBody final CreateReviewProfileRequest request
    ) {
        return ResponseEntity.status(HttpStatus.CREATED).body(reviewProfileService.createReviewProfile(request));
    }

    /**
     * Get a review profile by id.
     *
     * @param reviewProfileId review profile identifier
     * @return review profile details
     */
    @Operation(summary = "Get review profile by id")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Review profile found"),
        @ApiResponse(responseCode = "404", description = "Review profile not found")
    })
    @GetMapping("/{reviewProfileId}")
    public ResponseEntity<ReviewProfileDto> getReviewProfile(@PathVariable final Long reviewProfileId) {
        return ResponseEntity.ok(reviewProfileService.getReviewProfile(reviewProfileId));
    }

    /**
     * List review profiles.
     *
     * @param ownerUserId optional owner filter
     * @param systemProfile optional system-profile filter
     * @return matching review profiles
     */
    @Operation(summary = "List review profiles")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Review profiles loaded")
    })
    @GetMapping
    public ResponseEntity<List<ReviewProfileDto>> getReviewProfiles(
        @RequestParam(required = false) final Long ownerUserId,
        @RequestParam(required = false) final Boolean systemProfile
    ) {
        return ResponseEntity.ok(reviewProfileService.getReviewProfiles(ownerUserId, systemProfile));
    }

    /**
     * Update a review profile.
     *
     * @param reviewProfileId review profile identifier
     * @param request updated review profile payload
     * @return updated review profile
     */
    @Operation(summary = "Update review profile")
    @ApiResponses({
        @ApiResponse(responseCode = "200", description = "Review profile updated"),
        @ApiResponse(responseCode = "400", description = "Request is invalid"),
        @ApiResponse(responseCode = "404", description = "Review profile not found"),
        @ApiResponse(responseCode = "409", description = "System profile cannot be changed or name already exists")
    })
    @PutMapping("/{reviewProfileId}")
    public ResponseEntity<ReviewProfileDto> updateReviewProfile(
        @PathVariable final Long reviewProfileId,
        @Valid @RequestBody final UpdateReviewProfileRequest request
    ) {
        return ResponseEntity.ok(reviewProfileService.updateReviewProfile(reviewProfileId, request));
    }

    /**
     * Delete a review profile.
     *
     * @param reviewProfileId review profile identifier
     * @return empty response
     */
    @Operation(summary = "Delete review profile")
    @ApiResponses({
        @ApiResponse(responseCode = "204", description = "Review profile deleted"),
        @ApiResponse(responseCode = "404", description = "Review profile not found"),
        @ApiResponse(responseCode = "409", description = "System profile cannot be deleted")
    })
    @DeleteMapping("/{reviewProfileId}")
    public ResponseEntity<Void> deleteReviewProfile(@PathVariable final Long reviewProfileId) {
        reviewProfileService.deleteReviewProfile(reviewProfileId);
        return ResponseEntity.noContent().build();
    }
}
