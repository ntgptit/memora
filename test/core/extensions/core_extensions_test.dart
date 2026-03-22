import 'package:flutter_test/flutter_test.dart';
import 'package:memora/core/extensions/date_time_ext.dart';
import 'package:memora/core/extensions/duration_ext.dart';
import 'package:memora/core/extensions/iterable_ext.dart';
import 'package:memora/core/extensions/list_ext.dart';
import 'package:memora/core/extensions/num_ext.dart';
import 'package:memora/core/extensions/string_ext.dart';

void main() {
  group('String extensions', () {
    test('nullable helpers normalize blank values', () {
      String? blank = '   ';
      String? value = '  Memora  ';

      expect(blank.isBlank, isTrue);
      expect(blank.hasText, isFalse);
      expect(blank.trimmedOrNull, isNull);
      expect(value.hasText, isTrue);
      expect(value.trimmedOrNull, 'Memora');
      expect(value.orEmpty, '  Memora  ');
    });

    test('string helpers format content', () {
      expect('memora'.capitalized, 'Memora');
      expect('  spaced   text '.normalizedWhitespace, 'spaced text');
      expect('flash card study'.capitalizedWords, 'Flash Card Study');
      expect('memora'.equalsIgnoreCase(' MEMORA '), isTrue);
      expect('flash card'.initials(), 'FC');
      expect('Memora study mode'.truncated(maxLength: 10), 'Memora ...');
    });
  });

  group('Iterable and list extensions', () {
    test('iterable helpers expose safe accessors', () {
      const values = [1, 2, 2, 3];
      expect(values.firstOrNull, 1);
      expect(values.lastOrNull, 3);
      expect(values.unique, [1, 2, 3]);
      expect(values.separatedBy(0), [1, 0, 2, 0, 2, 0, 3]);
    });

    test('nullable iterables filter null values', () {
      const values = <int?>[1, null, 2, null, 3];
      expect(values.whereNotNull, [1, 2, 3]);
    });

    test('list helpers keep immutable style updates', () {
      const values = [1, 2, 3];
      expect(values.safeElementAt(1), 2);
      expect(values.safeElementAt(8), isNull);
      expect(values.replacingAt(1, 4), [1, 4, 3]);
      expect(values.toggled(2), [1, 3]);
      expect(values.toggled(4), [1, 2, 3, 4]);
    });
  });

  group('DateTime, Duration, and num extensions', () {
    test('date helpers derive calendar boundaries', () {
      final value = DateTime(2026, 3, 22, 15, 30, 45);

      expect(value.dateOnly, DateTime(2026, 3, 22));
      expect(value.startOfDay, DateTime(2026, 3, 22));
      expect(value.endOfDay, DateTime(2026, 3, 22, 23, 59, 59, 999, 999));
      expect(value.startOfWeek(), DateTime(2026, 3, 16));
      expect(value.endOfWeek(), DateTime(2026, 3, 22, 23, 59, 59, 999, 999));
      expect(value.isToday(now: DateTime(2026, 3, 22, 1)), isTrue);
      expect(value.daysUntil(DateTime(2026, 3, 25)), 3);
    });

    test('duration helpers format readable text', () {
      const duration = Duration(hours: 1, minutes: 2, seconds: 3);
      expect(duration.totalSeconds, 3723);
      expect(duration.totalMinutes, 62);
      expect(duration.toClockText(), '01:02:03');
      expect(duration.toShortText(), '1h 2m');
      expect(Duration.zero.isZeroDuration, isTrue);
    });

    test('num helpers clamp and convert units', () {
      expect(12.clampToDouble(0, 10), 10);
      expect(12.clampToInt(0, 10), 10);
      expect(5.isBetween(1, 10), isTrue);
      expect(2.percentageLabelOf(8), '25%');
      expect(250.milliseconds, const Duration(milliseconds: 250));
      expect(1.5.seconds, const Duration(milliseconds: 1500));
    });
  });
}
