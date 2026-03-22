package com.memora.app.service.impl;

import java.util.List;
import java.util.Objects;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.CreateDeckReviewSettingsRequest;
import com.memora.app.dto.DeckReviewSettingsDto;
import com.memora.app.dto.UpdateDeckReviewSettingsRequest;
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

    @Override
    @Transactional
    public DeckReviewSettingsDto createDeckReviewSettings(final CreateDeckReviewSettingsRequest request) {
        final DeckEntity deck = getActiveDeck(request.deckId());

        if (deckReviewSettingsRepository.existsByDeckId(deck.getId())) {
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
        return DeckReviewSettingsMapper.toDto(deckReviewSettingsRepository.save(entity));
    }

    @Override
    @Transactional(readOnly = true)
    public DeckReviewSettingsDto getDeckReviewSettingsById(final Long deckReviewSettingsId) {
        return DeckReviewSettingsMapper.toDto(getDeckReviewSettingsEntity(deckReviewSettingsId));
    }

    @Override
    @Transactional(readOnly = true)
    public List<DeckReviewSettingsDto> getDeckReviewSettingsList(final Long deckId) {
        if (deckId != null) {
            return deckReviewSettingsRepository.findByDeckId(
                    ServiceValidationUtils.requirePositiveId(deckId, ApiMessageKey.DECK_ID_POSITIVE)
                )
                .stream()
                .map(DeckReviewSettingsMapper::toDto)
                .toList();
        }

        return deckReviewSettingsRepository.findAllByOrderByIdAsc()
            .stream()
            .map(DeckReviewSettingsMapper::toDto)
            .toList();
    }

    @Override
    @Transactional
    public DeckReviewSettingsDto updateDeckReviewSettings(
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
        return DeckReviewSettingsMapper.toDto(deckReviewSettingsRepository.save(entity));
    }

    @Override
    @Transactional
    public void deleteDeckReviewSettings(final Long deckReviewSettingsId) {
        final DeckReviewSettingsEntity entity = getDeckReviewSettingsEntity(deckReviewSettingsId);
        deckReviewSettingsRepository.removeById(entity.getId());
    }

    private DeckEntity getActiveDeck(final Long deckId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(deckId, ApiMessageKey.DECK_ID_POSITIVE);
        return deckRepository.findByIdAndDeletedAtIsNull(validatedId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.DECK_NOT_FOUND, validatedId));
    }

    private DeckReviewSettingsEntity getDeckReviewSettingsEntity(final Long deckReviewSettingsId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(
            deckReviewSettingsId,
            ApiMessageKey.DECK_REVIEW_SETTINGS_ID_POSITIVE
        );
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

        if (reviewProfile.isSystemProfile()) {
            return reviewProfile;
        }

        if (!Objects.equals(reviewProfile.getOwnerUserId(), deckUserId)) {
            throw new ConflictException(ApiMessageKey.DECK_REVIEW_SETTINGS_REVIEW_PROFILE_USER_MISMATCH);
        }
        return reviewProfile;
    }
}
