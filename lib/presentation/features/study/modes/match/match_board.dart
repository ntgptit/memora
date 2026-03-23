import 'package:flutter/material.dart';
import 'package:memora/core/theme/extensions/theme_context_ext.dart';
import 'package:memora/l10n/l10n.dart';
import 'package:memora/presentation/features/study/modes/match/match_mode_provider.dart';
import 'package:memora/presentation/features/study/modes/match/match_option_tile.dart';
import 'package:memora/presentation/features/study/providers/study_session_state.dart';
import 'package:memora/presentation/shared/composites/cards/app_info_card.dart';
import 'package:memora/presentation/shared/layouts/app_split_view_layout.dart';
import 'package:memora/presentation/shared/primitives/displays/app_chip.dart';
import 'package:memora/presentation/shared/primitives/text/app_body_text.dart';

class MatchBoard extends StatelessWidget {
  const MatchBoard({
    super.key,
    required this.state,
    required this.onSelectLeft,
    required this.onSelectRight,
    required this.onRemovePair,
  });

  final MatchModeState state;
  final ValueChanged<String> onSelectLeft;
  final ValueChanged<String> onSelectRight;
  final ValueChanged<StudyMatchedPair> onRemovePair;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final pairsByLeft = <String, StudyMatchedPair>{
      for (final pair in state.matchedPairs) pair.leftId: pair,
    };
    final pairsByRight = <String, StudyMatchedPair>{
      for (final pair in state.matchedPairs) pair.rightId: pair,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppInfoCard(
          title: state.item.prompt,
          subtitle: state.item.instruction,
          leading: const Icon(Icons.hub_rounded),
        ),
        SizedBox(height: context.spacing.lg),
        AppSplitViewLayout(
          primary: _OptionColumn(
            title: l10n.studyMatchLeftColumnTitle,
            options: [for (final pair in state.item.matchPairs) pair.left],
            selectedId: state.selectedLeftId,
            matchedLookup: pairsByLeft,
            onTap: onSelectLeft,
          ),
          secondary: _OptionColumn(
            title: l10n.studyMatchRightColumnTitle,
            options: [for (final pair in state.item.matchPairs) pair.right],
            selectedId: state.selectedRightId,
            matchedLookup: pairsByRight,
            onTap: onSelectRight,
          ),
        ),
        if (state.matchedPairs.isNotEmpty) ...[
          SizedBox(height: context.spacing.lg),
          AppInfoCard(
            title: l10n.studyMatchPairsTitle,
            subtitle: l10n.studyMatchPairsSubtitle,
            child: Wrap(
              spacing: context.spacing.sm,
              runSpacing: context.spacing.sm,
              children: [
                for (final pair in state.matchedPairs)
                  AppChip(
                    label: Text(_pairLabel(pair)),
                    onDeleted: () => onRemovePair(pair),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  String _lookupLabel(String optionId) {
    for (final pair in state.item.matchPairs) {
      if (pair.left.id == optionId) {
        return pair.left.label;
      }
      if (pair.right.id == optionId) {
        return pair.right.label;
      }
    }
    return optionId;
  }

  String _pairLabel(StudyMatchedPair pair) {
    return '${_lookupLabel(pair.leftId)} → ${_lookupLabel(pair.rightId)}';
  }
}

class _OptionColumn extends StatelessWidget {
  const _OptionColumn({
    required this.title,
    required this.options,
    required this.selectedId,
    required this.matchedLookup,
    required this.onTap,
  });

  final String title;
  final List<StudyMatchOption> options;
  final String? selectedId;
  final Map<String, StudyMatchedPair> matchedLookup;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBodyText(text: title),
        SizedBox(height: context.spacing.sm),
        for (final option in options) ...[
          MatchOptionTile(
            option: option,
            selected: option.id == selectedId,
            matched: matchedLookup.containsKey(option.id),
            onTap: () => onTap(option.id),
          ),
          if (option != options.last) SizedBox(height: context.spacing.sm),
        ],
      ],
    );
  }
}
