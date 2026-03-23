package com.memora.app.config;

import com.memora.app.properties.DocsProperties;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityScheme;

@Configuration
@EnableConfigurationProperties(DocsProperties.class)
public class OpenApiConfig {

    @Bean
    OpenAPI memoraOpenApi(final DocsProperties docsProperties) {
        return new OpenAPI()
            .components(new Components().addSecuritySchemes(
                "bearerAuth",
                new SecurityScheme()
                    .type(SecurityScheme.Type.HTTP)
                    .scheme("bearer")
                    .bearerFormat("JWT")
            ))
            .info(new Info()
                .title(docsProperties.title())
                .description(docsProperties.description())
                .version(docsProperties.version()));
    }
}
