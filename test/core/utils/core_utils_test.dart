import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memora/core/utils/color_utils.dart';
import 'package:memora/core/utils/date_time_utils.dart';
import 'package:memora/core/utils/duration_utils.dart';
import 'package:memora/core/utils/file_utils.dart';
import 'package:memora/core/utils/list_utils.dart';
import 'package:memora/core/utils/map_utils.dart';
import 'package:memora/core/utils/number_utils.dart';
import 'package:memora/core/utils/object_utils.dart';
import 'package:memora/core/utils/string_utils.dart';
import 'package:memora/core/utils/url_utils.dart';
import 'package:memora/core/utils/validation_utils.dart';

void main() {
  group('StringUtils', () {
    test('normalizeWhitespace trims and collapses spaces', () {
      expect(
        StringUtils.normalizeWhitespace('  memora   flashcard  app '),
        'memora flashcard app',
      );
    });

    test('initials returns uppercased initials', () {
      expect(StringUtils.initials('memora study app'), 'MS');
    });

    test('truncate keeps max length with ellipsis', () {
      expect(StringUtils.truncate('flashcard', maxLength: 6), 'fla...');
    });
  });

  group('DateTimeUtils', () {
    test('startOfWeek resolves to monday by default', () {
      final date = DateTime(2026, 3, 26);
      expect(DateTimeUtils.startOfWeek(date), DateTime(2026, 3, 23));
    });

    test('daysBetween compares by whole day', () {
      final start = DateTime(2026, 3, 20, 23, 50);
      final end = DateTime(2026, 3, 22, 0, 5);
      expect(DateTimeUtils.daysBetween(start, end), 2);
    });
  });

  group('DurationUtils', () {
    test('formatClock renders mm:ss for short duration', () {
      expect(
        DurationUtils.formatClock(const Duration(minutes: 2, seconds: 5)),
        '02:05',
      );
    });

    test('formatShort renders concise labels', () {
      expect(
        DurationUtils.formatShort(const Duration(hours: 1, minutes: 8)),
        '1h 8m',
      );
    });
  });

  group('NumberUtils', () {
    test('clampInt limits value', () {
      expect(NumberUtils.clampInt(12, min: 0, max: 10), 10);
    });

    test('percentageLabel formats derived percentage', () {
      expect(NumberUtils.percentageLabel(value: 1, total: 4), '25%');
    });
  });

  group('ListUtils', () {
    test('safeElementAt returns null for invalid index', () {
      expect(ListUtils.safeElementAt([1, 2, 3], 5), isNull);
    });

    test('unique removes duplicates', () {
      expect(ListUtils.unique([1, 2, 2, 3]), [1, 2, 3]);
    });
  });

  group('MapUtils', () {
    test('copyWithout removes requested keys', () {
      expect(MapUtils.copyWithout({'a': 1, 'b': 2, 'c': 3}, ['b']), {
        'a': 1,
        'c': 3,
      });
    });

    test('filterValues keeps matching values', () {
      expect(
        MapUtils.filterValues({'a': 1, 'b': 2, 'c': 3}, (value) => value.isOdd),
        {'a': 1, 'c': 3},
      );
    });
  });

  group('ObjectUtils', () {
    test('castListOrNull returns typed list when valid', () {
      expect(ObjectUtils.castListOrNull<int>([1, 2, 3]), [1, 2, 3]);
    });

    test('equalsAny checks candidate set', () {
      expect(ObjectUtils.equalsAny('study', ['review', 'study']), isTrue);
    });
  });

  group('ValidationUtils', () {
    test('isEmail validates address', () {
      expect(ValidationUtils.isEmail('hello@memora.app'), isTrue);
    });

    test('isUrl validates web url', () {
      expect(ValidationUtils.isUrl('https://memora.app/decks'), isTrue);
    });

    test('matches handles regular expressions', () {
      expect(ValidationUtils.matches('Deck 01', RegExp(r'^Deck \d+$')), isTrue);
    });
  });

  group('FileUtils', () {
    test('fileNameWithoutExtension strips last extension', () {
      expect(
        FileUtils.fileNameWithoutExtension('/tmp/study.deck.json'),
        'study.deck',
      );
    });

    test('isImageFile detects common image types', () {
      expect(FileUtils.isImageFile('folder/card.png'), isTrue);
    });
  });

  group('UrlUtils', () {
    test('appendQueryParameters preserves and appends query', () {
      expect(
        UrlUtils.appendQueryParameters('https://memora.app/decks?page=1', {
          'filter': 'due',
        }).toString(),
        'https://memora.app/decks?page=1&filter=due',
      );
    });

    test('isWebUrl detects http and https', () {
      expect(UrlUtils.isWebUrl('https://memora.app'), isTrue);
      expect(UrlUtils.isWebUrl('mailto:test@memora.app'), isFalse);
    });
  });

  group('ColorUtils', () {
    test('toHex and fromHex round trip rgb values', () {
      final color = ColorUtils.fromHex('#0E6D68');
      expect(ColorUtils.toHex(color), '#0e6d68');
    });

    test('contrastColor returns readable opposite tone', () {
      expect(ColorUtils.contrastColor(Colors.black), Colors.white);
      expect(ColorUtils.contrastColor(Colors.white), Colors.black);
    });
  });
}
