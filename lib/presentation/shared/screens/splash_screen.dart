import 'package:flutter/material.dart';
import 'package:memora/core/config/app_strings.dart';
import 'package:memora/presentation/shared/layouts/app_scaffold.dart';
import 'package:memora/presentation/shared/composites/states/app_loading_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: AppStrings.appName,
      body: AppLoadingState(
        message: AppStrings.splashTitle,
        subtitle: AppStrings.loading,
      ),
      constrainBody: true,
    );
  }
}
