import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:memora/presentation/features/dashboard/providers/dashboard_l10n.dart';
import 'package:memora/presentation/features/dashboard/providers/dashboard_state.dart';

part 'dashboard_provider.g.dart';

@Riverpod(keepAlive: true)
class DashboardController extends _$DashboardController {
  @override
  DashboardState build() {
    return DashboardState.sample();
  }

  void refresh() {
    state = DashboardState.sample();
  }

  void startDeck(String deckId) {
    final reviewedDeck = _findDeck(deckId);
    if (reviewedDeck == null) {
      return;
    }

    state = state.copyWith(
      focus: DashboardFocus.reviewSprint,
      reviewedToday: state.reviewedToday + reviewedDeck.dueCardCount,
      dueDecks: state.dueDecks
          .where((deck) => deck.id != deckId)
          .toList(growable: false),
    );

    if (state.dueDecks.isEmpty) {
      state = state.copyWith(focus: DashboardFocus.inboxClear);
    }
  }

  void snoozeDeck(String deckId) {
    final selectedDeck = _findDeck(deckId);
    if (selectedDeck == null) {
      return;
    }

    final remainingDecks = state.dueDecks
        .where((deck) => deck.id != deckId)
        .toList(growable: true);
    remainingDecks.add(selectedDeck.copyWith(isPriority: false));

    state = state.copyWith(
      dueDecks: remainingDecks,
      focus: DashboardFocus.captureMode,
    );
  }

  void applyQuickAction(String actionId) {
    final quickAction = _findQuickAction(actionId);
    if (quickAction == null) {
      return;
    }

    state = state.copyWith(focus: quickAction.type.focus);
  }

  void deferQuickAction(String actionId) {
    final quickAction = _findQuickAction(actionId);
    if (quickAction == null) {
      return;
    }

    final deferredActions = state.quickActions
        .where((action) => action.id != actionId)
        .toList(growable: true);
    deferredActions.add(quickAction);

    state = state.copyWith(
      quickActions: deferredActions,
      focus: DashboardFocus.laterQueue,
    );
  }

  DashboardDueDeckItem? _findDeck(String deckId) {
    for (final deck in state.dueDecks) {
      if (deck.id == deckId) {
        return deck;
      }
    }
    return null;
  }

  DashboardQuickActionItem? _findQuickAction(String actionId) {
    for (final action in state.quickActions) {
      if (action.type.name == actionId) {
        return action;
      }
    }
    return null;
  }
}
