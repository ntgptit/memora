import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/app/app_routes.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/onboarding/providers/onboarding_provider.dart';
import 'package:memora/presentation/shared/composites/forms/app_form_section.dart';
import 'package:memora/presentation/shared/composites/forms/app_submit_bar.dart';
import 'package:memora/presentation/shared/layouts/app_form_page_layout.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_text_button.dart';
import 'package:memora/presentation/shared/primitives/selections/app_switch.dart';

class PermissionsIntroScreen extends ConsumerWidget {
  const PermissionsIntroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);

    return AppFormPageLayout(
      title: Text(context.l10n.onboardingPermissionsTitle),
      subtitle: Text(context.l10n.onboardingPermissionsSubtitle),
      sections: [
        AppFormSection(
          title: Text(context.l10n.onboardingPermissionNotificationsTitle),
          subtitle: Text(
            context.l10n.onboardingPermissionNotificationsDescription,
          ),
          trailing: AppSwitch(
            value: state.notificationsEnabled,
            onChanged: controller.toggleNotifications,
          ),
          child: Text(
            context.l10n.onboardingPermissionNotificationsNote,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        AppFormSection(
          title: Text(context.l10n.onboardingPermissionAudioTitle),
          subtitle: Text(context.l10n.onboardingPermissionAudioDescription),
          trailing: AppSwitch(
            value: state.audioPromptsEnabled,
            onChanged: controller.toggleAudioPrompts,
          ),
          child: Text(
            context.l10n.onboardingPermissionAudioNote,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
      submitBar: AppSubmitBar(
        secondaryAction: AppTextButton(
          text: context.l10n.onboardingBackAction,
          onPressed: context.pop,
        ),
        primaryAction: AppPrimaryButton(
          text: context.l10n.onboardingGoalSetupAction,
          onPressed: () => context.push(AppRoutes.onboardingStudyGoal),
        ),
      ),
    );
  }
}
