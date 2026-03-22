import 'package:flutter_test/flutter_test.dart';
import 'package:memora/app/app.dart';

void main() {
  testWidgets('Memora dashboard screen renders overview', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.text("Today's overview"), findsOneWidget);
    expect(find.text('Korean verbs'), findsOneWidget);
  });
}
