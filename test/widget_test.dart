import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memora/app/app.dart';
import 'package:memora/core/di/repository_providers.dart';

import 'support/fake_auth_repository.dart';

void main() {
  testWidgets('Memora dashboard screen renders overview', (tester) async {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(
          FakeAuthRepository.authenticated(),
        ),
      ],
    );
    addTearDown(container.dispose);

    await tester.pumpWidget(App(container: container));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text("Today's overview"), findsOneWidget);
    expect(find.text('Korean verbs'), findsOneWidget);
  });
}
