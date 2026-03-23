import 'package:dio/dio.dart';
import 'package:memora/core/errors/auth_failure.dart';
import 'package:memora/core/errors/error_mapper.dart';
import 'package:memora/core/errors/validation_failure.dart';
import 'package:memora/domain/entities/auth_tokens.dart';
import 'package:memora/presentation/features/auth/providers/auth_state.dart';

abstract final class AuthNoticeMapper {
  static String? extractRefreshToken(AuthTokens? storedTokens) {
    final refreshToken = storedTokens?.refreshToken?.trim();
    if (refreshToken == null || refreshToken.isEmpty) {
      return null;
    }
    return refreshToken;
  }

  static AuthNotice? bootstrapNoticeFor(Object error, StackTrace stackTrace) {
    final failure = ErrorMapper.map(error, stackTrace: stackTrace);
    if (failure is AuthFailure) {
      return null;
    }
    return AuthNotice.networkFailure;
  }

  static AuthNotice noticeForError(
    Object error,
    StackTrace stackTrace, {
    required bool isRegister,
  }) {
    if (error is DioException) {
      final statusCode = error.response?.statusCode;
      if (statusCode == 409) {
        return AuthNotice.duplicateAccount;
      }
      if (statusCode == 401 || statusCode == 403) {
        return isRegister
            ? AuthNotice.duplicateAccount
            : AuthNotice.invalidCredentials;
      }
    }

    final failure = ErrorMapper.map(error, stackTrace: stackTrace);
    if (failure is ValidationFailure) {
      return isRegister
          ? AuthNotice.duplicateAccount
          : AuthNotice.invalidCredentials;
    }
    if (failure is AuthFailure) {
      return isRegister
          ? AuthNotice.duplicateAccount
          : AuthNotice.invalidCredentials;
    }
    return AuthNotice.networkFailure;
  }
}
