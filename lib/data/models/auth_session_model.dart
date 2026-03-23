import 'package:flutter/foundation.dart';
import 'package:memora/data/models/auth_user_model.dart';

@immutable
class AuthSessionModel {
  const AuthSessionModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.authenticated,
  });

  final AuthUserModel user;
  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final bool authenticated;

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) {
    return AuthSessionModel(
      user: AuthUserModel.fromJson(
        json['user'] is Map<String, dynamic>
            ? json['user'] as Map<String, dynamic>
            : const <String, dynamic>{},
      ),
      accessToken: _readString(json['accessToken']),
      refreshToken: _readString(json['refreshToken']),
      expiresIn: _readInt(json['expiresIn']),
      authenticated: _readBool(json['authenticated'], fallback: true),
    );
  }

  static String _readString(Object? value) {
    return value is String ? value : '';
  }

  static int _readInt(Object? value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value) ?? 0;
    }
    return 0;
  }

  static bool _readBool(Object? value, {required bool fallback}) {
    if (value is bool) {
      return value;
    }
    return fallback;
  }
}
