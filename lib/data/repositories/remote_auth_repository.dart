import 'package:memora/core/storage/secure_storage.dart';
import 'package:memora/core/storage/storage_keys.dart';
import 'package:memora/data/datasources/auth_api.dart';
import 'package:memora/data/mappers/auth_mapper.dart';
import 'package:memora/data/models/auth_requests.dart';
import 'package:memora/domain/entities/auth_session.dart';
import 'package:memora/domain/entities/auth_tokens.dart';
import 'package:memora/domain/entities/auth_user.dart';
import 'package:memora/domain/repositories/auth_repository.dart';

class RemoteAuthRepository implements AuthRepository {
  const RemoteAuthRepository(this._authApi, this._secureStorage);

  final AuthApi _authApi;
  final SecureStorage _secureStorage;

  @override
  Future<void> clearPersistedSession() async {
    await _secureStorage.clear(
      keys: <String>{
        StorageKeys.authToken,
        StorageKeys.refreshToken,
      },
    );
  }

  @override
  Future<AuthUser> getCurrentUser() async {
    final user = await _authApi.me();
    return AuthMapper.toUserEntity(user);
  }

  @override
  Future<AuthSession> login({
    required String identifier,
    required String password,
  }) async {
    final session = await _authApi.login(
      AuthLoginRequest(
        identifier: identifier,
        password: password,
      ),
    );
    return AuthMapper.toSessionEntity(session);
  }

  @override
  Future<void> logout({
    required String refreshToken,
  }) {
    return _authApi.logout(AuthLogoutRequest(refreshToken: refreshToken));
  }

  @override
  Future<void> persistSession(AuthSession session) async {
    await _secureStorage.write(StorageKeys.authToken, session.accessToken);
    await _secureStorage.write(StorageKeys.refreshToken, session.refreshToken);
  }

  @override
  Future<AuthTokens?> readStoredTokens() async {
    final values = await _secureStorage.readAll(
      allowList: <String>{
        StorageKeys.authToken,
        StorageKeys.refreshToken,
      },
    );
    final tokens = AuthTokens(
      accessToken: values[StorageKeys.authToken],
      refreshToken: values[StorageKeys.refreshToken],
    );
    if (!tokens.hasAnyToken) {
      return null;
    }
    return tokens;
  }

  @override
  Future<AuthSession> refresh({
    required String refreshToken,
  }) async {
    final session = await _authApi.refresh(
      AuthRefreshRequest(refreshToken: refreshToken),
    );
    return AuthMapper.toSessionEntity(session);
  }

  @override
  Future<AuthSession> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final session = await _authApi.register(
      AuthRegisterRequest(
        username: username,
        email: email,
        password: password,
      ),
    );
    return AuthMapper.toSessionEntity(session);
  }
}
