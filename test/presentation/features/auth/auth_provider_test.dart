import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memora/core/di/core_providers.dart';
import 'package:memora/core/di/repository_providers.dart';
import 'package:memora/presentation/features/auth/providers/auth_provider.dart';
import 'package:memora/presentation/features/auth/providers/auth_state.dart';

import '../../../support/fake_auth_repository.dart';

void main() {
  test(
    'auth controller clears session when an expiration event is emitted',
    () async {
      final fakeRepository = FakeAuthRepository.authenticated();
      final container = ProviderContainer(
        overrides: [authRepositoryProvider.overrideWithValue(fakeRepository)],
      );
      addTearDown(container.dispose);

      container.read(authControllerProvider);
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      expect(
        container.read(authControllerProvider).sessionStatus,
        AuthSessionStatus.authenticated,
      );

      container.read(authSessionServiceProvider).notifyExpired();
      await Future<void>.delayed(Duration.zero);
      await Future<void>.delayed(Duration.zero);

      final state = container.read(authControllerProvider);
      expect(state.sessionStatus, AuthSessionStatus.unauthenticated);
      expect(state.notice, AuthNotice.sessionExpired);
      expect(fakeRepository.storedTokens, isNull);
    },
  );
}
