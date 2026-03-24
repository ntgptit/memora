import 'package:flutter/foundation.dart';

@immutable
class AuthLoginRequest {
  const AuthLoginRequest({required this.identifier, required this.password});

  final String identifier;
  final String password;

  Map<String, Object?> toJson() {
    return <String, Object?>{'identifier': identifier, 'password': password};
  }
}

@immutable
class AuthRegisterRequest {
  const AuthRegisterRequest({
    required this.username,
    required this.email,
    required this.password,
  });

  final String username;
  final String email;
  final String password;

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'username': username,
      'email': email,
      'password': password,
    };
  }
}

@immutable
class AuthRefreshRequest {
  const AuthRefreshRequest({required this.refreshToken});

  final String refreshToken;

  Map<String, Object?> toJson() {
    return <String, Object?>{'refreshToken': refreshToken};
  }
}

@immutable
class AuthLogoutRequest {
  const AuthLogoutRequest({required this.refreshToken});

  final String refreshToken;

  Map<String, Object?> toJson() {
    return <String, Object?>{'refreshToken': refreshToken};
  }
}
