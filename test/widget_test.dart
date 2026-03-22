import 'package:flutter_test/flutter_test.dart';
import 'package:memora/app/app.dart';
import 'package:memora/core/config/app_strings.dart';

void main() {
  testWidgets('Memora dashboard screen renders overview', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.dashboardSummaryTitle), findsOneWidget);
    expect(find.text(AppStrings.dashboardVerbsDeckTitle), findsOneWidget);
  });
}
