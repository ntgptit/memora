package com.memora.app.controller;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.when;

import java.util.List;

import com.memora.app.constant.ApiMessageKey;
import com.memora.app.dto.request.review_profile.CreateReviewProfileRequest;
import com.memora.app.dto.request.review_profile.UpdateReviewProfileRequest;
import com.memora.app.dto.response.review_profile.ReviewProfileResponse;
import com.memora.app.exception.BadRequestException;
import com.memora.app.exception.ConflictException;
import com.memora.app.exception.ResourceNotFoundException;
import com.memora.app.service.ReviewProfileService;
import com.memora.app.support.RecordFixtureFactory;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.HttpStatus;

@ExtendWith(MockitoExtension.class)
class ReviewProfileControllerTest {

    @Mock
    private ReviewProfileService reviewProfileService;

    @InjectMocks
    private ReviewProfileController reviewProfileController;

    @Test
    void createReviewProfileReturnsCreatedWhenServiceSucceeds() {
        final CreateReviewProfileRequest request = RecordFixtureFactory.createRecord(CreateReviewProfileRequest.class);
        final ReviewProfileResponse expectedResponse = RecordFixtureFactory.createRecord(ReviewProfileResponse.class);

        when(reviewProfileService.createReviewProfile(request)).thenReturn(expectedResponse);

        final var response = reviewProfileController.createReviewProfile(request);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void createReviewProfilePropagatesBadRequestScenario() {
        final CreateReviewProfileRequest request = RecordFixtureFactory.createRecord(CreateReviewProfileRequest.class);

        when(reviewProfileService.createReviewProfile(request))
            .thenThrow(new BadRequestException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> reviewProfileController.createReviewProfile(request))
            .isInstanceOf(BadRequestException.class);
    }

    @Test
    void createReviewProfilePropagatesNotFoundScenario() {
        final CreateReviewProfileRequest request = RecordFixtureFactory.createRecord(CreateReviewProfileRequest.class);

        when(reviewProfileService.createReviewProfile(request))
            .thenThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> reviewProfileController.createReviewProfile(request))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void createReviewProfilePropagatesConflictScenario() {
        final CreateReviewProfileRequest request = RecordFixtureFactory.createRecord(CreateReviewProfileRequest.class);

        when(reviewProfileService.createReviewProfile(request))
            .thenThrow(new ConflictException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> reviewProfileController.createReviewProfile(request))
            .isInstanceOf(ConflictException.class);
    }

    @Test
    void getReviewProfileReturnsOkWhenServiceSucceeds() {
        final ReviewProfileResponse expectedResponse = RecordFixtureFactory.createRecord(ReviewProfileResponse.class);

        when(reviewProfileService.getReviewProfile(1L)).thenReturn(expectedResponse);

        final var response = reviewProfileController.getReviewProfile(1L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void getReviewProfilePropagatesNotFoundScenario() {
        when(reviewProfileService.getReviewProfile(1L))
            .thenThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> reviewProfileController.getReviewProfile(1L))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void getReviewProfilesReturnsOkWhenServiceSucceeds() {
        final List<ReviewProfileResponse> expectedResponse = List.of(
            RecordFixtureFactory.createRecord(ReviewProfileResponse.class)
        );

        when(reviewProfileService.getReviewProfiles(1L, true)).thenReturn(expectedResponse);

        final var response = reviewProfileController.getReviewProfiles(1L, true);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void updateReviewProfileReturnsOkWhenServiceSucceeds() {
        final UpdateReviewProfileRequest request = RecordFixtureFactory.createRecord(UpdateReviewProfileRequest.class);
        final ReviewProfileResponse expectedResponse = RecordFixtureFactory.createRecord(ReviewProfileResponse.class);

        when(reviewProfileService.updateReviewProfile(1L, request)).thenReturn(expectedResponse);

        final var response = reviewProfileController.updateReviewProfile(1L, request);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isSameAs(expectedResponse);
    }

    @Test
    void updateReviewProfilePropagatesBadRequestScenario() {
        final UpdateReviewProfileRequest request = RecordFixtureFactory.createRecord(UpdateReviewProfileRequest.class);

        when(reviewProfileService.updateReviewProfile(1L, request))
            .thenThrow(new BadRequestException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> reviewProfileController.updateReviewProfile(1L, request))
            .isInstanceOf(BadRequestException.class);
    }

    @Test
    void updateReviewProfilePropagatesNotFoundScenario() {
        final UpdateReviewProfileRequest request = RecordFixtureFactory.createRecord(UpdateReviewProfileRequest.class);

        when(reviewProfileService.updateReviewProfile(1L, request))
            .thenThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> reviewProfileController.updateReviewProfile(1L, request))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void updateReviewProfilePropagatesConflictScenario() {
        final UpdateReviewProfileRequest request = RecordFixtureFactory.createRecord(UpdateReviewProfileRequest.class);

        when(reviewProfileService.updateReviewProfile(1L, request))
            .thenThrow(new ConflictException(ApiMessageKey.INTERNAL_ERROR));

        assertThatThrownBy(() -> reviewProfileController.updateReviewProfile(1L, request))
            .isInstanceOf(ConflictException.class);
    }

    @Test
    void deleteReviewProfileReturnsNoContentWhenServiceSucceeds() {
        final var response = reviewProfileController.deleteReviewProfile(1L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NO_CONTENT);
        assertThat(response.getBody()).isNull();
    }

    @Test
    void deleteReviewProfilePropagatesNotFoundScenario() {
        org.mockito.Mockito.doThrow(new ResourceNotFoundException(ApiMessageKey.INTERNAL_ERROR))
            .when(reviewProfileService)
            .deleteReviewProfile(1L);

        assertThatThrownBy(() -> reviewProfileController.deleteReviewProfile(1L))
            .isInstanceOf(ResourceNotFoundException.class);
    }

    @Test
    void deleteReviewProfilePropagatesConflictScenario() {
        org.mockito.Mockito.doThrow(new ConflictException(ApiMessageKey.INTERNAL_ERROR))
            .when(reviewProfileService)
            .deleteReviewProfile(1L);

        assertThatThrownBy(() -> reviewProfileController.deleteReviewProfile(1L))
            .isInstanceOf(ConflictException.class);
    }
}
