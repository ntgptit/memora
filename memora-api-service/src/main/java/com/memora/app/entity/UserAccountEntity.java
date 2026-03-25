package com.memora.app.entity;

import com.memora.app.entity.common.SoftDeletableAuditableEntity;
import com.memora.app.enums.user_account.AccountStatus;

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
@Table(name = "user_accounts", schema = "memora")
@NoArgsConstructor
public class UserAccountEntity extends SoftDeletableAuditableEntity {

    @Column(name = "username", nullable = false, length = 40)
    private String username;

    @Column(name = "email", nullable = false, length = 120)
    private String email;

    @Column(name = "password_hash", nullable = false, length = 240)
    private String passwordHash;

    @Enumerated(EnumType.STRING)
    @Column(name = "account_status", nullable = false, length = 20)
    private AccountStatus accountStatus;
}
