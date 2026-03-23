import 'package:flutter/foundation.dart';

@immutable
class AuthUser {
  const AuthUser({
    required this.id,
    required this.username,
    required this.email,
    required this.accountStatus,
  });

  final int id;
  final String username;
  final String email;
  final String accountStatus;

  bool get isActive => accountStatus.toUpperCase() == 'ACTIVE';
  String get label => username.trim().isNotEmpty ? username : email;
}
