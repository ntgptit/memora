import 'package:memora/app/app_providers.dart';
import 'package:memora/l10n/app_localizations.dart';
import 'package:memora/presentation/features/progress/providers/progress_filter_provider.dart';
import 'package:memora/presentation/features/progress/providers/progress_sample_factory.dart';
import 'package:memora/presentation/features/progress/providers/progress_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'progress_provider.g.dart';

@Riverpod(keepAlive: false)
class ProgressController extends _$ProgressController {
  @override
  ProgressState build() {
    final filter = ref.watch(progressFilterControllerProvider);
    final locale = ref.watch(appLocaleProvider);
    final l10n = lookupAppLocalizations(locale);

    return buildSampleProgressState(period: filter.period, l10n: l10n);
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
