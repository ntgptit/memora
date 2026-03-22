import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memora/core/theme/app_theme.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';
import 'package:memora/presentation/shared/composites/forms/app_filter_bar.dart';
import 'package:memora/presentation/shared/composites/forms/app_form_section.dart';
import 'package:memora/presentation/shared/composites/forms/app_search_bar.dart';
import 'package:memora/presentation/shared/composites/forms/app_sort_bar.dart';
import 'package:memora/presentation/shared/composites/forms/app_submit_bar.dart';
import 'package:memora/presentation/shared/composites/lists/app_list_item.dart';
import 'package:memora/presentation/shared/composites/lists/app_reorderable_list_item.dart';
import 'package:memora/presentation/shared/composites/lists/app_section_list.dart';
import 'package:memora/presentation/shared/composites/lists/app_selectable_list_item.dart';
import 'package:memora/presentation/shared/composites/lists/app_swipe_list_item.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_secondary_button.dart';
import 'package:memora/presentation/shared/primitives/displays/app_chip.dart';
import 'package:memora/presentation/shared/primitives/text/app_text.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(screenInfo: const ScreenInfo.fallback()),
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  testWidgets('forms and lists composites render', (tester) async {
    await tester.pumpWidget(
      wrap(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSearchBar(
              label: 'Search',
              onChanged: (_) {},
              onFilterPressed: () {},
              onSortPressed: () {},
            ),
            const SizedBox(height: 16),
            AppFilterBar(
              title: const AppText(text: 'Filters'),
              filters: const [
                AppChip(label: Text('All')),
                AppChip(label: Text('Recent')),
              ],
              clearAction: const TextButton(
                onPressed: null,
                child: Text('Clear'),
              ),
            ),
            const SizedBox(height: 16),
            AppSortBar(
              title: const AppText(text: 'Sort'),
              sortOptions: const [
                AppChip(label: Text('Name')),
                AppChip(label: Text('Date')),
              ],
              directionToggle: const Icon(Icons.swap_vert_rounded),
            ),
            const SizedBox(height: 16),
            AppFormSection(
              title: const AppText(text: 'Section title'),
              subtitle: const AppText(text: 'Section subtitle'),
              leading: const Icon(Icons.folder_rounded),
              trailing: const Icon(Icons.more_horiz_rounded),
              footer: const AppText(text: 'Section footer'),
              child: const AppText(text: 'Section body'),
            ),
            const SizedBox(height: 16),
            AppSubmitBar(
              actions: const [
                AppSecondaryButton(text: 'Cancel'),
              ],
              primaryAction: const AppPrimaryButton(text: 'Save'),
            ),
            const SizedBox(height: 16),
            AppSectionList(
              sections: [
                AppListItem(
                  title: const AppText(text: 'List item'),
                  subtitle: const AppText(text: 'Subtitle'),
                  leading: const Icon(Icons.list_rounded),
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
                AppSelectableListItem(
                  title: const AppText(text: 'Selectable item'),
                  subtitle: const AppText(text: 'Selectable subtitle'),
                  selected: true,
                  onChanged: (_) {},
                ),
                AppReorderableListItem(
                  index: 0,
                  title: const AppText(text: 'Reorderable item'),
                  trailing: const Icon(Icons.chevron_right_rounded),
                ),
                AppSwipeListItem(
                  onDismissed: (_) {},
                  child: const AppListItem(
                    title: AppText(text: 'Swipe item'),
                    subtitle: AppText(text: 'Swipe subtitle'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

    expect(find.text('Search'), findsOneWidget);
    expect(find.text('Filters'), findsOneWidget);
    expect(find.text('Sort'), findsOneWidget);
    expect(find.text('Section title'), findsOneWidget);
    expect(find.text('Section body'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);
    expect(find.text('List item'), findsOneWidget);
    expect(find.text('Selectable item'), findsOneWidget);
    expect(find.text('Reorderable item'), findsOneWidget);
    expect(find.text('Swipe item'), findsOneWidget);
    expect(find.byType(AppSwipeListItem), findsOneWidget);
    expect(find.byType(AppReorderableListItem), findsOneWidget);
  });
}
