import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memora/core/theme/app_theme.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/composites/forms/app_submit_bar.dart';
import 'package:memora/presentation/shared/layouts/app_dashboard_layout.dart';
import 'package:memora/presentation/shared/layouts/app_detail_page_layout.dart';
import 'package:memora/presentation/shared/layouts/app_form_page_layout.dart';
import 'package:memora/presentation/shared/layouts/app_list_page_layout.dart';
import 'package:memora/presentation/shared/layouts/app_nested_scaffold.dart';
import 'package:memora/presentation/shared/layouts/app_scaffold.dart';
import 'package:memora/presentation/shared/layouts/app_scroll_view.dart';
import 'package:memora/presentation/shared/layouts/app_split_view_layout.dart';
import 'package:memora/presentation/shared/layouts/app_study_layout.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_primary_button.dart';
import 'package:memora/presentation/shared/screens/maintenance_screen.dart';
import 'package:memora/presentation/shared/screens/not_found_screen.dart';
import 'package:memora/presentation/shared/screens/offline_screen.dart';
import 'package:memora/presentation/shared/screens/splash_screen.dart';

void main() {
  Widget wrapWithApp(Widget child, {Size size = const Size(390, 844)}) {
    return MaterialApp(
      theme: AppTheme.light(screenInfo: ScreenInfo.fromSize(size)),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );
  }

  testWidgets('AppScaffold and shared layouts render composed content', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrapWithApp(
        AppScaffold(
          title: 'Scaffold title',
          header: const Text('Header'),
          body: const Text('Body'),
          footer: const Text('Footer'),
          actions: const [Text('Action')],
        ),
      ),
    );

    expect(find.text('Scaffold title'), findsOneWidget);
    expect(find.text('Header'), findsOneWidget);
    expect(find.text('Body'), findsOneWidget);
    expect(find.text('Footer'), findsOneWidget);
    expect(find.text('Action'), findsOneWidget);

    await tester.pumpWidget(
      wrapWithApp(const AppNestedScaffold(body: Text('Nested body'))),
    );
    expect(find.text('Nested body'), findsOneWidget);

    await tester.pumpWidget(
      wrapWithApp(const AppScrollView(child: Text('Scroll content'))),
    );
    expect(find.text('Scroll content'), findsOneWidget);

    await tester.pumpWidget(
      wrapWithApp(
        const AppSplitViewLayout(
          primary: Text('Primary panel'),
          secondary: Text('Secondary panel'),
        ),
      ),
    );
    expect(find.text('Primary panel'), findsOneWidget);
    expect(find.text('Secondary panel'), findsOneWidget);
  });

  testWidgets('page layouts render their semantic regions', (tester) async {
    final submitBar = AppSubmitBar(
      primaryAction: AppPrimaryButton(text: 'Save', onPressed: () {}),
    );

    await tester.pumpWidget(
      wrapWithApp(
        AppListPageLayout(
          title: const Text('Deck list'),
          subtitle: const Text('Due items'),
          filters: const Text('Filters'),
          actions: const [Text('Refresh')],
          body: const Text('List body'),
        ),
      ),
    );
    expect(find.text('Deck list'), findsOneWidget);
    expect(find.text('Filters'), findsOneWidget);
    expect(find.text('List body'), findsOneWidget);

    await tester.pumpWidget(
      wrapWithApp(
        AppDetailPageLayout(
          title: const Text('Deck detail'),
          subtitle: const Text('Overview'),
          actions: const [Text('Edit')],
          body: const Text('Detail body'),
          sidePanel: const Text('Detail side panel'),
        ),
      ),
    );
    expect(find.text('Deck detail'), findsOneWidget);
    expect(find.text('Detail body'), findsOneWidget);
    expect(find.text('Detail side panel'), findsOneWidget);

    await tester.pumpWidget(
      wrapWithApp(
        AppFormPageLayout(
          title: const Text('Deck form'),
          sections: const [Text('Section A'), Text('Section B')],
          submitBar: submitBar,
        ),
      ),
    );
    expect(find.text('Deck form'), findsOneWidget);
    expect(find.text('Section A'), findsOneWidget);
    expect(find.text('Save'), findsOneWidget);

    await tester.pumpWidget(
      wrapWithApp(
        const AppDashboardLayout(
          header: Text('Dashboard header'),
          summary: Text('Dashboard summary'),
          content: Text('Dashboard content'),
          sidebar: Text('Dashboard sidebar'),
        ),
      ),
    );
    expect(find.text('Dashboard summary'), findsOneWidget);
    expect(find.text('Dashboard content'), findsOneWidget);
    expect(find.text('Dashboard sidebar'), findsOneWidget);

    await tester.pumpWidget(
      wrapWithApp(
        const AppStudyLayout(
          header: Text('Study header'),
          flashcard: Text('Flashcard'),
          controls: Text('Study controls'),
          sidePanel: Text('Study notes'),
        ),
      ),
    );
    expect(find.text('Study header'), findsOneWidget);
    expect(find.text('Flashcard'), findsOneWidget);
    expect(find.text('Study controls'), findsOneWidget);
    expect(find.text('Study notes'), findsOneWidget);
  });

  testWidgets('shared system screens render expected states', (tester) async {
    await tester.pumpWidget(wrapWithApp(const SplashScreen()));
    expect(find.text('Memora'), findsOneWidget);
    expect(find.text('Preparing your learning workspace'), findsOneWidget);

    await tester.pumpWidget(wrapWithApp(const NotFoundScreen()));
    expect(find.text('Page not found'), findsAtLeastNWidgets(1));
    expect(find.text('The requested page does not exist.'), findsOneWidget);

    await tester.pumpWidget(wrapWithApp(const MaintenanceScreen()));
    expect(find.text('Maintenance'), findsAtLeastNWidgets(1));
    expect(find.text('The system is temporarily unavailable.'), findsOneWidget);

    await tester.pumpWidget(wrapWithApp(const OfflineScreen()));
    expect(find.text('You are offline'), findsAtLeastNWidgets(1));
    expect(
      find.text('Check your internet connection and try again.'),
      findsOneWidget,
    );
  });
}
