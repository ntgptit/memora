import 'package:flutter/material.dart';
import 'package:memora/core/config/app_strings.dart';
import 'package:memora/presentation/shared/layouts/app_scaffold.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: AppStrings.maintenanceTitle,
      body: Center(child: Text(AppStrings.maintenanceMessage)),
    );
  }
}
