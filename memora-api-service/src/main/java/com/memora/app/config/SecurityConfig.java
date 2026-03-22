package com.memora.app.config;

import java.util.List;

import com.memora.app.properties.CorsProperties;
import com.memora.app.properties.SecurityProperties;

import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

@Configuration
@EnableConfigurationProperties({CorsProperties.class, SecurityProperties.class})
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(
        final HttpSecurity http,
        final CorsConfigurationSource corsConfigurationSource,
        final SecurityProperties securityProperties
    ) throws Exception {
        http
            .csrf(AbstractHttpConfigurer::disable)
            .cors(cors -> cors.configurationSource(corsConfigurationSource))
            .httpBasic(AbstractHttpConfigurer::disable)
            .formLogin(AbstractHttpConfigurer::disable)
            .logout(AbstractHttpConfigurer::disable)
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
            .authorizeHttpRequests(authorize -> {
                authorize.requestMatchers(HttpMethod.OPTIONS, "/**").permitAll();

                final List<String> publicPaths = securityProperties.publicPaths().stream()
                    .filter(StringUtils::isNotBlank)
                    .toList();

                if (CollectionUtils.isNotEmpty(publicPaths)) {
                    authorize.requestMatchers(publicPaths.toArray(String[]::new)).permitAll();
                }

                authorize.anyRequest().authenticated();
            })
            .anonymous(Customizer.withDefaults());

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource(final CorsProperties corsProperties) {
        final CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowCredentials(corsProperties.allowCredentials());
        configuration.setAllowedOrigins(corsProperties.allowedOrigins());
        configuration.setAllowedOriginPatterns(corsProperties.allowedOriginPatterns());
        configuration.setAllowedMethods(corsProperties.allowedMethods());
        configuration.setAllowedHeaders(corsProperties.allowedHeaders());
        configuration.setExposedHeaders(corsProperties.exposedHeaders());
        configuration.setMaxAge(corsProperties.maxAgeSeconds());

        final UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
