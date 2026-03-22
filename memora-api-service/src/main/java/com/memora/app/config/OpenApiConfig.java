package com.memora.app.config;

import com.memora.app.properties.DocsProperties;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;

@Configuration
@EnableConfigurationProperties(DocsProperties.class)
public class OpenApiConfig {

    @Bean
    public OpenAPI memoraOpenApi(final DocsProperties docsProperties) {
        return new OpenAPI()
            .info(new Info()
                .title(docsProperties.title())
                .description(docsProperties.description())
                .version(docsProperties.version()));
    }
}
