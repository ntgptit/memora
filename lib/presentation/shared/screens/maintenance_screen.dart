import 'package:flutter/material.dart';
import 'package:memora/core/config/app_strings.dart';
import 'package:memora/presentation/shared/composites/states/app_error_state.dart';
import 'package:memora/presentation/shared/layouts/app_scaffold.dart';
import 'package:memora/presentation/shared/primitives/displays/app_icon.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: AppStrings.maintenanceTitle,
      body: AppErrorState(
        title: AppStrings.maintenanceTitle,
        message: AppStrings.maintenanceMessage,
        icon: AppIcon(Icons.build_circle_outlined),
      ),
      constrainBody: true,
    );
  }
}
