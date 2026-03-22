package com.memora.app.service;

import java.util.List;

import com.memora.app.dto.CreateReviewProfileRequest;
import com.memora.app.dto.ReviewProfileDto;
import com.memora.app.dto.UpdateReviewProfileRequest;

public interface ReviewProfileService {

    ReviewProfileDto createReviewProfile(CreateReviewProfileRequest request);

    ReviewProfileDto getReviewProfile(Long reviewProfileId);

    List<ReviewProfileDto> getReviewProfiles(Long ownerUserId, Boolean systemProfile);

    ReviewProfileDto updateReviewProfile(Long reviewProfileId, UpdateReviewProfileRequest request);

    void deleteReviewProfile(Long reviewProfileId);
}
