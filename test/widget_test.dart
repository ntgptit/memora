import 'package:flutter_test/flutter_test.dart';
import 'package:memora/app/app.dart';

void main() {
  testWidgets('Memora dashboard shell renders', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.text('Dashboard foundation'), findsOneWidget);
    expect(find.text('Runtime snapshot'), findsOneWidget);
  });
}
