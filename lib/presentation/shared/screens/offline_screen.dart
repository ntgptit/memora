import 'package:flutter/material.dart';
import 'package:memora/core/config/app_strings.dart';
import 'package:memora/presentation/shared/composites/states/app_offline_state.dart';
import 'package:memora/presentation/shared/layouts/app_scaffold.dart';

class OfflineScreen extends StatelessWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: AppStrings.offlineTitle,
      body: AppOfflineState(
        message: AppStrings.offlineMessage,
      ),
      constrainBody: true,
    );
  }
}
