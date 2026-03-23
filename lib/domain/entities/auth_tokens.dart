import 'package:flutter/foundation.dart';

@immutable
class AuthTokens {
  const AuthTokens({
    this.accessToken,
    this.refreshToken,
  });

  final String? accessToken;
  final String? refreshToken;

  bool get hasAccessToken =>
      accessToken != null && accessToken!.trim().isNotEmpty;
  bool get hasRefreshToken =>
      refreshToken != null && refreshToken!.trim().isNotEmpty;
  bool get hasAnyToken => hasAccessToken || hasRefreshToken;
}
