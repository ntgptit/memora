package com.memora.app.entity;

import com.memora.app.entity.common.AuditableEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "review_profile_boxes", schema = "memora")
@NoArgsConstructor
public class ReviewProfileBoxEntity extends AuditableEntity {

    @Column(name = "review_profile_id", nullable = false)
    private Long reviewProfileId;

    @Column(name = "box_number", nullable = false)
    private Integer boxNumber;

    @Column(name = "interval_seconds", nullable = false)
    private Long intervalSeconds;

    @Column(name = "incorrect_box_number", nullable = false)
    private Integer incorrectBoxNumber;

    @Column(name = "correct_box_number", nullable = false)
    private Integer correctBoxNumber;
}
