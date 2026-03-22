import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show ProviderOrFamily;

extension WidgetRefExt on WidgetRef {
  void invalidateAll(Iterable<ProviderOrFamily> providers) {
    for (final provider in providers) {
      invalidate(provider);
    }
  }
}
