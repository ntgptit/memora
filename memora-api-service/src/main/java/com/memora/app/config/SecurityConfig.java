package com.memora.app.config;

import java.util.List;

import com.memora.app.properties.CorsProperties;
import com.memora.app.properties.SecurityProperties;
import com.memora.app.repository.UserAccountRepository;
import com.memora.app.security.AuthTokenAuthenticationFilter;
import com.memora.app.security.JwtAccessTokenService;
import com.memora.app.security.RestAccessDeniedHandler;
import com.memora.app.security.RestAuthenticationEntryPoint;

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
import org.springframework.security.web.authentication.AnonymousAuthenticationFilter;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

@Configuration
@EnableConfigurationProperties({CorsProperties.class, SecurityProperties.class})
public class SecurityConfig {

    @Bean
    SecurityFilterChain securityFilterChain(
        final HttpSecurity http,
        final CorsConfigurationSource corsConfigurationSource,
        final SecurityProperties securityProperties,
        final AuthTokenAuthenticationFilter authTokenAuthenticationFilter,
        final RestAuthenticationEntryPoint restAuthenticationEntryPoint,
        final RestAccessDeniedHandler restAccessDeniedHandler
    ) throws Exception {
        http
            .csrf(AbstractHttpConfigurer::disable)
            .cors(cors -> cors.configurationSource(corsConfigurationSource))
            .httpBasic(AbstractHttpConfigurer::disable)
            .formLogin(AbstractHttpConfigurer::disable)
            .logout(AbstractHttpConfigurer::disable)
            .exceptionHandling(exceptionHandling -> exceptionHandling
                .authenticationEntryPoint(restAuthenticationEntryPoint)
                .accessDeniedHandler(restAccessDeniedHandler)
            )
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
            .anonymous(Customizer.withDefaults())
            .addFilterBefore(authTokenAuthenticationFilter, AnonymousAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    AuthTokenAuthenticationFilter authTokenAuthenticationFilter(
        final JwtAccessTokenService jwtAccessTokenService,
        final UserAccountRepository userAccountRepository
    ) {
        return new AuthTokenAuthenticationFilter(jwtAccessTokenService, userAccountRepository);
    }

    @Bean
    CorsConfigurationSource corsConfigurationSource(final CorsProperties corsProperties) {
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
    PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}
