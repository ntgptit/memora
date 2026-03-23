import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_outline_button.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({
    super.key,
    this.onProviderSelected,
    this.isBusy = false,
  });

  final ValueChanged<String>? onProviderSelected;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.authSocialSectionTitle,
          style: context.textTheme.labelLarge?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: context.spacing.sm),
        Wrap(
          spacing: context.spacing.sm,
          runSpacing: context.spacing.sm,
          alignment: WrapAlignment.center,
          children: [
            AppOutlineButton(
              text: l10n.authContinueWithGoogle,
              onPressed: isBusy
                  ? null
                  : () => onProviderSelected?.call('google'),
              leading: const Icon(Icons.g_mobiledata_rounded),
            ),
            AppOutlineButton(
              text: l10n.authContinueWithApple,
              onPressed: isBusy
                  ? null
                  : () => onProviderSelected?.call('apple'),
              leading: const Icon(Icons.apple_rounded),
            ),
            AppOutlineButton(
              text: l10n.authContinueWithKakao,
              onPressed: isBusy
                  ? null
                  : () => onProviderSelected?.call('kakao'),
              leading: const Icon(Icons.chat_bubble_rounded),
            ),
          ],
        ),
      ],
    );
  }
}
