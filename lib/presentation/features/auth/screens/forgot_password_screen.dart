import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/app/app_routes.dart';
import 'package:memora/core/enums/snackbar_type.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/auth/providers/auth_provider.dart';
import 'package:memora/presentation/features/auth/providers/auth_state.dart';
import 'package:memora/presentation/shared/composites/forms/app_submit_bar.dart';
import 'package:memora/presentation/shared/layouts/app_form_page_layout.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_text_button.dart';
import 'package:memora/presentation/shared/primitives/feedback/app_banner.dart';
import 'package:memora/presentation/shared/primitives/inputs/app_text_field.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() {
    return _ForgotPasswordScreenState();
  }
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return AppFormPageLayout(
      title: Text(context.l10n.authForgotPasswordTitle),
      subtitle: Text(context.l10n.authForgotPasswordSubtitle),
      header: _buildHeader(context, state.notice),
      sections: [
        Form(
          key: _formKey,
          child: AppTextField(
            label: context.l10n.authEmailLabel,
            controller: _emailController,
            isRequired: true,
            hintText: context.l10n.authEmailHint,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              final trimmed = (value ?? '').trim();
              if (!trimmed.contains('@') || !trimmed.contains('.')) {
                return context.l10n.authEmailInvalidError;
              }
              return null;
            },
            onSubmitted: (_) => _submit(),
          ),
        ),
      ],
      submitBar: AppSubmitBar(
        secondaryAction: AppTextButton(
          text: context.l10n.authBackToLoginAction,
          onPressed: () => context.go(AppRoutes.login),
        ),
        primaryAction: AppPrimaryButton(
          text: context.l10n.authSendResetAction,
          isLoading: state.submitStatus.isLoading,
          onPressed: _submit,
        ),
      ),
    );
  }

  Widget? _buildHeader(BuildContext context, AuthNotice? notice) {
    if (notice == null) {
      return null;
    }

    final l10n = context.l10n;
    switch (notice) {
      case AuthNotice.passwordResetSent:
        return AppBanner(
          title: l10n.authSuccessBannerTitle,
          message: l10n.authPasswordResetSuccessMessage,
          type: SnackbarType.success,
        );
      case AuthNotice.invalidResetRequest:
        return AppBanner(
          title: l10n.authErrorBannerTitle,
          message: l10n.authInvalidResetRequestMessage,
          type: SnackbarType.error,
        );
      case AuthNotice.networkFailure:
        return AppBanner(
          title: l10n.authErrorBannerTitle,
          message: l10n.authNetworkFailureMessage,
          type: SnackbarType.error,
        );
      case AuthNotice.loginSucceeded:
      case AuthNotice.registrationSucceeded:
      case AuthNotice.signedOut:
      case AuthNotice.invalidCredentials:
      case AuthNotice.duplicateAccount:
        return null;
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await ref
        .read(authControllerProvider.notifier)
        .requestPasswordReset(email: _emailController.text);
  }
}
