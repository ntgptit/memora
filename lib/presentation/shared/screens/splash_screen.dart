import 'package:flutter/material.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/layouts/app_scaffold.dart';
import 'package:memora/presentation/shared/composites/states/app_loading_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: context.l10n.appName,
      body: AppLoadingState(
        message: context.l10n.splashTitle,
        subtitle: context.l10n.loading,
      ),
      constrainBody: true,
    );
  }
}
