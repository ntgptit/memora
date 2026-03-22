package com.memora.app.service.impl;

import java.util.List;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.CreateReviewProfileRequest;
import com.memora.app.dto.ReviewProfileDto;
import com.memora.app.dto.UpdateReviewProfileRequest;
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

    @Override
    @Transactional
    public ReviewProfileDto createReviewProfile(final CreateReviewProfileRequest request) {
        final UserAccountEntity ownerUser = getActiveUserAccount(request.ownerUserId());
        final String name = ServiceValidationUtils.normalizeRequiredText(request.name(), ApiMessageKey.NAME_REQUIRED);
        assertProfileNameAvailable(ownerUser.getId(), name, null);

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
        return ReviewProfileMapper.toDto(reviewProfileRepository.save(entity));
    }

    @Override
    @Transactional(readOnly = true)
    public ReviewProfileDto getReviewProfile(final Long reviewProfileId) {
        return ReviewProfileMapper.toDto(getReviewProfileEntity(reviewProfileId));
    }

    @Override
    @Transactional(readOnly = true)
    public List<ReviewProfileDto> getReviewProfiles(final Long ownerUserId, final Boolean systemProfile) {
        return reviewProfileRepository.findAllByOrderByIdAsc()
            .stream()
            .filter(reviewProfile -> ownerUserId == null || ownerUserId.equals(reviewProfile.getOwnerUserId()))
            .filter(reviewProfile -> systemProfile == null || systemProfile.equals(reviewProfile.isSystemProfile()))
            .map(ReviewProfileMapper::toDto)
            .toList();
    }

    @Override
    @Transactional
    public ReviewProfileDto updateReviewProfile(
        final Long reviewProfileId,
        final UpdateReviewProfileRequest request
    ) {
        final ReviewProfileEntity entity = getMutableReviewProfile(reviewProfileId);
        final String name = ServiceValidationUtils.normalizeRequiredText(request.name(), ApiMessageKey.NAME_REQUIRED);
        assertProfileNameAvailable(entity.getOwnerUserId(), name, entity.getId());

        if (request.defaultProfile()) {
            clearExistingDefaultProfile(entity.getOwnerUserId(), entity.getId());
        }

        entity.setName(name);
        entity.setDescription(ServiceValidationUtils.normalizeOptionalText(request.description()));
        entity.setAlgorithmType(request.algorithmType());
        entity.setDefaultProfile(request.defaultProfile());
        return ReviewProfileMapper.toDto(reviewProfileRepository.save(entity));
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
        return reviewProfileRepository.findById(validatedId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.REVIEW_PROFILE_NOT_FOUND, validatedId));
    }

    private ReviewProfileEntity getMutableReviewProfile(final Long reviewProfileId) {
        final ReviewProfileEntity entity = getReviewProfileEntity(reviewProfileId);

        if (entity.isSystemProfile()) {
            throw new ConflictException(ApiMessageKey.REVIEW_PROFILE_SYSTEM_LOCKED);
        }
        return entity;
    }

    private UserAccountEntity getActiveUserAccount(final Long userId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(userId, ApiMessageKey.OWNER_USER_ID_POSITIVE);
        return userAccountRepository.findByIdAndDeletedAtIsNull(validatedId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.USER_ACCOUNT_NOT_FOUND, validatedId));
    }

    private void assertProfileNameAvailable(final Long ownerUserId, final String name, final Long reviewProfileId) {
        final boolean alreadyExists = reviewProfileId == null
            ? reviewProfileRepository.existsByOwnerUserIdAndNameIgnoreCase(ownerUserId, name)
            : reviewProfileRepository.existsByOwnerUserIdAndNameIgnoreCaseAndIdNot(ownerUserId, name, reviewProfileId);

        if (alreadyExists) {
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
