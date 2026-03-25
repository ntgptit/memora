package com.memora.app.properties;

import java.util.List;
import java.util.Locale;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.validation.annotation.Validated;

@ConfigurationProperties(prefix = "app.i18n")
@Validated
public record I18nProperties(
    @NotNull Locale defaultLocale,
    @NotEmpty List<Locale> supportedLocales
) {

    public I18nProperties {
        supportedLocales = List.copyOf(supportedLocales);
    }
}
