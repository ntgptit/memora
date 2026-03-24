import 'package:flutter/material.dart';
import 'package:memora/core/enums/snackbar_type.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/auth/providers/auth_state.dart';
import 'package:memora/presentation/shared/primitives/displays/app_card.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_banner.dart';
import 'package:memora/presentation/shared/primitives/inputs/app_password_field.dart';
import 'package:memora/presentation/shared/primitives/inputs/app_text_field.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_text_button.dart';
import 'package:memora/presentation/shared/primitives/selections/app_segmented_control.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';
import 'package:memora/presentation/shared/primitives/text/app_title_text.dart';

const double _loginFormMaxWidth = 560;

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.mode,
    required this.formKey,
    required this.identifierController,
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.onSubmit,
    required this.onModeChanged,
    this.onForgotPassword,
    this.isLoading = false,
    this.message,
    this.messageType,
    this.footer,
  });

  final AuthViewMode mode;
  final GlobalKey<FormState> formKey;
  final TextEditingController identifierController;
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final VoidCallback onSubmit;
  final ValueChanged<AuthViewMode> onModeChanged;
  final VoidCallback? onForgotPassword;
  final bool isLoading;
  final String? message;
  final SnackbarType? messageType;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _loginFormMaxWidth),
        child: AppCard(
          padding: EdgeInsets.all(context.spacing.xl),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppTitleText(
                  text: mode == AuthViewMode.login
                      ? l10n.authLoginTitle
                      : l10n.authRegisterTitle,
                ),
                SizedBox(height: context.spacing.xs),
                AppBodyText(
                  text: mode == AuthViewMode.login
                      ? l10n.authLoginSubtitle
                      : l10n.authRegisterSubtitle,
                  isSecondary: true,
                ),
                SizedBox(height: context.spacing.lg),
                AppSegmentedControl<AuthViewMode>(
                  segments: [
                    ButtonSegment<AuthViewMode>(
                      value: AuthViewMode.login,
                      label: Text(l10n.authModeLoginLabel),
                      icon: const Icon(Icons.login_rounded),
                    ),
                    ButtonSegment<AuthViewMode>(
                      value: AuthViewMode.register,
                      label: Text(l10n.authModeRegisterLabel),
                      icon: const Icon(Icons.person_add_alt_rounded),
                    ),
                  ],
                  selected: {mode},
                  onSelectionChanged: (selection) {
                    if (selection.isEmpty) {
                      return;
                    }
                    onModeChanged(selection.first);
                  },
                ),
                if (message != null && messageType != null) ...[
                  SizedBox(height: context.spacing.lg),
                  AppBanner(
                    title: _messageTitle(l10n, messageType!),
                    message: message!,
                    type: messageType!,
                  ),
                ],
                SizedBox(height: context.spacing.lg),
                if (mode == AuthViewMode.login) ...[
                  AppTextField(
                    label: l10n.authIdentifierLabel,
                    controller: identifierController,
                    isRequired: true,
                    hintText: l10n.authIdentifierHint,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => onSubmit(),
                    validator: (value) {
                      if ((value ?? '').trim().isEmpty) {
                        return l10n.authIdentifierRequiredError;
                      }
                      return null;
                    },
                  ),
                ] else ...[
                  AppTextField(
                    label: l10n.authUsernameLabel,
                    controller: usernameController,
                    isRequired: true,
                    hintText: l10n.authUsernameHint,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => onSubmit(),
                    validator: (value) {
                      if ((value ?? '').trim().length < 3) {
                        return l10n.authUsernameRequiredError;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: context.spacing.md),
                  AppTextField(
                    label: l10n.authEmailLabel,
                    controller: emailController,
                    isRequired: true,
                    hintText: l10n.authEmailHint,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => onSubmit(),
                    validator: (value) {
                      final trimmed = (value ?? '').trim();
                      if (!trimmed.contains('@') || !trimmed.contains('.')) {
                        return l10n.authEmailInvalidError;
                      }
                      return null;
                    },
                  ),
                ],
                SizedBox(height: context.spacing.md),
                AppPasswordField(
                  label: l10n.authPasswordLabel,
                  controller: passwordController,
                  isRequired: true,
                  hintText: l10n.authPasswordHint,
                  onSubmitted: (_) => onSubmit(),
                  validator: (value) {
                    if ((value ?? '').trim().length < 8) {
                      return l10n.authPasswordInvalidError;
                    }
                    return null;
                  },
                ),
                if (mode == AuthViewMode.login && onForgotPassword != null) ...[
                  SizedBox(height: context.spacing.xs),
                  Align(
                    alignment: Alignment.centerRight,
                    child: AppTextButton(
                      text: l10n.authForgotPasswordAction,
                      onPressed: isLoading ? null : onForgotPassword,
                    ),
                  ),
                ],
                if (footer != null) ...[
                  SizedBox(height: context.spacing.lg),
                  footer!,
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _messageTitle(AppLocalizations l10n, SnackbarType type) {
    switch (type) {
      case SnackbarType.success:
        return l10n.authSuccessBannerTitle;
      case SnackbarType.warning:
        return l10n.authWarningBannerTitle;
      case SnackbarType.error:
        return l10n.authErrorBannerTitle;
      case SnackbarType.info:
        return l10n.authInfoBannerTitle;
    }
  }
}
