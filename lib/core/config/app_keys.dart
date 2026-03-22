import 'package:memora/core/storage/storage_keys.dart';

abstract final class AppKeys {
  static const rootNavigatorKeyLabel = 'rootNavigator';
  static const rootScaffoldMessengerKeyLabel = 'rootScaffoldMessenger';
  static const authTokenStorageKey = StorageKeys.authToken;
  static const refreshTokenStorageKey = StorageKeys.refreshToken;
  static const themeTypeStorageKey = StorageKeys.themeType;
  static const localeStorageKey = StorageKeys.locale;
  static const onboardingSeenStorageKey = StorageKeys.onboardingSeen;
  static const lastKnownBaseUrlStorageKey = StorageKeys.lastKnownBaseUrl;
}
