import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_secondary_button.dart';
import 'package:memora/presentation/shared/primitives/displays/app_card.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';
import 'package:memora/presentation/shared/primitives/text/app_title_text.dart';

const double _authenticatedStateCardMaxWidth = 520;

class AuthenticatedStateCard extends StatelessWidget {
  const AuthenticatedStateCard({
    super.key,
    required this.userLabel,
    required this.onSignOut,
    this.onContinue,
  });

  final String userLabel;
  final Future<void> Function() onSignOut;
  final VoidCallback? onContinue;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: _authenticatedStateCardMaxWidth,
        ),
        child: AppCard(
          padding: EdgeInsets.all(context.spacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.verified_user_rounded,
                size: context.iconSize.xxl,
                color: context.colorScheme.primary,
              ),
              SizedBox(height: context.spacing.md),
              AppTitleText(text: context.l10n.authSessionReadyTitle),
              SizedBox(height: context.spacing.xs),
              AppBodyText(
                text: context.l10n.authSessionReadyMessage(userLabel),
                textAlign: TextAlign.center,
                isSecondary: true,
              ),
              SizedBox(height: context.spacing.lg),
              AppPrimaryButton(
                text: context.l10n.authContinueToAppAction,
                onPressed: onContinue,
              ),
              SizedBox(height: context.spacing.sm),
              AppSecondaryButton(
                text: context.l10n.authSignOutAction,
                onPressed: onSignOut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
