package com.memora.app.properties;

import java.util.List;
import java.util.Locale;

import org.apache.commons.collections4.CollectionUtils;
import org.springframework.boot.context.properties.ConfigurationProperties;

@ConfigurationProperties(prefix = "app.i18n")
public record I18nProperties(
    Locale defaultLocale,
    List<Locale> supportedLocales
) {

    public I18nProperties {
        defaultLocale = defaultLocale == null ? Locale.ENGLISH : defaultLocale;
        supportedLocales = CollectionUtils.isEmpty(supportedLocales)
            ? List.of(defaultLocale)
            : List.copyOf(supportedLocales);
    }
}
