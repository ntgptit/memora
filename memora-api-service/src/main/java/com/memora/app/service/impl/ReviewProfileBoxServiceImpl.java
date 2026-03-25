package com.memora.app.service.impl;

import java.util.List;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.request.review_profile_box.CreateReviewProfileBoxRequest;
import com.memora.app.dto.response.review_profile_box.ReviewProfileBoxResponse;
import com.memora.app.dto.request.review_profile_box.UpdateReviewProfileBoxRequest;
import com.memora.app.entity.ReviewProfileBoxEntity;
import com.memora.app.entity.ReviewProfileEntity;
import com.memora.app.exception.ConflictException;
import com.memora.app.exception.ResourceNotFoundException;
import com.memora.app.mapper.ReviewProfileBoxMapper;
import com.memora.app.repository.ReviewProfileBoxRepository;
import com.memora.app.repository.ReviewProfileRepository;
import com.memora.app.service.ReviewProfileBoxService;
import com.memora.app.util.ServiceValidationUtils;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReviewProfileBoxServiceImpl implements ReviewProfileBoxService {

    private final ReviewProfileBoxRepository reviewProfileBoxRepository;
    private final ReviewProfileRepository reviewProfileRepository;
    private final ReviewProfileBoxMapper reviewProfileBoxMapper;

    @Override
    @Transactional
    public ReviewProfileBoxResponse createReviewProfileBox(final CreateReviewProfileBoxRequest request) {
        final ReviewProfileEntity reviewProfile = getMutableReviewProfile(request.reviewProfileId());
        assertBoxNumberAvailable(reviewProfile.getId(), request.boxNumber(), null);

        final ReviewProfileBoxEntity entity = new ReviewProfileBoxEntity();
        entity.setReviewProfileId(reviewProfile.getId());
        entity.setBoxNumber(request.boxNumber());
        entity.setIntervalSeconds(request.intervalSeconds());
        entity.setIncorrectBoxNumber(request.incorrectBoxNumber());
        entity.setCorrectBoxNumber(request.correctBoxNumber());
        // Return the persisted review profile box rule.
        return reviewProfileBoxMapper.toDto(reviewProfileBoxRepository.save(entity));
    }

    @Override
    @Transactional(readOnly = true)
    public ReviewProfileBoxResponse getReviewProfileBox(final Long reviewProfileBoxId) {
        // Return the requested review profile box rule.
        return reviewProfileBoxMapper.toDto(getReviewProfileBoxEntity(reviewProfileBoxId));
    }

    @Override
    @Transactional(readOnly = true)
    public List<ReviewProfileBoxResponse> getReviewProfileBoxes(final Long reviewProfileId) {
        // Narrow the query when the caller requests boxes for one review profile.
        if (reviewProfileId != null) {
            // Return box rules that belong to the requested profile.
            return reviewProfileBoxRepository.findAllByReviewProfileIdOrderByBoxNumberAsc(
                    ServiceValidationUtils.requirePositiveId(reviewProfileId, ApiMessageKey.REVIEW_PROFILE_ID_POSITIVE)
                )
                // Convert persisted box rules into DTOs for the API layer.
                .stream()
                .map(reviewProfileBoxMapper::toDto)
                .toList();
        }

        // Return every box rule when no review profile filter is provided.
        return reviewProfileBoxRepository.findAllByOrderByIdAsc()
            // Convert persisted box rules into DTOs for the API layer.
            .stream()
            .map(reviewProfileBoxMapper::toDto)
            .toList();
    }

    @Override
    @Transactional
    public ReviewProfileBoxResponse updateReviewProfileBox(
        final Long reviewProfileBoxId,
        final UpdateReviewProfileBoxRequest request
    ) {
        final ReviewProfileBoxEntity entity = getReviewProfileBoxEntity(reviewProfileBoxId);
        final ReviewProfileEntity reviewProfile = getMutableReviewProfile(request.reviewProfileId());
        assertBoxNumberAvailable(reviewProfile.getId(), request.boxNumber(), entity.getId());

        entity.setReviewProfileId(reviewProfile.getId());
        entity.setBoxNumber(request.boxNumber());
        entity.setIntervalSeconds(request.intervalSeconds());
        entity.setIncorrectBoxNumber(request.incorrectBoxNumber());
        entity.setCorrectBoxNumber(request.correctBoxNumber());
        // Return the updated review profile box rule.
        return reviewProfileBoxMapper.toDto(reviewProfileBoxRepository.save(entity));
    }

    @Override
    @Transactional
    public void deleteReviewProfileBox(final Long reviewProfileBoxId) {
        final ReviewProfileBoxEntity entity = getReviewProfileBoxEntity(reviewProfileBoxId);
        getMutableReviewProfile(entity.getReviewProfileId());
        reviewProfileBoxRepository.removeById(entity.getId());
    }

    private ReviewProfileBoxEntity getReviewProfileBoxEntity(final Long reviewProfileBoxId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(
            reviewProfileBoxId,
            ApiMessageKey.REVIEW_PROFILE_BOX_ID_POSITIVE
        );
        // Return the persisted box rule or fail when it does not exist.
        return reviewProfileBoxRepository.findById(validatedId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.REVIEW_PROFILE_BOX_NOT_FOUND, validatedId));
    }

    private ReviewProfileEntity getMutableReviewProfile(final Long reviewProfileId) {
        final Long validatedId = ServiceValidationUtils.requirePositiveId(
            reviewProfileId,
            ApiMessageKey.REVIEW_PROFILE_ID_POSITIVE
        );
        final ReviewProfileEntity reviewProfile = reviewProfileRepository.findById(validatedId)
            .orElseThrow(() -> new ResourceNotFoundException(ApiMessageKey.REVIEW_PROFILE_NOT_FOUND, validatedId));

        // Prevent edits to system-managed default profiles.
        if (reviewProfile.isSystemProfile()) {
            // Stop mutations on shared system profile rules.
            throw new ConflictException(ApiMessageKey.REVIEW_PROFILE_BOX_SYSTEM_LOCKED);
        }
        // Return the mutable custom review profile.
        return reviewProfile;
    }

    private void assertBoxNumberAvailable(
        final Long reviewProfileId,
        final Integer boxNumber,
        final Long reviewProfileBoxId
    ) {
        final boolean alreadyExists = reviewProfileBoxId == null
            ? reviewProfileBoxRepository.existsByReviewProfileIdAndBoxNumber(reviewProfileId, boxNumber)
            : reviewProfileBoxRepository.existsByReviewProfileIdAndBoxNumberAndIdNot(
                reviewProfileId,
                boxNumber,
                reviewProfileBoxId
            );

        // Reject duplicate box numbers inside the same review profile.
        if (alreadyExists) {
            // Stop the write when the profile already defines this box number.
            throw new ConflictException(ApiMessageKey.REVIEW_PROFILE_BOX_NUMBER_EXISTS);
        }
    }
}



