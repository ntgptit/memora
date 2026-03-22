package com.memora.app.service.impl;

import java.util.List;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.CreateReviewProfileBoxRequest;
import com.memora.app.dto.ReviewProfileBoxDto;
import com.memora.app.dto.UpdateReviewProfileBoxRequest;
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

    @Override
    @Transactional
    public ReviewProfileBoxDto createReviewProfileBox(final CreateReviewProfileBoxRequest request) {
        final ReviewProfileEntity reviewProfile = getMutableReviewProfile(request.reviewProfileId());
        assertBoxNumberAvailable(reviewProfile.getId(), request.boxNumber(), null);

        final ReviewProfileBoxEntity entity = new ReviewProfileBoxEntity();
        entity.setReviewProfileId(reviewProfile.getId());
        entity.setBoxNumber(request.boxNumber());
        entity.setIntervalSeconds(request.intervalSeconds());
        entity.setIncorrectBoxNumber(request.incorrectBoxNumber());
        entity.setCorrectBoxNumber(request.correctBoxNumber());
        return ReviewProfileBoxMapper.toDto(reviewProfileBoxRepository.save(entity));
    }

    @Override
    @Transactional(readOnly = true)
    public ReviewProfileBoxDto getReviewProfileBox(final Long reviewProfileBoxId) {
        return ReviewProfileBoxMapper.toDto(getReviewProfileBoxEntity(reviewProfileBoxId));
    }

    @Override
    @Transactional(readOnly = true)
    public List<ReviewProfileBoxDto> getReviewProfileBoxes(final Long reviewProfileId) {
        if (reviewProfileId != null) {
            return reviewProfileBoxRepository.findAllByReviewProfileIdOrderByBoxNumberAsc(
                    ServiceValidationUtils.requirePositiveId(reviewProfileId, ApiMessageKey.REVIEW_PROFILE_ID_POSITIVE)
                )
                .stream()
                .map(ReviewProfileBoxMapper::toDto)
                .toList();
        }

        return reviewProfileBoxRepository.findAllByOrderByIdAsc()
            .stream()
            .map(ReviewProfileBoxMapper::toDto)
            .toList();
    }

    @Override
    @Transactional
    public ReviewProfileBoxDto updateReviewProfileBox(
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
        return ReviewProfileBoxMapper.toDto(reviewProfileBoxRepository.save(entity));
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

        if (reviewProfile.isSystemProfile()) {
            throw new ConflictException(ApiMessageKey.REVIEW_PROFILE_BOX_SYSTEM_LOCKED);
        }
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

        if (alreadyExists) {
            throw new ConflictException(ApiMessageKey.REVIEW_PROFILE_BOX_NUMBER_EXISTS);
        }
    }
}
