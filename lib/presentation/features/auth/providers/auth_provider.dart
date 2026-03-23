import 'dart:async';

import 'package:memora/core/di/core_providers.dart';
import 'package:memora/core/di/repository_providers.dart';
import 'package:memora/core/enums/loading_status.dart';
import 'package:memora/core/services/auth_session_service.dart';
import 'package:memora/domain/repositories/auth_repository.dart';
import 'package:memora/presentation/features/auth/providers/auth_notice_mapper.dart';
import 'package:memora/presentation/features/auth/providers/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  AuthRepository get _authRepository => ref.read(authRepositoryProvider);

  @override
  AuthState build() {
    final authSessionService = ref.watch(authSessionServiceProvider);
    final subscription = authSessionService.events.listen((event) {
      if (event != AuthSessionEvent.expired) {
        return;
      }

      unawaited(_handleSessionExpired());
    });
    ref.onDispose(subscription.cancel);

    Future<void>.microtask(_bootstrapSession);
    return const AuthState.initial();
  }

  Future<void> _bootstrapSession() async {
    if (state.sessionStatus != AuthSessionStatus.checking) {
      return;
    }

    final storedTokens = await _authRepository.readStoredTokens();
    if (storedTokens == null || !storedTokens.hasAnyToken) {
      state = state.copyWith(
        sessionStatus: AuthSessionStatus.unauthenticated,
        submitStatus: LoadingStatus.idle,
        clearNotice: true,
        clearCurrentUser: true,
      );
      return;
    }

    try {
      if (storedTokens.hasAccessToken) {
        final currentUser = await _authRepository.getCurrentUser();
        state = state.copyWith(
          sessionStatus: AuthSessionStatus.authenticated,
          submitStatus: LoadingStatus.idle,
          currentUser: currentUser,
          clearNotice: true,
        );
        return;
      }

      if (storedTokens.hasRefreshToken) {
        await _restoreSession(storedTokens.refreshToken!);
        return;
      }
    } catch (error, stackTrace) {
      if (storedTokens.hasRefreshToken) {
        try {
          await _restoreSession(storedTokens.refreshToken!);
          return;
        } catch (_) {
          // Fall through to clearing the broken session.
        }
      }

      await _authRepository.clearPersistedSession();
      state = state.copyWith(
        sessionStatus: AuthSessionStatus.unauthenticated,
        submitStatus: LoadingStatus.idle,
        notice: AuthNoticeMapper.bootstrapNoticeFor(error, stackTrace),
        clearCurrentUser: true,
      );
      return;
    }

    await _authRepository.clearPersistedSession();
    state = state.copyWith(
      sessionStatus: AuthSessionStatus.unauthenticated,
      submitStatus: LoadingStatus.idle,
      clearNotice: true,
      clearCurrentUser: true,
    );
  }

  Future<void> _restoreSession(String refreshToken) async {
    final session = await _authRepository.refresh(refreshToken: refreshToken);
    await _authRepository.persistSession(session);
    state = state.copyWith(
      sessionStatus: AuthSessionStatus.authenticated,
      submitStatus: LoadingStatus.idle,
      currentUser: session.user,
      clearNotice: true,
    );
  }

  Future<void> _handleSessionExpired() async {
    await _authRepository.clearPersistedSession();

    if (state.sessionStatus == AuthSessionStatus.unauthenticated &&
        state.notice == AuthNotice.sessionExpired) {
      return;
    }

    state = state.copyWith(
      sessionStatus: AuthSessionStatus.unauthenticated,
      activeMode: AuthViewMode.login,
      submitStatus: LoadingStatus.idle,
      notice: AuthNotice.sessionExpired,
      clearCurrentUser: true,
    );
  }

  void setMode(AuthViewMode mode) {
    if (state.activeMode == mode) {
      return;
    }

    state = state.copyWith(
      activeMode: mode,
      clearNotice: true,
      submitStatus: LoadingStatus.idle,
    );
  }

  void clearNotice() {
    if (state.notice == null) {
      return;
    }

    state = state.copyWith(clearNotice: true);
  }

  Future<void> signIn({
    required String identifier,
    required String password,
  }) async {
    state = state.copyWith(
      submitStatus: LoadingStatus.loading,
      clearNotice: true,
    );

    try {
      final session = await _authRepository.login(
        identifier: identifier.trim(),
        password: password,
      );
      await _authRepository.persistSession(session);

      state = state.copyWith(
        sessionStatus: AuthSessionStatus.authenticated,
        submitStatus: LoadingStatus.success,
        currentUser: session.user,
        notice: AuthNotice.loginSucceeded,
      );
    } catch (error, stackTrace) {
      state = state.copyWith(
        sessionStatus: AuthSessionStatus.unauthenticated,
        submitStatus: LoadingStatus.error,
        notice: AuthNoticeMapper.noticeForError(
          error,
          stackTrace,
          isRegister: false,
        ),
        clearCurrentUser: true,
      );
    }
  }

  Future<void> registerAccount({
    required String username,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(
      submitStatus: LoadingStatus.loading,
      clearNotice: true,
    );

    try {
      final session = await _authRepository.register(
        username: username.trim(),
        email: email.trim(),
        password: password,
      );
      await _authRepository.persistSession(session);

      state = state.copyWith(
        sessionStatus: AuthSessionStatus.authenticated,
        submitStatus: LoadingStatus.success,
        currentUser: session.user,
        notice: AuthNotice.registrationSucceeded,
      );
    } catch (error, stackTrace) {
      state = state.copyWith(
        sessionStatus: AuthSessionStatus.unauthenticated,
        submitStatus: LoadingStatus.error,
        notice: AuthNoticeMapper.noticeForError(
          error,
          stackTrace,
          isRegister: true,
        ),
        clearCurrentUser: true,
      );
    }
  }

  Future<void> requestPasswordReset({required String email}) async {
    state = state.copyWith(
      submitStatus: LoadingStatus.loading,
      clearNotice: true,
    );

    final trimmedEmail = email.trim();
    if (!trimmedEmail.contains('@') || !trimmedEmail.contains('.')) {
      state = state.copyWith(
        submitStatus: LoadingStatus.error,
        notice: AuthNotice.invalidResetRequest,
      );
      return;
    }

    state = state.copyWith(
      submitStatus: LoadingStatus.success,
      notice: AuthNotice.passwordResetSent,
    );
  }

  Future<void> signOut() async {
    state = state.copyWith(
      submitStatus: LoadingStatus.loading,
      clearNotice: true,
    );

    final storedTokens = await _authRepository.readStoredTokens();
    try {
      final refreshToken = AuthNoticeMapper.extractRefreshToken(storedTokens);
      if (refreshToken != null) {
        await _authRepository.logout(refreshToken: refreshToken);
      }
    } catch (_) {
      // Clearing local session data is the primary goal on sign-out.
    }

    await _authRepository.clearPersistedSession();

    state = state.copyWith(
      sessionStatus: AuthSessionStatus.unauthenticated,
      activeMode: AuthViewMode.login,
      submitStatus: LoadingStatus.success,
      notice: AuthNotice.signedOut,
      clearCurrentUser: true,
    );
  }
}
