package com.memora.app.service;

import java.util.List;

import com.memora.app.dto.request.review_profile.CreateReviewProfileRequest;
import com.memora.app.dto.response.review_profile.ReviewProfileResponse;
import com.memora.app.dto.request.review_profile.UpdateReviewProfileRequest;

public interface ReviewProfileService {

    ReviewProfileResponse createReviewProfile(CreateReviewProfileRequest request);

    ReviewProfileResponse getReviewProfile(Long reviewProfileId);

    List<ReviewProfileResponse> getReviewProfiles(Long ownerUserId, Boolean systemProfile);

    ReviewProfileResponse updateReviewProfile(Long reviewProfileId, UpdateReviewProfileRequest request);

    void deleteReviewProfile(Long reviewProfileId);
}



