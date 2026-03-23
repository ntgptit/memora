import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/domain/entities/deck.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/shared/primitives/buttons/app_icon_button.dart';
import 'package:memora/presentation/shared/composites/forms/app_search_bar.dart';
import 'package:memora/presentation/shared/composites/forms/app_sort_bar.dart';
import 'package:memora/presentation/shared/primitives/displays/app_chip.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';

class DeckFilterBar extends StatelessWidget {
  const DeckFilterBar({
    super.key,
    required this.searchController,
    required this.focusNode,
    required this.sortBy,
    required this.isAscending,
    required this.onSearchChanged,
    required this.onClearSearch,
    required this.onSortByChanged,
    required this.onToggleSortDirection,
  });

  final TextEditingController searchController;
  final FocusNode focusNode;
  final DeckSortField sortBy;
  final bool isAscending;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;
  final ValueChanged<DeckSortField> onSortByChanged;
  final VoidCallback onToggleSortDirection;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppSearchBar(
          controller: searchController,
          focusNode: focusNode,
          hintText: context.l10n.deckSearchHint,
          onChanged: onSearchChanged,
          onSubmitted: onSearchChanged,
          onClear: onClearSearch,
        ),
        SizedBox(height: context.spacing.sm),
        AppSortBar(
          title: AppBodyText(text: context.l10n.deckSortTitle),
          directionToggle: AppIconButton(
            onPressed: onToggleSortDirection,
            tooltip: context.l10n.deckSortDirectionTooltip,
            icon: Icon(
              isAscending
                  ? Icons.arrow_upward_rounded
                  : Icons.arrow_downward_rounded,
            ),
          ),
          sortOptions: [
            for (final option in DeckSortField.values)
              AppChip(
                label: Text(_label(context, option)),
                selected: option == sortBy,
                onSelected: (_) => onSortByChanged(option),
              ),
          ],
        ),
      ],
    );
  }

  String _label(BuildContext context, DeckSortField sortBy) {
    switch (sortBy) {
      case DeckSortField.name:
        return context.l10n.deckSortByName;
      case DeckSortField.createdAt:
        return context.l10n.deckSortByCreatedAt;
      case DeckSortField.updatedAt:
        return context.l10n.deckSortByUpdatedAt;
    }
  }
}
