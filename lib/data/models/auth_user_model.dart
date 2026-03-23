import 'package:flutter/foundation.dart';

@immutable
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

  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      id: _readInt(json['id']),
      username: _readString(json['username']),
      email: _readString(json['email']),
      accountStatus: _readString(json['accountStatus']),
    );
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

  static String _readString(Object? value) {
    return value is String ? value : '';
  }
}
