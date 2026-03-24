import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/presentation/shared/primitives/displays/app_card.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';
import 'package:memora/presentation/shared/primitives/text/app_title_text.dart';

const double _onboardingIllustrationSize = 88;

@immutable
class OnboardingPageContent {
  const OnboardingPageContent({
    required this.icon,
    required this.title,
    required this.description,
    required this.highlight,
  });

  final IconData icon;
  final String title;
  final String description;
  final String highlight;
}

class OnboardingPageView extends StatelessWidget {
  const OnboardingPageView({
    super.key,
    required this.controller,
    required this.pages,
    required this.onPageChanged,
  });

  final PageController controller;
  final List<OnboardingPageContent> pages;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      onPageChanged: onPageChanged,
      itemCount: pages.length,
      itemBuilder: (context, index) {
        final page = pages[index];
        return AppCard(
          padding: EdgeInsets.all(context.spacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: _onboardingIllustrationSize,
                height: _onboardingIllustrationSize,
                decoration: BoxDecoration(
                  color: context.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(context.radius.xl),
                ),
                alignment: Alignment.center,
                child: Icon(
                  page.icon,
                  size: context.iconSize.xxl,
                  color: context.colorScheme.onPrimaryContainer,
                ),
              ),
              SizedBox(height: context.spacing.xl),
              AppTitleText(text: page.title, textAlign: TextAlign.center),
              SizedBox(height: context.spacing.sm),
              AppBodyText(
                text: page.description,
                textAlign: TextAlign.center,
                isSecondary: true,
              ),
              SizedBox(height: context.spacing.lg),
              Container(
                padding: EdgeInsets.all(context.spacing.md),
                decoration: BoxDecoration(
                  color: context.colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(context.radius.lg),
                ),
                child: AppBodyText(
                  text: page.highlight,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
