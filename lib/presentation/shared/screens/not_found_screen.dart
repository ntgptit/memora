import 'package:flutter/material.dart';
import 'package:memora/core/config/app_strings.dart';
import 'package:memora/presentation/shared/composites/states/app_empty_state.dart';
import 'package:memora/presentation/shared/layouts/app_scaffold.dart';
import 'package:memora/presentation/shared/primitives/displays/app_icon.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: AppStrings.notFoundTitle,
      body: AppEmptyState(
        title: AppStrings.notFoundTitle,
        message: AppStrings.notFoundMessage,
        icon: AppIcon(Icons.search_off_rounded),
      ),
      constrainBody: true,
    );
  }
}
