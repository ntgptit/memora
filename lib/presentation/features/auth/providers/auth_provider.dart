import 'dart:async';

import 'package:memora/core/enums/loading_status.dart';
import 'package:memora/core/theme/tokens/motion_tokens.dart';
import 'package:memora/presentation/features/auth/providers/auth_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  AuthState build() {
    Future<void>.microtask(_bootstrapSession);
    return const AuthState.initial();
  }

  Future<void> _bootstrapSession() async {
    await Future<void>.delayed(AppMotionTokens.slow);
    if (state.sessionStatus != AuthSessionStatus.checking) {
      return;
    }

    state = state.copyWith(
      sessionStatus: AuthSessionStatus.unauthenticated,
      submitStatus: LoadingStatus.idle,
      clearNotice: true,
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

    await Future<void>.delayed(AppMotionTokens.slow);

    if (_looksLikeNetworkFailure(identifier)) {
      state = state.copyWith(
        submitStatus: LoadingStatus.error,
        notice: AuthNotice.networkFailure,
      );
      return;
    }

    if (identifier.trim().isEmpty || password.trim().length < 8) {
      state = state.copyWith(
        submitStatus: LoadingStatus.error,
        notice: AuthNotice.invalidCredentials,
      );
      return;
    }

    state = state.copyWith(
      sessionStatus: AuthSessionStatus.authenticated,
      submitStatus: LoadingStatus.success,
      currentUserLabel: identifier.trim(),
      notice: AuthNotice.loginSucceeded,
    );
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

    await Future<void>.delayed(AppMotionTokens.emphasized);

    if (_looksLikeNetworkFailure(email)) {
      state = state.copyWith(
        submitStatus: LoadingStatus.error,
        notice: AuthNotice.networkFailure,
      );
      return;
    }

    if (_looksLikeDuplicateAccount(username, email)) {
      state = state.copyWith(
        submitStatus: LoadingStatus.error,
        notice: AuthNotice.duplicateAccount,
      );
      return;
    }

    state = state.copyWith(
      sessionStatus: AuthSessionStatus.authenticated,
      submitStatus: LoadingStatus.success,
      currentUserLabel: username.trim(),
      notice: AuthNotice.registrationSucceeded,
    );
  }

  Future<void> requestPasswordReset({required String email}) async {
    state = state.copyWith(
      submitStatus: LoadingStatus.loading,
      clearNotice: true,
    );

    await Future<void>.delayed(AppMotionTokens.slow);

    if (_looksLikeNetworkFailure(email)) {
      state = state.copyWith(
        submitStatus: LoadingStatus.error,
        notice: AuthNotice.networkFailure,
      );
      return;
    }

    if (!_looksLikeEmail(email)) {
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

    await Future<void>.delayed(AppMotionTokens.medium);

    state = state.copyWith(
      sessionStatus: AuthSessionStatus.unauthenticated,
      activeMode: AuthViewMode.login,
      submitStatus: LoadingStatus.success,
      notice: AuthNotice.signedOut,
      clearCurrentUser: true,
    );
  }

  bool _looksLikeNetworkFailure(String value) {
    return value.trim().toLowerCase().contains('offline');
  }

  bool _looksLikeDuplicateAccount(String username, String email) {
    return username.trim().toLowerCase().contains('taken') ||
        email.trim().toLowerCase().contains('taken');
  }

  bool _looksLikeEmail(String value) {
    final trimmed = value.trim();
    return trimmed.contains('@') && trimmed.contains('.');
  }
}
