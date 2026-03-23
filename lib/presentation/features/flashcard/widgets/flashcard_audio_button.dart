import 'package:flutter/material.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_icon_button.dart';

class FlashcardAudioButton extends StatelessWidget {
  const FlashcardAudioButton({super.key, this.onPressed, this.tooltip});

  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      icon: const Icon(Icons.volume_up_rounded),
      onPressed: onPressed,
      tooltip: tooltip,
      variant: AppIconButtonVariant.tonal,
    );
  }
}
