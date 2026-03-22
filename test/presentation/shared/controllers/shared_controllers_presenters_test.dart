import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memora/core/enums/snackbar_type.dart';
import 'package:memora/core/enums/sort_direction.dart';
import 'package:memora/presentation/shared/controllers/app_debounce_controller.dart';
import 'package:memora/presentation/shared/controllers/app_pagination_controller.dart';
import 'package:memora/presentation/shared/controllers/app_search_controller.dart';
import 'package:memora/presentation/shared/controllers/app_selection_controller.dart';
import 'package:memora/presentation/shared/presenters/ui_action.dart';
import 'package:memora/presentation/shared/presenters/ui_filter_item.dart';
import 'package:memora/presentation/shared/presenters/ui_menu_item.dart';
import 'package:memora/presentation/shared/presenters/ui_message.dart';
import 'package:memora/presentation/shared/presenters/ui_sort_item.dart';

void main() {
  group('shared controllers', () {
    test('AppDebounceController flushes scheduled work immediately', () {
      final controller = AppDebounceController();
      var executed = false;

      controller.run(() {
        executed = true;
      }, duration: const Duration(seconds: 1));

      expect(controller.isActive, isTrue);

      controller.flush(() {
        executed = true;
      });

      expect(executed, isTrue);
      expect(controller.isActive, isFalse);
    });

    test('AppSearchController tracks query, submit, and clear', () {
      final controller = AppSearchController(initialQuery: 'deck');

      controller.updateQuery('flashcard');
      controller.submit();

      expect(controller.query, 'flashcard');
      expect(controller.submittedQuery, 'flashcard');
      expect(controller.hasQuery, isTrue);

      controller.clear();

      expect(controller.query, isEmpty);
      expect(controller.submittedQuery, isEmpty);
      expect(controller.hasQuery, isFalse);

      controller.dispose();
    });

    test('AppPaginationController advances pages and resets', () {
      final controller = AppPaginationController(pageSize: 20);

      controller.startLoading();
      controller.completePage(receivedItemCount: 20);

      expect(controller.nextPage, 2);
      expect(controller.loadedItemCount, 20);
      expect(controller.canLoadMore, isTrue);
      expect(
        controller.shouldLoadMore(
          pixels: 820,
          maxScrollExtent: 1000,
          threshold: 200,
        ),
        isTrue,
      );

      controller.startLoading();
      controller.fail();
      controller.reset();

      expect(controller.nextPage, 1);
      expect(controller.loadedItemCount, 0);
      expect(controller.hasMore, isTrue);
      expect(controller.isLoading, isFalse);
    });

    test('AppSelectionController toggles and clears selected values', () {
      final controller = AppSelectionController<int>([1, 2]);

      controller.toggle(2);
      controller.select(3);
      controller.selectAll(const [3, 4, 5]);

      expect(controller.selected, {1, 3, 4, 5});
      expect(controller.count, 4);

      controller.replaceAll(const [8, 9]);
      expect(controller.selected, {8, 9});

      controller.clear();
      expect(controller.isEmpty, isTrue);
    });
  });

  group('shared presenters', () {
    test('UiAction exposes enabled state and copyWith', () {
      final action = UiAction(
        label: 'Save',
        icon: Icons.save_outlined,
        onPressed: () {},
      );
      final updated = action.copyWith(label: 'Archive', destructive: true);

      expect(action.isEnabled, isTrue);
      expect(updated.label, 'Archive');
      expect(updated.destructive, isTrue);
      expect(updated.icon, Icons.save_outlined);
    });

    test('UiMessage reports whether it has an action', () {
      final message = UiMessage(
        message: 'Saved',
        type: SnackbarType.success,
        actionLabel: 'Undo',
        onActionPressed: () {},
      );
      final updated = message.copyWith(title: 'Done');

      expect(message.hasAction, isTrue);
      expect(updated.title, 'Done');
      expect(updated.type, SnackbarType.success);
    });

    test('UiFilterItem copyWith preserves generic value', () {
      final filter = UiFilterItem<String>(
        label: 'Due today',
        value: 'due',
        selected: true,
        count: 4,
      );
      final updated = filter.copyWith(label: 'All', selected: false);

      expect(updated.label, 'All');
      expect(updated.value, 'due');
      expect(updated.selected, isFalse);
      expect(updated.count, 4);
    });

    test('UiSortItem copyWith updates direction and selection', () {
      final item = UiSortItem<String>(label: 'Name', value: 'name');
      final updated = item.copyWith(
        direction: SortDirection.desc,
        selected: true,
      );

      expect(updated.value, 'name');
      expect(updated.direction, SortDirection.desc);
      expect(updated.selected, isTrue);
    });

    test('UiMenuItem copyWith updates semantic flags', () {
      final item = UiMenuItem<String>(
        label: 'Delete',
        value: 'delete',
        subtitle: 'Permanent action',
      );
      final updated = item.copyWith(destructive: true, enabled: false);

      expect(updated.label, 'Delete');
      expect(updated.subtitle, 'Permanent action');
      expect(updated.destructive, isTrue);
      expect(updated.enabled, isFalse);
    });
  });
}
