import 'package:memora/domain/entities/auth_session.dart';
import 'package:memora/domain/entities/auth_tokens.dart';
import 'package:memora/domain/entities/auth_user.dart';
import 'package:memora/domain/repositories/auth_repository.dart';

class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository({
    AuthTokens? storedTokens,
    AuthUser? currentUser,
    AuthSession? session,
  }) : _storedTokens = storedTokens,
       _currentUser = currentUser,
       _session = session;

  factory FakeAuthRepository.authenticated() {
    const user = AuthUser(
      id: 1,
      username: 'demo',
      email: 'demo@memora.local',
      accountStatus: 'ACTIVE',
    );
    const tokens = AuthTokens(
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
    );
    const session = AuthSession(
      user: user,
      accessToken: 'access-token',
      refreshToken: 'refresh-token',
      expiresIn: 28800,
      authenticated: true,
    );
    return FakeAuthRepository(
      storedTokens: tokens,
      currentUser: user,
      session: session,
    );
  }

  AuthTokens? _storedTokens;
  AuthUser? _currentUser;
  AuthSession? _session;

  AuthTokens? get storedTokens => _storedTokens;

  @override
  Future<void> clearPersistedSession() async {
    _storedTokens = null;
  }

  @override
  Future<AuthUser> getCurrentUser() async {
    final currentUser = _currentUser;
    if (currentUser == null) {
      throw StateError('No current user configured for FakeAuthRepository.');
    }
    return currentUser;
  }

  @override
  Future<AuthSession> login({
    required String identifier,
    required String password,
  }) async {
    return _requireSession();
  }

  @override
  Future<void> logout({required String refreshToken}) async {}

  @override
  Future<void> persistSession(AuthSession session) async {
    _session = session;
    _currentUser = session.user;
    _storedTokens = AuthTokens(
      accessToken: session.accessToken,
      refreshToken: session.refreshToken,
    );
  }

  @override
  Future<AuthTokens?> readStoredTokens() async {
    return _storedTokens;
  }

  @override
  Future<AuthSession> refresh({required String refreshToken}) async {
    return _requireSession();
  }

  @override
  Future<AuthSession> register({
    required String username,
    required String email,
    required String password,
  }) async {
    return _requireSession();
  }

  AuthSession _requireSession() {
    final session = _session;
    if (session == null) {
      throw StateError('No session configured for FakeAuthRepository.');
    }
    return session;
  }
}
