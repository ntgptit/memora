import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:memora/core/config/app_strings.dart';
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
      focusLabel: AppStrings.dashboardReviewFocusLabel,
      reviewedToday: state.reviewedToday + reviewedDeck.dueCardCount,
      dueDecks: state.dueDecks
          .where((deck) => deck.id != deckId)
          .toList(growable: false),
    );

    if (state.dueDecks.isEmpty) {
      state = state.copyWith(
        focusLabel: AppStrings.dashboardCompleteFocusLabel,
      );
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
      focusLabel: AppStrings.dashboardCaptureFocusLabel,
    );
  }

  void applyQuickAction(String actionId) {
    final quickAction = _findQuickAction(actionId);
    if (quickAction == null) {
      return;
    }

    state = state.copyWith(focusLabel: quickAction.focusLabel);
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
      focusLabel: AppStrings.dashboardLaterFocusLabel,
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
      if (action.id == actionId) {
        return action;
      }
    }
    return null;
  }
}
