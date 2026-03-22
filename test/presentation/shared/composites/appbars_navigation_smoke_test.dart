import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memora/core/theme/app_theme.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/composites/appbars/app_search_top_bar.dart';
import 'package:memora/presentation/shared/composites/appbars/app_selection_top_bar.dart';
import 'package:memora/presentation/shared/composites/appbars/app_top_bar.dart';
import 'package:memora/presentation/shared/composites/navigation/app_breadcrumb.dart';
import 'package:memora/presentation/shared/composites/navigation/app_bottom_navigation.dart';
import 'package:memora/presentation/shared/composites/navigation/app_navigation_rail.dart';
import 'package:memora/presentation/shared/composites/navigation/app_page_header.dart';
import 'package:memora/presentation/shared/composites/navigation/app_tab_bar.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_text_button.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';
import 'package:memora/presentation/shared/primitives/text/app_title_text.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: AppTheme.light(screenInfo: const ScreenInfo.fallback()),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  testWidgets('navigation composites render', (tester) async {
    await tester.pumpWidget(
      wrap(
        AppPageHeader(
          breadcrumb: AppBreadcrumb(
            items: const [
              AppBreadcrumbItem(label: 'Home'),
              AppBreadcrumbItem(label: 'Library'),
            ],
          ),
          title: const AppTitleText(text: 'Deck overview'),
          subtitle: const AppBodyText(text: '12 cards ready'),
          actions: [AppTextButton(text: 'Share', onPressed: () {})],
        ),
      ),
    );

    expect(find.text('Home'), findsWidgets);
    expect(find.text('Library'), findsWidgets);
    expect(find.text('Deck overview'), findsOneWidget);
    expect(find.text('12 cards ready'), findsOneWidget);
    expect(find.text('Share'), findsOneWidget);

    await tester.pumpWidget(
      wrap(
        DefaultTabController(
          length: 2,
          child: AppTabBar(
            tabs: const [
              Tab(text: 'Study'),
              Tab(text: 'Review'),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Study'), findsOneWidget);
    expect(find.text('Review'), findsOneWidget);

    await tester.pumpWidget(
      wrap(
        Scaffold(
          appBar: const AppTopBar(
            title: AppTitleText(text: 'Top bar'),
            subtitle: AppBodyText(text: 'Generic app bar'),
          ),
        ),
      ),
    );

    expect(find.text('Top bar'), findsOneWidget);
    expect(find.text('Generic app bar'), findsOneWidget);

    final searchController = TextEditingController(text: 'flashcards');
    await tester.pumpWidget(
      wrap(
        Scaffold(
          appBar: AppSearchTopBar(
            title: const AppTitleText(text: 'Search deck'),
            controller: searchController,
            onChanged: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Search deck'), findsOneWidget);
    expect(find.text('flashcards'), findsOneWidget);
    searchController.dispose();

    await tester.pumpWidget(
      wrap(
        Scaffold(
          appBar: AppSelectionTopBar(
            selectedCount: 3,
            actions: [AppTextButton(text: 'Done', onPressed: () {})],
          ),
        ),
      ),
    );

    expect(find.text('3 selected'), findsOneWidget);
    expect(find.text('Done'), findsOneWidget);

    await tester.pumpWidget(
      wrap(
        Scaffold(
          bottomNavigationBar: AppBottomNavigation(
            selectedIndex: 0,
            onDestinationSelected: (_) {},
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.library_books_rounded),
                label: 'Library',
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Home'), findsWidgets);
    expect(find.text('Library'), findsWidgets);

    await tester.pumpWidget(
      wrap(
        Scaffold(
          body: AppNavigationRail(
            selectedIndex: 0,
            onDestinationSelected: (_) {},
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.home_rounded),
                label: Text('Home'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.library_books_rounded),
                label: Text('Library'),
              ),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Home'), findsWidgets);
    expect(find.text('Library'), findsWidgets);
  });
}
