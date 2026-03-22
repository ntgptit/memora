import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memora/core/enums/app_language.dart';
import 'package:memora/core/enums/app_locale.dart';
import 'package:memora/core/enums/app_theme_type.dart';
import 'package:memora/core/enums/dialog_type.dart';
import 'package:memora/core/enums/filter_operator.dart';
import 'package:memora/core/enums/loading_status.dart';
import 'package:memora/core/enums/snackbar_type.dart';
import 'package:memora/core/enums/sort_direction.dart';

void main() {
  group('App language and locale', () {
    test('parse from code and expose metadata', () {
      expect(AppLanguage.fromCode('VI'), AppLanguage.vietnamese);
      expect(AppLanguage.korean.nativeLabel, '한국어');

      expect(AppLocale.fromLanguageCode('ko'), AppLocale.ko);
      expect(AppLocale.fromLanguageCode('unknown'), AppLocale.en);
      expect(AppLocale.fromLocale(const Locale('vi')), AppLocale.vi);
      expect(AppLocale.vi.locale, const Locale('vi'));
      expect(AppLocale.en.isDefault, isTrue);
    });
  });

  group('Theme and loading enums', () {
    test('theme type parses safely', () {
      expect(AppThemeType.fromName('dark'), AppThemeType.dark);
      expect(AppThemeType.fromName('other'), AppThemeType.system);
      expect(AppThemeType.light.isLight, isTrue);
      expect(AppThemeType.system.isSystem, isTrue);
    });

    test('loading status flags stay semantic', () {
      expect(LoadingStatus.loading.isLoading, isTrue);
      expect(LoadingStatus.success.isTerminal, isTrue);
      expect(LoadingStatus.idle.isTerminal, isFalse);
    });
  });

  group('UI intent enums', () {
    test('snackbar and dialog semantics are exposed', () {
      expect(SnackbarType.error.defaultDuration, const Duration(seconds: 4));
      expect(SnackbarType.success.isPositive, isTrue);
      expect(DialogType.error.isDestructive, isTrue);
      expect(DialogType.confirm.needsExplicitAction, isTrue);
    });

    test('sorting and filtering helpers reduce switch noise', () {
      expect(SortDirection.asc.toggled, SortDirection.desc);
      expect(SortDirection.desc.applyToComparison(4), -4);
      expect(FilterOperator.fromName('contains'), FilterOperator.contains);
      expect(FilterOperator.greaterThan.isRangeOperator, isTrue);
      expect(FilterOperator.contains.symbol, '~');
    });
  });
}
