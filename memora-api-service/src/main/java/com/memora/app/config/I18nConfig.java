package com.memora.app.config;

import com.memora.app.properties.I18nProperties;

import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.i18n.AcceptHeaderLocaleResolver;

@Configuration
@EnableConfigurationProperties(I18nProperties.class)
public class I18nConfig {

    @Bean
    public LocaleResolver localeResolver(final I18nProperties i18nProperties) {
        final AcceptHeaderLocaleResolver localeResolver = new AcceptHeaderLocaleResolver();
        localeResolver.setDefaultLocale(i18nProperties.defaultLocale());
        localeResolver.setSupportedLocales(i18nProperties.supportedLocales());
        return localeResolver;
    }
}
