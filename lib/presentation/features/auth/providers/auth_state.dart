import 'package:flutter/foundation.dart';
import 'package:memora/core/enums/loading_status.dart';

enum AuthViewMode { login, register }

enum AuthSessionStatus { checking, authenticated, unauthenticated }

enum AuthNotice {
  loginSucceeded,
  registrationSucceeded,
  signedOut,
  passwordResetSent,
  invalidCredentials,
  duplicateAccount,
  invalidResetRequest,
  networkFailure,
}

@immutable
class AuthState {
  const AuthState({
    required this.sessionStatus,
    required this.activeMode,
    required this.submitStatus,
    this.notice,
    this.currentUserLabel,
  });

  const AuthState.initial()
    : sessionStatus = AuthSessionStatus.checking,
      activeMode = AuthViewMode.login,
      submitStatus = LoadingStatus.idle,
      notice = null,
      currentUserLabel = null;

  final AuthSessionStatus sessionStatus;
  final AuthViewMode activeMode;
  final LoadingStatus submitStatus;
  final AuthNotice? notice;
  final String? currentUserLabel;

  bool get isCheckingSession => sessionStatus == AuthSessionStatus.checking;
  bool get isAuthenticated => sessionStatus == AuthSessionStatus.authenticated;
  bool get isBusy => isCheckingSession || submitStatus.isLoading;

  AuthState copyWith({
    AuthSessionStatus? sessionStatus,
    AuthViewMode? activeMode,
    LoadingStatus? submitStatus,
    AuthNotice? notice,
    bool clearNotice = false,
    String? currentUserLabel,
    bool clearCurrentUser = false,
  }) {
    return AuthState(
      sessionStatus: sessionStatus ?? this.sessionStatus,
      activeMode: activeMode ?? this.activeMode,
      submitStatus: submitStatus ?? this.submitStatus,
      notice: clearNotice ? null : notice ?? this.notice,
      currentUserLabel: clearCurrentUser
          ? null
          : currentUserLabel ?? this.currentUserLabel,
    );
  }
}
