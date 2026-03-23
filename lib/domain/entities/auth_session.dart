import 'package:flutter/foundation.dart';
import 'package:memora/domain/entities/auth_user.dart';

@immutable
class AuthSession {
  const AuthSession({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.authenticated,
  });

  final AuthUser user;
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final bool authenticated;
}
