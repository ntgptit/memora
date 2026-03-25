package com.memora.app.service.impl;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

import java.util.List;

import com.memora.app.dto.response.review_profile_box.ReviewProfileBoxResponse;
import com.memora.app.entity.ReviewProfileBoxEntity;
import com.memora.app.mapper.ReviewProfileBoxMapper;
import com.memora.app.repository.ReviewProfileBoxRepository;
import com.memora.app.repository.ReviewProfileRepository;
import com.memora.app.support.RecordFixtureFactory;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Sort;

@ExtendWith(MockitoExtension.class)
class ReviewProfileBoxServiceImplTest {

    @Mock
    private ReviewProfileBoxRepository reviewProfileBoxRepository;

    @Mock
    private ReviewProfileRepository reviewProfileRepository;

    @Mock
    private ReviewProfileBoxMapper reviewProfileBoxMapper;

    @InjectMocks
    private ReviewProfileBoxServiceImpl reviewProfileBoxService;

    @Test
    void getReviewProfileBoxesReturnsProfileScopedRowsWhenReviewProfileIdProvided() {
        final ReviewProfileBoxEntity entity = new ReviewProfileBoxEntity();
        entity.setId(1L);
        entity.setReviewProfileId(10L);
        final ReviewProfileBoxResponse expectedResponse = RecordFixtureFactory.createRecord(
            ReviewProfileBoxResponse.class
        );

        when(reviewProfileBoxRepository.findAllByReviewProfileId(org.mockito.ArgumentMatchers.eq(10L), any(Sort.class)))
            .thenReturn(List.of(entity));
        when(reviewProfileBoxMapper.toDto(entity)).thenReturn(expectedResponse);

        final List<ReviewProfileBoxResponse> response = reviewProfileBoxService.getReviewProfileBoxes(10L);

        assertThat(response).containsExactly(expectedResponse);
    }
}
