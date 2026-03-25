package com.memora.app.service.impl;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import java.util.Optional;

import com.memora.app.dto.request.review_profile.CreateReviewProfileRequest;
import com.memora.app.dto.response.review_profile.ReviewProfileResponse;
import com.memora.app.entity.ReviewProfileEntity;
import com.memora.app.entity.UserAccountEntity;
import com.memora.app.enums.review.ReviewAlgorithmType;
import com.memora.app.mapper.ReviewProfileMapper;
import com.memora.app.repository.ReviewProfileRepository;
import com.memora.app.repository.UserAccountRepository;
import com.memora.app.support.RecordFixtureFactory;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class)
class ReviewProfileServiceImplTest {

    @Mock
    private ReviewProfileRepository reviewProfileRepository;

    @Mock
    private UserAccountRepository userAccountRepository;

    @Mock
    private ReviewProfileMapper reviewProfileMapper;

    @InjectMocks
    private ReviewProfileServiceImpl reviewProfileService;

    @Test
    void createReviewProfileClearsExistingDefaultProfileWhenRequested() {
        final UserAccountEntity ownerUser = new UserAccountEntity();
        ownerUser.setId(10L);
        final ReviewProfileEntity existingDefaultProfile = new ReviewProfileEntity();
        existingDefaultProfile.setId(20L);
        existingDefaultProfile.setOwnerUserId(10L);
        existingDefaultProfile.setDefaultProfile(true);
        final ReviewProfileResponse expectedResponse = RecordFixtureFactory.createRecord(ReviewProfileResponse.class);

        when(userAccountRepository.findByIdAndDeletedAtIsNull(10L)).thenReturn(Optional.of(ownerUser));
        when(reviewProfileRepository.existsByOwnerUserIdAndNameIgnoreCase(10L, "Focus")).thenReturn(false);
        when(reviewProfileRepository.findByOwnerUserIdAndDefaultProfileTrue(10L)).thenReturn(Optional.of(existingDefaultProfile));
        when(reviewProfileRepository.save(any(ReviewProfileEntity.class))).thenAnswer(invocation -> invocation.getArgument(0));
        when(reviewProfileMapper.toDto(any(ReviewProfileEntity.class))).thenReturn(expectedResponse);

        final ReviewProfileResponse response = reviewProfileService.createReviewProfile(
            new CreateReviewProfileRequest(10L, "Focus", "Description", ReviewAlgorithmType.values()[0], true)
        );

        verify(reviewProfileRepository, times(2)).save(any(ReviewProfileEntity.class));
        assertThat(existingDefaultProfile.isDefaultProfile()).isFalse();
        assertThat(response).isSameAs(expectedResponse);
    }
}
