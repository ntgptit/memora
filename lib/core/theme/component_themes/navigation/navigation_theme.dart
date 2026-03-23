import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/dimension_theme_ext.dart';

abstract final class MemoraNavigationTheme {
  static NavigationBarThemeData bar({
    required ColorScheme colorScheme,
    required DimensionThemeExt dimensions,
    required TextTheme textTheme,
  }) {
    return NavigationBarThemeData(
      height: dimensions.componentSize.bottomBarHeight,
      backgroundColor: colorScheme.surface,
      indicatorColor: colorScheme.secondaryContainer,
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final isSelected = states.contains(WidgetState.selected);
        return textTheme.labelMedium?.copyWith(
          color: isSelected
              ? colorScheme.onSurface
              : colorScheme.onSurfaceVariant,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final isSelected = states.contains(WidgetState.selected);
        return IconThemeData(
          size: dimensions.iconSize.lg,
          color: isSelected
              ? colorScheme.onSecondaryContainer
              : colorScheme.onSurfaceVariant,
        );
      }),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    );
  }

  static NavigationRailThemeData rail({
    required ColorScheme colorScheme,
    required DimensionThemeExt dimensions,
    required TextTheme textTheme,
  }) {
    return NavigationRailThemeData(
      backgroundColor: colorScheme.surface,
      indicatorColor: colorScheme.secondaryContainer,
      minWidth: dimensions.componentSize.navigationRailWidth,
      minExtendedWidth: dimensions.componentSize.navigationRailWidth * 2.75,
      selectedIconTheme: IconThemeData(
        size: dimensions.iconSize.lg,
        color: colorScheme.onSecondaryContainer,
      ),
      unselectedIconTheme: IconThemeData(
        size: dimensions.iconSize.lg,
        color: colorScheme.onSurfaceVariant,
      ),
      selectedLabelTextStyle: textTheme.labelMedium?.copyWith(
        color: colorScheme.onSurface,
      ),
      unselectedLabelTextStyle: textTheme.labelMedium?.copyWith(
        color: colorScheme.onSurfaceVariant,
      ),
      useIndicator: true,
    );
  }
}
