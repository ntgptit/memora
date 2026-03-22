import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memora/core/di/core_providers.dart';
import 'package:memora/core/di/service_providers.dart';
import 'package:memora/core/services/bottom_sheet_service.dart';
import 'package:memora/core/services/dialog_service.dart';
import 'package:memora/core/services/navigation_service.dart';
import 'package:memora/core/services/snackbar_service.dart';

void main() {
  test('core and service providers expose app-wide keys and ui services', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final navigatorKey = container.read(rootNavigatorKeyProvider);
    final messengerKey = container.read(rootScaffoldMessengerKeyProvider);
    final navigationService = container.read(navigationServiceProvider);
    final dialogService = container.read(dialogServiceProvider);
    final bottomSheetService = container.read(bottomSheetServiceProvider);
    final snackbarService = container.read(snackbarServiceProvider);

    expect(navigatorKey, isA<GlobalKey<NavigatorState>>());
    expect(messengerKey, isA<GlobalKey<ScaffoldMessengerState>>());
    expect(navigationService, isA<NavigationService>());
    expect(dialogService, isA<DialogService>());
    expect(bottomSheetService, isA<BottomSheetService>());
    expect(snackbarService, isA<SnackbarService>());

    expect(navigationService.navigatorKey, same(navigatorKey));
    expect(dialogService.navigatorKey, same(navigatorKey));
    expect(bottomSheetService.navigatorKey, same(navigatorKey));
    expect(snackbarService.messengerKey, same(messengerKey));
  });
}
