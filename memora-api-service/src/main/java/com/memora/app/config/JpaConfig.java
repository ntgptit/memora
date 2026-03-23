package com.memora.app.config;

import java.time.Clock;
import java.time.OffsetDateTime;
import java.time.ZoneOffset;
import java.util.Optional;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.auditing.DateTimeProvider;
import org.springframework.data.jpa.repository.config.EnableJpaAuditing;

@Configuration
@EnableJpaAuditing(dateTimeProviderRef = "auditDateTimeProvider")
public class JpaConfig {

    @Bean
    Clock auditClock() {
        return Clock.system(ZoneOffset.UTC);
    }

    @Bean
    DateTimeProvider auditDateTimeProvider(final Clock auditClock) {
        return () -> Optional.of(OffsetDateTime.now(auditClock));
    }
}
