import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memora/app/app_route_data.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/core/theme/tokens/tokens.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/onboarding/providers/onboarding_provider.dart';
import 'package:memora/presentation/features/onboarding/widgets/onboarding_indicator.dart';
import 'package:memora/presentation/features/onboarding/widgets/onboarding_page_view.dart';
import 'package:memora/presentation/shared/composites/forms/app_submit_bar.dart';
import 'package:memora/presentation/shared/layouts/app_scaffold.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_text_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final pages = [
      OnboardingPageContent(
        icon: Icons.folder_copy_rounded,
        title: context.l10n.onboardingPageOrganizeTitle,
        description: context.l10n.onboardingPageOrganizeDescription,
        highlight: context.l10n.onboardingPageOrganizeHighlight,
      ),
      OnboardingPageContent(
        icon: Icons.style_rounded,
        title: context.l10n.onboardingPageReviewTitle,
        description: context.l10n.onboardingPageReviewDescription,
        highlight: context.l10n.onboardingPageReviewHighlight,
      ),
      OnboardingPageContent(
        icon: Icons.timeline_rounded,
        title: context.l10n.onboardingPageMomentumTitle,
        description: context.l10n.onboardingPageMomentumDescription,
        highlight: context.l10n.onboardingPageMomentumHighlight,
      ),
    ];

    return AppScaffold(
      title: context.l10n.onboardingTitle,
      body: Column(
        children: [
          Expanded(
            child: OnboardingPageView(
              controller: _pageController,
              pages: pages,
              onPageChanged: controller.setPage,
            ),
          ),
          SizedBox(height: context.spacing.lg),
          OnboardingIndicator(
            count: pages.length,
            currentIndex: state.currentPageIndex,
          ),
        ],
      ),
      footer: AppSubmitBar(
        secondaryAction: AppTextButton(
          text: state.currentPageIndex == pages.length - 1
              ? context.l10n.onboardingPermissionsAction
              : context.l10n.onboardingSkipAction,
          onPressed: () => const OnboardingPermissionsRouteData().push(context),
        ),
        primaryAction: AppPrimaryButton(
          text: state.currentPageIndex == pages.length - 1
              ? context.l10n.onboardingContinueAction
              : context.l10n.onboardingNextAction,
          onPressed: () async {
            if (state.currentPageIndex == pages.length - 1) {
              await const OnboardingPermissionsRouteData().push(context);
              return;
            }

            controller.nextPage(pages.length - 1);
            await _pageController.animateToPage(
              state.currentPageIndex + 1,
              duration: AppMotionTokens.medium,
              curve: AppMotionTokens.standardCurve,
            );
          },
        ),
      ),
    );
  }
}
