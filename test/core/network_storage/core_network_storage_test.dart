import 'package:flutter_test/flutter_test.dart';
import 'package:memora/core/network/api_client.dart';
import 'package:memora/core/network/api_error_response.dart';
import 'package:memora/core/network/api_response.dart';
import 'package:memora/core/storage/cache_manager.dart';
import 'package:memora/core/storage/local_storage.dart';
import 'package:memora/core/storage/preferences_storage.dart';
import 'package:memora/core/storage/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Api models', () {
    test('ApiResponse parses envelope metadata', () {
      final response = ApiResponse<String>.fromJson(<String, Object?>{
        'data': 'deck-1',
        'message': 'Loaded',
        'statusCode': 200,
        'meta': <String, Object?>{'page': 1},
      }, (raw) => raw.toString());

      expect(response.data, 'deck-1');
      expect(response.message, 'Loaded');
      expect(response.statusCode, 200);
      expect(response.meta, <String, Object?>{'page': 1});
    });

    test('ApiErrorResponse parses field errors', () {
      final response = ApiErrorResponse.fromJson(<String, Object?>{
        'message': 'Invalid payload',
        'code': 'validation',
        'fieldErrors': <String, Object?>{
          'name': <String>['Required'],
          'size': 'Too large',
        },
      });

      expect(response.message, 'Invalid payload');
      expect(response.code, 'validation');
      expect(response.fieldErrors, <String, String>{
        'name': 'Required',
        'size': 'Too large',
      });
      expect(response.hasFieldErrors, isTrue);
    });
  });

  group('Storage foundation', () {
    setUp(() {
      SharedPreferences.setMockInitialValues(<String, Object>{
        StorageKeys.themeType: 'dark',
        StorageKeys.locale: 'ko',
      });
    });

    test('InMemoryLocalStorage reads and writes typed values', () async {
      final storage = InMemoryLocalStorage();

      await storage.write('counter', 3);
      await storage.write('tags', <String>['a', 'b']);

      expect(storage.contains('counter'), isTrue);
      expect(storage.read<int>('counter'), 3);
      expect(storage.readStringList('tags'), <String>['a', 'b']);
    });

    test(
      'PreferencesStorage hydrates cached values from SharedPreferences',
      () async {
        final storage = PreferencesStorage();

        await storage.initialize();

        expect(storage.isInitialized, isTrue);
        expect(storage.read<String>(StorageKeys.themeType), 'dark');
        expect(storage.read<String>(StorageKeys.locale), 'ko');
      },
    );

    test('PreferencesStorage persists write delete and clear', () async {
      final storage = PreferencesStorage();
      await storage.initialize();

      await storage.write(StorageKeys.locale, 'vi');
      final preferences = await SharedPreferences.getInstance();
      expect(preferences.getString(StorageKeys.locale), 'vi');

      await storage.delete(StorageKeys.locale);
      expect(preferences.getString(StorageKeys.locale), isNull);

      await storage.write(StorageKeys.themeType, 'light');
      await storage.clear();
      expect(preferences.getString(StorageKeys.themeType), isNull);
    });
  });

  group('CacheManager', () {
    test('readOrLoad caches values and ttl expires', () {
      var currentTime = DateTime(2026, 3, 23, 9);
      final cache = CacheManager(now: () => currentTime);

      final first = cache.readOrLoad<String>(
        'dashboard',
        () => 'value-1',
        ttl: const Duration(minutes: 5),
      );
      final second = cache.readOrLoad<String>(
        'dashboard',
        () => 'value-2',
        ttl: const Duration(minutes: 5),
      );

      expect(first, 'value-1');
      expect(second, 'value-1');
      expect(cache.contains('dashboard'), isTrue);

      currentTime = currentTime.add(const Duration(minutes: 6));
      expect(cache.read<String>('dashboard'), isNull);
    });
  });

  group('ApiClient', () {
    test('builds Dio with base url and supports retrofit-style factories', () {
      final client = ApiClient(
        baseUrl: 'https://api.memora.dev',
        enableLogs: false,
      );

      expect(client.dio.options.baseUrl, 'https://api.memora.dev');
      expect(
        client.dio.options.connectTimeout,
        ApiClient.defaultConnectTimeout,
      );
      expect(
        client.dio.options.receiveTimeout,
        ApiClient.defaultReceiveTimeout,
      );
      expect(client.dio.options.sendTimeout, ApiClient.defaultSendTimeout);
      expect(
        client.createService(_RetrofitLikeClient.new).baseUrl,
        'https://api.memora.dev',
      );
      expect(
        client
            .createService(
              _RetrofitLikeClient.new,
              baseUrl: 'https://override.memora.dev',
            )
            .baseUrl,
        'https://override.memora.dev',
      );

      client.close();
    });
  });
}

class _RetrofitLikeClient {
  _RetrofitLikeClient(this.dio, {this.baseUrl});

  final Object dio;
  final String? baseUrl;
}
