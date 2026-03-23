import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/core/theme/tokens/tokens.dart';

class OnboardingIndicator extends StatelessWidget {
  const OnboardingIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var index = 0; index < count; index++) ...[
          AnimatedContainer(
            duration: AppMotionTokens.fast,
            width: index == currentIndex ? 28 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: index == currentIndex
                  ? context.colorScheme.primary
                  : context.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(context.radius.pill),
            ),
          ),
          if (index < count - 1) SizedBox(width: context.spacing.xs),
        ],
      ],
    );
  }
}
