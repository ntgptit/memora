import 'package:memora/domain/entities/auth_session.dart';
import 'package:memora/domain/entities/auth_tokens.dart';
import 'package:memora/domain/entities/auth_user.dart';

abstract interface class AuthRepository {
  Future<AuthSession> login({
    required String identifier,
    required String password,
  });

  Future<AuthSession> register({
    required String username,
    required String email,
    required String password,
  });

  Future<AuthSession> refresh({required String refreshToken});

  Future<void> logout({required String refreshToken});

  Future<AuthUser> getCurrentUser();

  Future<AuthTokens?> readStoredTokens();

  Future<void> persistSession(AuthSession session);

  Future<void> clearPersistedSession();
}
