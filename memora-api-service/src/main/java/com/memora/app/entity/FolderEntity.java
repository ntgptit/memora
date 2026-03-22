package com.memora.app.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "folders", schema = "memora")
@NoArgsConstructor
public class FolderEntity extends SoftDeletableAuditableEntity {

    @Column(name = "user_id", nullable = false)
    private Long userId;

    @Column(name = "parent_id")
    private Long parentId;

    @Column(name = "name", nullable = false, length = 150)
    private String name;

    @Column(name = "description", nullable = false, length = 400)
    private String description;

    @Column(name = "depth", nullable = false)
    private Integer depth;
}
