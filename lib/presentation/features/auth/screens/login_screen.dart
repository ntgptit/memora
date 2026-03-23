import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/app/app_routes.dart';
import 'package:memora/core/enums/snackbar_type.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/auth/providers/auth_provider.dart';
import 'package:memora/presentation/features/auth/providers/auth_state.dart';
import 'package:memora/presentation/features/auth/widgets/authenticated_state_card.dart';
import 'package:memora/presentation/features/auth/widgets/login_form.dart';
import 'package:memora/presentation/features/auth/widgets/social_login_buttons.dart';
import 'package:memora/presentation/shared/composites/states/app_loading_state.dart';
import 'package:memora/presentation/shared/layouts/app_scaffold.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({
    super.key,
    this.initialMode = AuthViewMode.login,
    this.onAuthenticated,
  });

  final AuthViewMode initialMode;
  final VoidCallback? onAuthenticated;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _identifierController;
  late final TextEditingController _usernameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _identifierController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authControllerProvider.notifier).setMode(widget.initialMode);
    });
  }

  @override
  void dispose() {
    _identifierController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authControllerProvider, (previous, next) {
      if (previous?.isAuthenticated == true || !next.isAuthenticated) {
        return;
      }
      widget.onAuthenticated?.call();
    });

    final state = ref.watch(authControllerProvider);
    final controller = ref.read(authControllerProvider.notifier);

    return AppScaffold(
      title: context.l10n.appName,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(context.spacing.lg),
          child: state.isCheckingSession
              ? AppLoadingState(
                  message: context.l10n.authBootstrapLoadingTitle,
                  subtitle: context.l10n.authBootstrapLoadingSubtitle,
                )
              : state.isAuthenticated
              ? AuthenticatedStateCard(
                  userLabel: state.currentUserLabel ?? context.l10n.appName,
                  onContinue: widget.onAuthenticated,
                  onSignOut: controller.signOut,
                )
              : Column(
                  children: [
                    Expanded(
                      child: LoginForm(
                        mode: state.activeMode,
                        formKey: _formKey,
                        identifierController: _identifierController,
                        usernameController: _usernameController,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        isLoading: state.isBusy,
                        message: _noticeMessage(context, state.notice),
                        messageType: _noticeType(state.notice),
                        onModeChanged: (mode) {
                          controller.setMode(mode);
                        },
                        onForgotPassword: () =>
                            context.push(AppRoutes.forgotPassword),
                        onSubmit: () => _submit(state.activeMode),
                        footer: SocialLoginButtons(isBusy: state.isBusy),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _submit(AuthViewMode mode) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final controller = ref.read(authControllerProvider.notifier);
    if (mode == AuthViewMode.login) {
      await controller.signIn(
        identifier: _identifierController.text,
        password: _passwordController.text,
      );
      return;
    }

    await controller.registerAccount(
      username: _usernameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  String? _noticeMessage(BuildContext context, AuthNotice? notice) {
    final l10n = context.l10n;
    switch (notice) {
      case null:
        return null;
      case AuthNotice.loginSucceeded:
        return l10n.authLoginSuccessMessage;
      case AuthNotice.registrationSucceeded:
        return l10n.authRegisterSuccessMessage;
      case AuthNotice.signedOut:
        return l10n.authSignOutSuccessMessage;
      case AuthNotice.passwordResetSent:
        return l10n.authPasswordResetSuccessMessage;
      case AuthNotice.invalidCredentials:
        return l10n.authInvalidCredentialsMessage;
      case AuthNotice.duplicateAccount:
        return l10n.authDuplicateAccountMessage;
      case AuthNotice.invalidResetRequest:
        return l10n.authInvalidResetRequestMessage;
      case AuthNotice.networkFailure:
        return l10n.authNetworkFailureMessage;
    }
  }

  SnackbarType? _noticeType(AuthNotice? notice) {
    switch (notice) {
      case null:
        return null;
      case AuthNotice.loginSucceeded:
      case AuthNotice.registrationSucceeded:
      case AuthNotice.signedOut:
      case AuthNotice.passwordResetSent:
        return SnackbarType.success;
      case AuthNotice.invalidCredentials:
      case AuthNotice.duplicateAccount:
      case AuthNotice.invalidResetRequest:
      case AuthNotice.networkFailure:
        return SnackbarType.error;
    }
  }
}
