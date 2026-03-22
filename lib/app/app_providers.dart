import 'package:flutter/material.dart';
import 'package:memora/core/config/app_constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:memora/core/di/core_providers.dart';
import 'package:memora/core/config/app_keys.dart';
import 'package:memora/core/enums/app_theme_type.dart';
import 'package:memora/core/enums/app_locale.dart';
import 'package:memora/core/services/bottom_sheet_service.dart';
import 'package:memora/core/services/dialog_service.dart';
import 'package:memora/core/services/navigation_service.dart';
import 'package:memora/core/services/snackbar_service.dart';
import 'package:memora/core/utils/logger.dart';

part 'app_providers.g.dart';

@Riverpod(keepAlive: true)
GlobalKey<NavigatorState> rootNavigatorKey(Ref ref) {
  return GlobalKey<NavigatorState>(debugLabel: AppKeys.rootNavigatorKeyLabel);
}

@Riverpod(keepAlive: true)
GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey(Ref ref) {
  return GlobalKey<ScaffoldMessengerState>(
    debugLabel: AppKeys.rootScaffoldMessengerKeyLabel,
  );
}

@Riverpod(keepAlive: true)
class ThemeTypeController extends _$ThemeTypeController {
  @override
  AppThemeType build() {
    final storage = ref.watch(preferencesStorageProvider);
    final rawValue = storage.read<String>(AppKeys.themeTypeStorageKey);

    return _themeTypeFromStorage(rawValue);
  }

  Future<void> setTheme(AppThemeType themeType) async {
    state = themeType;
    await ref
        .read(preferencesStorageProvider)
        .write(AppKeys.themeTypeStorageKey, themeType.name);
  }

  Future<void> reset() {
    return setTheme(AppThemeType.system);
  }

  Future<void> toggle() {
    switch (state) {
      case AppThemeType.system:
        return setTheme(AppThemeType.light);
      case AppThemeType.light:
        return setTheme(AppThemeType.dark);
      case AppThemeType.dark:
        return setTheme(AppThemeType.system);
    }
  }
}

@Riverpod(keepAlive: true)
class AppLocaleController extends _$AppLocaleController {
  @override
  AppLocale build() {
    final storage = ref.watch(preferencesStorageProvider);
    final rawValue = storage.read<String>(AppKeys.localeStorageKey);

    return _localeFromStorage(rawValue);
  }

  Future<void> setLocale(AppLocale locale) async {
    state = locale;
    await ref
        .read(preferencesStorageProvider)
        .write(AppKeys.localeStorageKey, locale.languageCode);
  }

  Future<void> reset() {
    return setLocale(_localeFromStorage(null));
  }
}

@Riverpod(keepAlive: true)
class LifecycleStateController extends _$LifecycleStateController {
  @override
  AppLifecycleState? build() {
    return WidgetsBinding.instance.lifecycleState;
  }

  void setLifecycle(AppLifecycleState lifecycleState) {
    if (state == lifecycleState) {
      return;
    }

    Logger.debug('Lifecycle changed: $lifecycleState');
    state = lifecycleState;
  }
}

@Riverpod(keepAlive: true)
Locale appLocale(Ref ref) {
  final selectedLocale = ref.watch(appLocaleControllerProvider);
  return Locale(selectedLocale.languageCode);
}

@Riverpod(keepAlive: true)
List<Locale> supportedLocales(Ref ref) {
  return AppConstants.supportedLocales;
}

@Riverpod(keepAlive: true)
NavigationService navigationService(Ref ref) {
  final navigatorKey = ref.watch(rootNavigatorKeyProvider);
  return NavigationService(navigatorKey);
}

@Riverpod(keepAlive: true)
DialogService dialogService(Ref ref) {
  final navigatorKey = ref.watch(rootNavigatorKeyProvider);
  return DialogService(navigatorKey);
}

@Riverpod(keepAlive: true)
BottomSheetService bottomSheetService(Ref ref) {
  final navigatorKey = ref.watch(rootNavigatorKeyProvider);
  return BottomSheetService(navigatorKey);
}

@Riverpod(keepAlive: true)
SnackbarService snackbarService(Ref ref) {
  final messengerKey = ref.watch(rootScaffoldMessengerKeyProvider);
  return SnackbarService(messengerKey);
}

AppThemeType _themeTypeFromStorage(String? rawValue) {
  switch (rawValue) {
    case 'light':
      return AppThemeType.light;
    case 'dark':
      return AppThemeType.dark;
    default:
      return AppThemeType.system;
  }
}

AppLocale _localeFromStorage(String? rawValue) {
  switch (rawValue) {
    case 'vi':
      return AppLocale.vi;
    case 'ko':
      return AppLocale.ko;
    case 'en':
    default:
      return AppLocale.values.firstWhere(
        (locale) => locale.languageCode == AppConstants.defaultLocaleCode,
        orElse: () => AppLocale.en,
      );
  }
}
