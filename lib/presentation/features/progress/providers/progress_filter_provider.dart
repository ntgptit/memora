import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'progress_filter_provider.g.dart';

enum ProgressPeriod { today, week, month }

@immutable
class ProgressFilterState {
  const ProgressFilterState({required this.period});

  final ProgressPeriod period;

  ProgressFilterState copyWith({ProgressPeriod? period}) {
    return ProgressFilterState(period: period ?? this.period);
  }
}

@Riverpod(keepAlive: true)
class ProgressFilterController extends _$ProgressFilterController {
  @override
  ProgressFilterState build() {
    return const ProgressFilterState(period: ProgressPeriod.week);
  }

  void setPeriod(ProgressPeriod period) {
    state = state.copyWith(period: period);
  }
}
