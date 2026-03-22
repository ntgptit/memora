package com.memora.app.service;

import java.util.List;

import com.memora.app.dto.CreateReviewProfileBoxRequest;
import com.memora.app.dto.ReviewProfileBoxDto;
import com.memora.app.dto.UpdateReviewProfileBoxRequest;

public interface ReviewProfileBoxService {

    ReviewProfileBoxDto createReviewProfileBox(CreateReviewProfileBoxRequest request);

    ReviewProfileBoxDto getReviewProfileBox(Long reviewProfileBoxId);

    List<ReviewProfileBoxDto> getReviewProfileBoxes(Long reviewProfileId);

    ReviewProfileBoxDto updateReviewProfileBox(Long reviewProfileBoxId, UpdateReviewProfileBoxRequest request);

    void deleteReviewProfileBox(Long reviewProfileBoxId);
}
