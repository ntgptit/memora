import 'package:json_annotation/json_annotation.dart';

part 'auth_requests.g.dart';

@JsonSerializable(includeIfNull: false)
class AuthLoginRequest {
  const AuthLoginRequest({required this.identifier, required this.password});

  final String identifier;
  final String password;

  factory AuthLoginRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthLoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AuthLoginRequestToJson(this);
}

@JsonSerializable(includeIfNull: false)
class AuthRegisterRequest {
  const AuthRegisterRequest({
    required this.username,
    required this.email,
    required this.password,
  });

  final String username;
  final String email;
  final String password;

  factory AuthRegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthRegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AuthRegisterRequestToJson(this);
}

@JsonSerializable(includeIfNull: false)
class AuthRefreshRequest {
  const AuthRefreshRequest({required this.refreshToken});

  final String refreshToken;

  factory AuthRefreshRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthRefreshRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AuthRefreshRequestToJson(this);
}

@JsonSerializable(includeIfNull: false)
class AuthLogoutRequest {
  const AuthLogoutRequest({required this.refreshToken});

  final String refreshToken;

  factory AuthLogoutRequest.fromJson(Map<String, dynamic> json) =>
      _$AuthLogoutRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AuthLogoutRequestToJson(this);
}
