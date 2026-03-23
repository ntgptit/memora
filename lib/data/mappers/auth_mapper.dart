import 'package:memora/data/models/auth_session_model.dart';
import 'package:memora/data/models/auth_user_model.dart';
import 'package:memora/domain/entities/auth_session.dart';
import 'package:memora/domain/entities/auth_user.dart';

abstract final class AuthMapper {
  static AuthUser toUserEntity(AuthUserModel model) {
    return AuthUser(
      id: model.id,
      username: model.username,
      email: model.email,
      accountStatus: model.accountStatus,
    );
  }

  static AuthSession toSessionEntity(AuthSessionModel model) {
    return AuthSession(
      user: toUserEntity(model.user),
      accessToken: model.accessToken,
      refreshToken: model.refreshToken,
      expiresIn: model.expiresIn,
      authenticated: model.authenticated,
    );
  }
}
