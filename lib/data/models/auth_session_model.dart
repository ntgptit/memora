import 'package:json_annotation/json_annotation.dart';
import 'package:memora/data/models/auth_user_model.dart';

part 'auth_session_model.g.dart';

@JsonSerializable(explicitToJson: true)
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

  factory AuthSessionModel.fromJson(Map<String, dynamic> json) =>
      _$AuthSessionModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthSessionModelToJson(this);
}
