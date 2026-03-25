package com.memora.app.service.impl;

import java.util.List;
import java.util.Objects;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.request.deck_review_settings.CreateDeckReviewSettingsRequest;
import com.memora.app.dto.response.deck_review_settings.DeckReviewSettingsResponse;
import com.memora.app.dto.request.deck_review_settings.UpdateDeckReviewSettingsRequest;
import com.memora.app.entity.DeckEntity;
import com.memora.app.entity.DeckReviewSettingsEntity;
import com.memora.app.entity.ReviewProfileEntity;
import com.memora.app.exception.ConflictException;
import com.memora.app.exception.ResourceNotFoundException;
import com.memora.app.mapper.DeckReviewSettingsMapper;
import com.memora.app.repository.DeckRepository;
import com.memora.app.repository.DeckReviewSettingsRepository;
import com.memora.app.repository.ReviewProfileRepository;
import com.memora.app.service.DeckReviewSettingsService;
import com.memora.app.util.ServiceValidationUtils;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DeckReviewSettingsServiceImpl implements DeckReviewSettingsService {

    private final DeckRepository deckRepository;
    private final DeckReviewSettingsRepository deckReviewSettingsRepository;
    private final ReviewProfileRepository reviewProfileRepository;
    private final DeckReviewSettingsMapper deckReviewSettingsMapper;

    @Override
    @Transactional
    public DeckReviewSettingsResponse createDeckReviewSettings(final CreateDeckReviewSettingsRequest request) {
        final DeckEntity deck = getActiveDeck(request.deckId());

        // Reject duplicate review settings for the same deck.
        if (deckReviewSettingsRepository.existsByDeckId(deck.getId())) {
            // Stop the request when the deck already has one settings row.
            throw new ConflictException(ApiMessageKey.DECK_REVIEW_SETTINGS_EXISTS);
        }

        final ReviewProfileEntity reviewProfile = getAccessibleReviewProfile(deck.getUserId(), request.reviewProfileId());
        final DeckReviewSettingsEntity entity = new DeckReviewSettingsEntity();
        entity.setDeckId(deck.getId());
        entity.setReviewProfileId(reviewProfile.getId());
        entity.setNewCardsPerDay(request.newCardsPerDay());
        entity.setReviewsPerDay(request.reviewsPerDay());
        entity.setBurySiblings(request.burySiblings());
        entity.setLeechThreshold(request.leechThreshold());
        entity.setSuspendLeechCards(request.suspendLeechCards());
        // Return the persisted deck review settings.
        return deckReviewSettingsMapper.toDto(deckReviewSettingsRepository.save(entity));
    }

    @Override
    @Transactional(readOnly = true)
    public DeckReviewSettingsResponse getDeckReviewSettingsById(final Long deckReviewSettingsId) {
        // Return the requested deck review settings record.
        return deckReviewSettingsMapper.toDto(getDeckReviewSettingsEntity(deckReviewSettingsId));
    }

    @Override
    @Transactional(readOnly = true)
    public List<DeckReviewSettingsResponse> getDeckReviewSettingsList(final Long deckId) {
        // Narrow the result set when the caller requests one deck explicitly.
        if (deckId != null) {
            // Return only the requested deck settings.
            return deckReviewSettingsRepository.findByDeckId(
                    ServiceValidationUtils.requirePositiveId(deckId, ApiMessageKey.DECK_ID_POSITIVE)
                )
                // Convert persisted settings rows into DTOs for the API contract.
                .stream()
                .map(deckReviewSettingsMapper::toDto)
                .toList();
        }

        // Return every deck settings row when no deck filter is provided.
        return deckReviewSettingsRepository.findAllByOrderByIdAsc()
            // Convert persisted settings rows into DTOs for the API contract.
            .stream()
            .map(deckReviewSettingsMapper::toDto)
            .toList();
    }

    @Override
    @Transactional
    public DeckReviewSettingsResponse updateDeckReviewSettings(
        final Long deckReviewSettingsId,
        final UpdateDeckReviewSettingsRequest request
    ) {
        final DeckReviewSettingsEntity entity = getDeckReviewSettingsEntity(deckReviewSettingsId);
        final DeckEntity deck = getActiveDeck(entity.getDeckId());
        final ReviewProfileEntity reviewProfile = getAccessibleReviewProfile(deck.getUserId(), request.reviewProfileId());

        entity.setReviewProfileId(reviewProfile.getId());
        entity.setNewCardsPerDay(request.newCardsPerDay());
        entity.setReviewsPerDay(request.reviewsPerDay());
        entity.setBurySiblings(request.burySiblings());
        entity.setLeechThreshold(request.leechThreshold());
        entity.setSuspendLeechCards(request.suspendLeechCards());
        // Return the updated deck review settings.
        return deckReviewSettingsMapper.toDto(deckReviewSettingsRepository.save(entity));
    }

    @Override
    @Transactional
    public void deleteDeckReviewSettings(final Long deckReviewSettingsId) {
        final DeckReviewSettingsEntity entity = getDeckReviewSettingsEntity(deckReviewSettingsId);
        deckReviewSettingsRepository.removeById(entity.getId());
    }

    private DeckEntity getActiveDeck(final Long deckId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(deckId, ApiMessageKey.DECK_ID_POSITIVE);
        // Return the active deck that owns the review settings.
        return deckRepository.findByIdAndDeletedAtIsNull(validatedId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.DECK_NOT_FOUND, validatedId));
    }

    private DeckReviewSettingsEntity getDeckReviewSettingsEntity(final Long deckReviewSettingsId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(
            deckReviewSettingsId,
            ApiMessageKey.DECK_REVIEW_SETTINGS_ID_POSITIVE
        );
        // Return the persisted settings row or fail when it does not exist.
        return deckReviewSettingsRepository.findById(validatedId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.DECK_REVIEW_SETTINGS_NOT_FOUND, validatedId));
    }

    private ReviewProfileEntity getAccessibleReviewProfile(final Long deckUserId, final Long reviewProfileId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(
            reviewProfileId,
            ApiMessageKey.REVIEW_PROFILE_ID_POSITIVE
        );
        final ReviewProfileEntity reviewProfile = reviewProfileRepository.findById(validatedId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.REVIEW_PROFILE_NOT_FOUND, validatedId));

        // Allow system-level profiles to be reused across users.
        if (reviewProfile.isSystemProfile()) {
            // Return the shared system profile unchanged.
            return reviewProfile;
        }

        // Reject custom profiles that belong to another user.
        if (!Objects.equals(reviewProfile.getOwnerUserId(), deckUserId)) {
            // Stop cross-user profile assignment for the deck.
            throw new ConflictException(ApiMessageKey.DECK_REVIEW_SETTINGS_REVIEW_PROFILE_USER_MISMATCH);
        }
        // Return the user-owned review profile after the ownership check passes.
        return reviewProfile;
    }
}



