package com.memora.app.repository;

import java.util.List;
import java.util.Optional;

import com.memora.app.entity.ReviewProfileBoxEntity;

import org.springframework.data.jpa.repository.JpaRepository;

public interface ReviewProfileBoxRepository extends JpaRepository<ReviewProfileBoxEntity, Long> {

    Optional<ReviewProfileBoxEntity> findById(Long reviewProfileBoxId);

    List<ReviewProfileBoxEntity> findAllByOrderByIdAsc();

    List<ReviewProfileBoxEntity> findAllByReviewProfileIdOrderByBoxNumberAsc(Long reviewProfileId);

    boolean existsByReviewProfileIdAndBoxNumber(Long reviewProfileId, Integer boxNumber);

    boolean existsByReviewProfileIdAndBoxNumberAndIdNot(Long reviewProfileId, Integer boxNumber, Long reviewProfileBoxId);

    long removeById(Long reviewProfileBoxId);
}
