import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:memora/core/theme/app_theme.dart';
import 'package:memora/core/theme/responsive/screen_info.dart';
import 'package:memora/presentation/shared/mixins/dialog_mixin.dart';
import 'package:memora/presentation/shared/mixins/keyboard_dismiss_mixin.dart';
import 'package:memora/presentation/shared/mixins/loading_state_mixin.dart';
import 'package:memora/presentation/shared/mixins/pagination_mixin.dart';
import 'package:memora/presentation/shared/mixins/snackbar_mixin.dart';

void main() {
  Widget wrapWithApp(Widget child) {
    final router = GoRouter(
      routes: [GoRoute(path: '/', builder: (context, state) => child)],
    );
    return MaterialApp.router(
      theme: AppTheme.light(screenInfo: const ScreenInfo.fallback()),
      routerConfig: router,
    );
  }

  testWidgets('LoadingStateMixin toggles loading state around async work', (
    tester,
  ) async {
    await tester.pumpWidget(wrapWithApp(const _LoadingHarness()));

    expect(find.text('idle'), findsOneWidget);

    await tester.tap(find.text('Run loading'));
    await tester.pump();

    expect(find.text('loading'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 20));
    expect(find.text('idle'), findsOneWidget);
  });

  testWidgets('SnackbarMixin shows app snackbar content', (tester) async {
    await tester.pumpWidget(wrapWithApp(const _SnackbarHarness()));

    await tester.tap(find.text('Show snackbar'));
    await tester.pump();

    expect(find.text('Saved'), findsOneWidget);
  });

  testWidgets('DialogMixin shows confirm dialog and bottom sheet', (
    tester,
  ) async {
    await tester.pumpWidget(wrapWithApp(const _DialogHarness()));

    await tester.tap(find.text('Open confirm'));
    await tester.pumpAndSettle();

    expect(find.text('Delete deck'), findsOneWidget);

    await tester.tap(find.text('Confirm'));
    await tester.pumpAndSettle();

    expect(find.text('confirm:true'), findsOneWidget);
    expect(find.text('Open confirm'), findsOneWidget);

    await tester.tap(find.text('Open sheet'));
    await tester.pumpAndSettle();

    expect(find.text('Sheet title'), findsOneWidget);
    expect(find.text('Bottom sheet content'), findsOneWidget);
  });

  testWidgets('PaginationMixin requests load more near list end', (
    tester,
  ) async {
    var loadCount = 0;

    await tester.pumpWidget(
      wrapWithApp(
        Scaffold(
          body: SizedBox(
            height: 300,
            child: _PaginationHarness(
              onLoadMore: () {
                loadCount += 1;
              },
            ),
          ),
        ),
      ),
    );

    final state = tester.state<_PaginationHarnessState>(
      find.byType(_PaginationHarness),
    );
    state.jumpToEnd();
    await tester.pump();

    expect(loadCount, greaterThanOrEqualTo(1));
  });

  testWidgets('KeyboardDismissMixin dismisses focused field on outside tap', (
    tester,
  ) async {
    await tester.pumpWidget(wrapWithApp(const _KeyboardDismissHarness()));

    await tester.tap(find.byType(TextField));
    await tester.pump();

    expect(find.text('focused'), findsOneWidget);

    await tester.tap(find.text('Dismiss area'));
    await tester.pumpAndSettle();

    expect(find.text('unfocused'), findsOneWidget);
  });
}

class _LoadingHarness extends StatefulWidget {
  const _LoadingHarness();

  @override
  State<_LoadingHarness> createState() => _LoadingHarnessState();
}

class _LoadingHarnessState extends State<_LoadingHarness>
    with LoadingStateMixin<_LoadingHarness> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(isLoading ? 'loading' : 'idle'),
            ElevatedButton(
              onPressed: () {
                runWithLoading(() async {
                  await Future<void>.delayed(const Duration(milliseconds: 10));
                });
              },
              child: const Text('Run loading'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SnackbarHarness extends StatefulWidget {
  const _SnackbarHarness();

  @override
  State<_SnackbarHarness> createState() => _SnackbarHarnessState();
}

class _SnackbarHarnessState extends State<_SnackbarHarness>
    with SnackbarMixin<_SnackbarHarness> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showAppSnackbar(message: 'Saved');
          },
          child: const Text('Show snackbar'),
        ),
      ),
    );
  }
}

class _DialogHarness extends StatefulWidget {
  const _DialogHarness();

  @override
  State<_DialogHarness> createState() => _DialogHarnessState();
}

class _DialogHarnessState extends State<_DialogHarness>
    with DialogMixin<_DialogHarness> {
  String _result = 'idle';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_result),
            ElevatedButton(
              onPressed: () async {
                final confirmed = await showConfirmDialog(title: 'Delete deck');
                if (!mounted) {
                  return;
                }
                setState(() {
                  _result = 'confirm:$confirmed';
                });
              },
              child: const Text('Open confirm'),
            ),
            ElevatedButton(
              onPressed: () {
                showAppBottomSheet<void>(
                  title: 'Sheet title',
                  child: const Text('Bottom sheet content'),
                );
              },
              child: const Text('Open sheet'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaginationHarness extends StatefulWidget {
  const _PaginationHarness({required this.onLoadMore});

  final VoidCallback onLoadMore;

  @override
  State<_PaginationHarness> createState() => _PaginationHarnessState();
}

class _PaginationHarnessState extends State<_PaginationHarness>
    with PaginationMixin<_PaginationHarness> {
  @override
  void initState() {
    super.initState();
    setupPaginationListener(
      onLoadMore: () async {
        widget.onLoadMore();
      },
      threshold: 32,
    );
  }

  @override
  void dispose() {
    disposePaginationListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: paginationScrollController,
      itemCount: 60,
      itemExtent: 48,
      itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
    );
  }

  void jumpToEnd() {
    paginationScrollController.jumpTo(
      paginationScrollController.position.maxScrollExtent,
    );
  }
}

class _KeyboardDismissHarness extends StatefulWidget {
  const _KeyboardDismissHarness();

  @override
  State<_KeyboardDismissHarness> createState() =>
      _KeyboardDismissHarnessState();
}

class _KeyboardDismissHarnessState extends State<_KeyboardDismissHarness>
    with KeyboardDismissMixin<_KeyboardDismissHarness> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChanged);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChanged);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: withKeyboardDismiss(
        child: Builder(
          builder: (context) {
            final isFocused = _focusNode.hasFocus;
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isFocused ? 'focused' : 'unfocused'),
                  TextField(focusNode: _focusNode),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    color: Colors.transparent,
                    child: const Text('Dismiss area'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleFocusChanged() {
    if (mounted) {
      setState(() {});
    }
  }
}
