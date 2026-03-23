package com.memora.app.repository;

import java.util.Optional;

import com.memora.app.entity.RefreshTokenEntity;

import org.springframework.data.jpa.repository.JpaRepository;

public interface RefreshTokenRepository extends JpaRepository<RefreshTokenEntity, Long> {

    Optional<RefreshTokenEntity> findByTokenHash(String tokenHash);
}
