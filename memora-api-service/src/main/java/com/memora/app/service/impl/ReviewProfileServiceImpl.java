package com.memora.app.service.impl;

import java.util.List;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.request.review_profile.CreateReviewProfileRequest;
import com.memora.app.dto.response.review_profile.ReviewProfileResponse;
import com.memora.app.dto.request.review_profile.UpdateReviewProfileRequest;
import com.memora.app.entity.ReviewProfileEntity;
import com.memora.app.entity.UserAccountEntity;
import com.memora.app.exception.ConflictException;
import com.memora.app.exception.ResourceNotFoundException;
import com.memora.app.mapper.ReviewProfileMapper;
import com.memora.app.repository.ReviewProfileRepository;
import com.memora.app.repository.UserAccountRepository;
import com.memora.app.service.ReviewProfileService;
import com.memora.app.util.ServiceValidationUtils;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReviewProfileServiceImpl implements ReviewProfileService {

    private final ReviewProfileRepository reviewProfileRepository;
    private final UserAccountRepository userAccountRepository;
    private final ReviewProfileMapper reviewProfileMapper;

    @Override
    @Transactional
    public ReviewProfileResponse createReviewProfile(final CreateReviewProfileRequest request) {
        final UserAccountEntity ownerUser = getActiveUserAccount(request.ownerUserId());
        final String name = ServiceValidationUtils.normalizeRequiredText(request.name(), ApiMessageKey.NAME_REQUIRED);
        assertProfileNameAvailable(ownerUser.getId(), name, null);

        // Clear any existing default profile before promoting the new one.
        if (request.defaultProfile()) {
            clearExistingDefaultProfile(ownerUser.getId(), null);
        }

        final ReviewProfileEntity entity = new ReviewProfileEntity();
        entity.setOwnerUserId(ownerUser.getId());
        entity.setName(name);
        entity.setDescription(ServiceValidationUtils.normalizeOptionalText(request.description()));
        entity.setAlgorithmType(request.algorithmType());
        entity.setSystemProfile(false);
        entity.setDefaultProfile(request.defaultProfile());
        // Return the persisted custom review profile.
        return reviewProfileMapper.toDto(reviewProfileRepository.save(entity));
    }

    @Override
    @Transactional(readOnly = true)
    public ReviewProfileResponse getReviewProfile(final Long reviewProfileId) {
        // Return the requested review profile.
        return reviewProfileMapper.toDto(getReviewProfileEntity(reviewProfileId));
    }

    @Override
    @Transactional(readOnly = true)
    public List<ReviewProfileResponse> getReviewProfiles(final Long ownerUserId, final Boolean systemProfile) {
        // Return review profiles after applying optional owner and system filters in memory.
        return reviewProfileRepository.findAllByOrderByIdAsc()
            // Convert persisted profiles into DTOs after the filter chain completes.
            .stream()
            .filter(reviewProfile -> ownerUserId == null || ownerUserId.equals(reviewProfile.getOwnerUserId()))
            .filter(reviewProfile -> systemProfile == null || systemProfile.equals(reviewProfile.isSystemProfile()))
            .map(reviewProfileMapper::toDto)
            .toList();
    }

    @Override
    @Transactional
    public ReviewProfileResponse updateReviewProfile(
        final Long reviewProfileId,
        final UpdateReviewProfileRequest request
    ) {
        final ReviewProfileEntity entity = getMutableReviewProfile(reviewProfileId);
        final String name = ServiceValidationUtils.normalizeRequiredText(request.name(), ApiMessageKey.NAME_REQUIRED);
        assertProfileNameAvailable(entity.getOwnerUserId(), name, entity.getId());

        // Clear any other default profile before promoting this profile.
        if (request.defaultProfile()) {
            clearExistingDefaultProfile(entity.getOwnerUserId(), entity.getId());
        }

        entity.setName(name);
        entity.setDescription(ServiceValidationUtils.normalizeOptionalText(request.description()));
        entity.setAlgorithmType(request.algorithmType());
        entity.setDefaultProfile(request.defaultProfile());
        // Return the updated custom review profile.
        return reviewProfileMapper.toDto(reviewProfileRepository.save(entity));
    }

    @Override
    @Transactional
    public void deleteReviewProfile(final Long reviewProfileId) {
        final ReviewProfileEntity entity = getMutableReviewProfile(reviewProfileId);
        reviewProfileRepository.removeById(entity.getId());
    }

    private ReviewProfileEntity getReviewProfileEntity(final Long reviewProfileId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(
            reviewProfileId,
            ApiMessageKey.REVIEW_PROFILE_ID_POSITIVE
        );
        // Return the persisted review profile or fail when it does not exist.
        return reviewProfileRepository.findById(validatedId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.REVIEW_PROFILE_NOT_FOUND, validatedId));
    }

    private ReviewProfileEntity getMutableReviewProfile(final Long reviewProfileId) {
        final ReviewProfileEntity entity = getReviewProfileEntity(reviewProfileId);

        // Prevent edits and deletes against system-managed profiles.
        if (entity.isSystemProfile()) {
            // Stop mutations on the shared system profile.
            throw new ConflictException(ApiMessageKey.REVIEW_PROFILE_SYSTEM_LOCKED);
        }
        // Return the mutable custom review profile.
        return entity;
    }

    private UserAccountEntity getActiveUserAccount(final Long userId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(userId, ApiMessageKey.OWNER_USER_ID_POSITIVE);
        // Return the active owner that will receive the custom review profile.
        return userAccountRepository.findByIdAndDeletedAtIsNull(validatedId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.USER_ACCOUNT_NOT_FOUND, validatedId));
    }

    private void assertProfileNameAvailable(final Long ownerUserId, final String name, final Long reviewProfileId) {
        final boolean alreadyExists = reviewProfileId == null
            ? reviewProfileRepository.existsByOwnerUserIdAndNameIgnoreCase(ownerUserId, name)
            : reviewProfileRepository.existsByOwnerUserIdAndNameIgnoreCaseAndIdNot(ownerUserId, name, reviewProfileId);

        // Reject duplicate review profile names for the same owner.
        if (alreadyExists) {
            // Stop the write when another profile already uses the same name.
            throw new ConflictException(ApiMessageKey.REVIEW_PROFILE_NAME_EXISTS);
        }
    }

    private void clearExistingDefaultProfile(final Long ownerUserId, final Long currentReviewProfileId) {
        reviewProfileRepository.findByOwnerUserIdAndDefaultProfileTrue(ownerUserId)
            .filter(existingProfile -> !existingProfile.getId().equals(currentReviewProfileId))
            .ifPresent(existingProfile -> {
                existingProfile.setDefaultProfile(false);
                reviewProfileRepository.save(existingProfile);
            });
    }
}



