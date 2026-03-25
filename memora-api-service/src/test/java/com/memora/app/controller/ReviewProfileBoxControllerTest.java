package com.memora.app.controller;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

import java.util.List;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.request.review_profile_box.CreateReviewProfileBoxRequest;
import com.memora.app.dto.request.review_profile_box.UpdateReviewProfileBoxRequest;
import com.memora.app.dto.response.review_profile_box.ReviewProfileBoxResponse;
import com.memora.app.exception.BadRequestException;
import com.memora.app.exception.ConflictException;
import com.memora.app.exception.ResourceNotFoundException;
import com.memora.app.service.ReviewProfileBoxService;
import com.memora.app.support.RecordFixtureFactory;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;

@ExtendWith(MockitoExtension.class)
class ReviewProfileBoxControllerTest {

    @Mock
    private ReviewProfileBoxService reviewProfileBoxService;

    @InjectMocks
    private ReviewProfileBoxController reviewProfileBoxController;

    @Test
    void createReviewProfileBoxReturnsCreatedWhenServiceSucceeds() {
        final CreateReviewProfileBoxRequest request = RecordFixtureFactory.createRecord(
            CreateReviewProfileBoxRequest.class
        );
        final ReviewProfileBoxResponse expectedResponse = RecordFixtureFactory.createRecord(
            ReviewProfileBoxResponse.class
        );

        when(reviewProfileBoxService.createReviewProfileBox(request)).thenReturn(expectedResponse);

        final var response = reviewProfileBoxController.createReviewProfileBox(request);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void createReviewProfileBoxPropagatesBadRequestScenario() {
        final CreateReviewProfileBoxRequest request = RecordFixtureFactory.createRecord(
            CreateReviewProfileBoxRequest.class
        );

        when(reviewProfileBoxService.createReviewProfileBox(request))
            .thenThrow(new BadRequestException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> reviewProfileBoxController.createReviewProfileBox(request))
            .isInstanceOf(BadRequestException.class);
    }

    @Test
    void createReviewProfileBoxPropagatesNotFoundScenario() {
        final CreateReviewProfileBoxRequest request = RecordFixtureFactory.createRecord(
            CreateReviewProfileBoxRequest.class
        );

        when(reviewProfileBoxService.createReviewProfileBox(request))
            .thenThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> reviewProfileBoxController.createReviewProfileBox(request))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void createReviewProfileBoxPropagatesConflictScenario() {
        final CreateReviewProfileBoxRequest request = RecordFixtureFactory.createRecord(
            CreateReviewProfileBoxRequest.class
        );

        when(reviewProfileBoxService.createReviewProfileBox(request))
            .thenThrow(new ConflictException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> reviewProfileBoxController.createReviewProfileBox(request))
            .isInstanceOf(ConflictException.class);
    }

    @Test
    void getReviewProfileBoxReturnsOkWhenServiceSucceeds() {
        final ReviewProfileBoxResponse expectedResponse = RecordFixtureFactory.createRecord(
            ReviewProfileBoxResponse.class
        );

        when(reviewProfileBoxService.getReviewProfileBox(1L)).thenReturn(expectedResponse);

        final var response = reviewProfileBoxController.getReviewProfileBox(1L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void getReviewProfileBoxPropagatesNotFoundScenario() {
        when(reviewProfileBoxService.getReviewProfileBox(1L))
            .thenThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> reviewProfileBoxController.getReviewProfileBox(1L))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void getReviewProfileBoxesReturnsOkWhenServiceSucceeds() {
        final List<ReviewProfileBoxResponse> expectedResponse = List.of(
            RecordFixtureFactory.createRecord(ReviewProfileBoxResponse.class)
        );

        when(reviewProfileBoxService.getReviewProfileBoxes(1L)).thenReturn(expectedResponse);

        final var response = reviewProfileBoxController.getReviewProfileBoxes(1L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void updateReviewProfileBoxReturnsOkWhenServiceSucceeds() {
        final UpdateReviewProfileBoxRequest request = RecordFixtureFactory.createRecord(
            UpdateReviewProfileBoxRequest.class
        );
        final ReviewProfileBoxResponse expectedResponse = RecordFixtureFactory.createRecord(
            ReviewProfileBoxResponse.class
        );

        when(reviewProfileBoxService.updateReviewProfileBox(1L, request)).thenReturn(expectedResponse);

        final var response = reviewProfileBoxController.updateReviewProfileBox(1L, request);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void updateReviewProfileBoxPropagatesBadRequestScenario() {
        final UpdateReviewProfileBoxRequest request = RecordFixtureFactory.createRecord(
            UpdateReviewProfileBoxRequest.class
        );

        when(reviewProfileBoxService.updateReviewProfileBox(1L, request))
            .thenThrow(new BadRequestException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> reviewProfileBoxController.updateReviewProfileBox(1L, request))
            .isInstanceOf(BadRequestException.class);
    }

    @Test
    void updateReviewProfileBoxPropagatesNotFoundScenario() {
        final UpdateReviewProfileBoxRequest request = RecordFixtureFactory.createRecord(
            UpdateReviewProfileBoxRequest.class
        );

        when(reviewProfileBoxService.updateReviewProfileBox(1L, request))
            .thenThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> reviewProfileBoxController.updateReviewProfileBox(1L, request))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void updateReviewProfileBoxPropagatesConflictScenario() {
        final UpdateReviewProfileBoxRequest request = RecordFixtureFactory.createRecord(
            UpdateReviewProfileBoxRequest.class
        );

        when(reviewProfileBoxService.updateReviewProfileBox(1L, request))
            .thenThrow(new ConflictException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> reviewProfileBoxController.updateReviewProfileBox(1L, request))
            .isInstanceOf(ConflictException.class);
    }

    @Test
    void deleteReviewProfileBoxReturnsNoContentWhenServiceSucceeds() {
        final var response = reviewProfileBoxController.deleteReviewProfileBox(1L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NO_CONTENT);
        assertThat(response.getBody()).isNull();
    }

    @Test
    void deleteReviewProfileBoxPropagatesNotFoundScenario() {
        org.mockito.Mockito.doThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR))
            .when(reviewProfileBoxService)
            .deleteReviewProfileBox(1L);

        assertThatThrownBy(() -> reviewProfileBoxController.deleteReviewProfileBox(1L))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void deleteReviewProfileBoxPropagatesConflictScenario() {
        org.mockito.Mockito.doThrow(new ConflictException(ApiMessageKey.INTERNAL_ERROR))
            .when(reviewProfileBoxService)
            .deleteReviewProfileBox(1L);

        assertThatThrownBy(() -> reviewProfileBoxController.deleteReviewProfileBox(1L))
            .isInstanceOf(ConflictException.class);
    }
}
