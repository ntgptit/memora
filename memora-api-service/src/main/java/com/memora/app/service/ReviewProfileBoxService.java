package com.memora.app.service;

import java.util.List;

import com.memora.app.dto.request.review_profile_box.CreateReviewProfileBoxRequest;
import com.memora.app.dto.response.review_profile_box.ReviewProfileBoxResponse;
import com.memora.app.dto.request.review_profile_box.UpdateReviewProfileBoxRequest;

public interface ReviewProfileBoxService {

    ReviewProfileBoxResponse createReviewProfileBox(CreateReviewProfileBoxRequest request);

    ReviewProfileBoxResponse getReviewProfileBox(Long reviewProfileBoxId);

    List<ReviewProfileBoxResponse> getReviewProfileBoxes(Long reviewProfileId);

    ReviewProfileBoxResponse updateReviewProfileBox(Long reviewProfileBoxId, UpdateReviewProfileBoxRequest request);

    void deleteReviewProfileBox(Long reviewProfileBoxId);
}



