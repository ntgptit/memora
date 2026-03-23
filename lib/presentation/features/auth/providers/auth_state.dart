import 'package:flutter/foundation.dart';
import 'package:memora/core/enums/loading_status.dart';
import 'package:memora/domain/entities/auth_user.dart';

enum AuthViewMode { login, register }

enum AuthSessionStatus { checking, authenticated, unauthenticated }

enum AuthNotice {
  loginSucceeded,
  registrationSucceeded,
  signedOut,
  sessionExpired,
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
    this.currentUser,
  });

  const AuthState.initial()
    : sessionStatus = AuthSessionStatus.checking,
      activeMode = AuthViewMode.login,
      submitStatus = LoadingStatus.idle,
      notice = null,
      currentUser = null;

  final AuthSessionStatus sessionStatus;
  final AuthViewMode activeMode;
  final LoadingStatus submitStatus;
  final AuthNotice? notice;
  final AuthUser? currentUser;

  bool get isCheckingSession => sessionStatus == AuthSessionStatus.checking;
  bool get isAuthenticated => sessionStatus == AuthSessionStatus.authenticated;
  bool get isBusy => isCheckingSession || submitStatus.isLoading;
  String? get currentUserLabel => currentUser?.label;

  AuthState copyWith({
    AuthSessionStatus? sessionStatus,
    AuthViewMode? activeMode,
    LoadingStatus? submitStatus,
    AuthNotice? notice,
    bool clearNotice = false,
    AuthUser? currentUser,
    bool clearCurrentUser = false,
  }) {
    return AuthState(
      sessionStatus: sessionStatus ?? this.sessionStatus,
      activeMode: activeMode ?? this.activeMode,
      submitStatus: submitStatus ?? this.submitStatus,
      notice: clearNotice ? null : notice ?? this.notice,
      currentUser: clearCurrentUser ? null : currentUser ?? this.currentUser,
    );
  }
}
