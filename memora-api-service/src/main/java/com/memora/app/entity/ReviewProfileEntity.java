package com.memora.app.entity;

import com.memora.app.entity.common.AuditableEntity;
import com.memora.app.enums.review.ReviewAlgorithmType;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "review_profiles", schema = "memora")
@NoArgsConstructor
public class ReviewProfileEntity extends AuditableEntity {

    @Column(name = "owner_user_id")
    private Long ownerUserId;

    @Column(name = "name", nullable = false, length = 120)
    private String name;

    @Column(name = "description", nullable = false, length = 400)
    private String description;

    @Enumerated(EnumType.STRING)
    @Column(name = "algorithm_type", nullable = false, length = 20)
    private ReviewAlgorithmType algorithmType;

    @Column(name = "is_system", nullable = false)
    private boolean systemProfile;

    @Column(name = "is_default", nullable = false)
    private boolean defaultProfile;
}
