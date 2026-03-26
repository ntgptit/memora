import 'package:json_annotation/json_annotation.dart';

part 'auth_user_model.g.dart';

@JsonSerializable()
class AuthUserModel {
  const AuthUserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.accountStatus,
  });

  final int id;
  final String username;
  final String email;
  final String accountStatus;

  factory AuthUserModel.fromJson(Map<String, dynamic> json) =>
      _$AuthUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthUserModelToJson(this);
}
