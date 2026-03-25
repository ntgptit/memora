package com.memora.app.repository;

import java.util.List;
import java.util.Optional;

import com.memora.app.entity.ReviewProfileEntity;

import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ReviewProfileRepository extends JpaRepository<ReviewProfileEntity, Long> {

    Optional<ReviewProfileEntity> findById(Long reviewProfileId);

    List<ReviewProfileEntity> findAllByOwnerUserId(Long ownerUserId, Sort sort);

    List<ReviewProfileEntity> findAllBySystemProfile(boolean systemProfile, Sort sort);

    Optional<ReviewProfileEntity> findByOwnerUserIdAndDefaultProfileTrue(Long ownerUserId);

    boolean existsByOwnerUserIdAndNameIgnoreCase(Long ownerUserId, String name);

    boolean existsByOwnerUserIdAndNameIgnoreCaseAndIdNot(Long ownerUserId, String name, Long reviewProfileId);

    long removeById(Long reviewProfileId);
}
