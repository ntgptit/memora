import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memora/core/errors/app_exception.dart';
import 'package:memora/core/errors/auth_failure.dart';
import 'package:memora/core/errors/error_mapper.dart';
import 'package:memora/core/errors/failure.dart';
import 'package:memora/core/errors/network_failure.dart';
import 'package:memora/core/errors/storage_failure.dart';
import 'package:memora/core/errors/validation_failure.dart';

void main() {
  group('ErrorMapper', () {
    test('returns existing failure unchanged', () {
      const failure = StorageFailure(message: 'disk full', code: 'storage');

      expect(ErrorMapper.map(failure), same(failure));
    });

    test('maps typed app exceptions', () {
      const error = AppException.auth('Unauthorized');
      final mapped = ErrorMapper.map(error);

      expect(mapped, isA<AuthFailure>());
      expect(mapped.message, 'Unauthorized');
    });

    test('maps timeout into retryable network failure', () {
      final mapped = ErrorMapper.map(
        TimeoutException('late response'),
        stackTrace: StackTrace.current,
      );

      expect(mapped, isA<NetworkFailure>());
      expect((mapped as NetworkFailure).isTimeout, isTrue);
      expect(mapped.isRetryable, isTrue);
    });

    test('maps dio auth responses to auth failure', () {
      final requestOptions = RequestOptions(path: '/auth/login');
      final error = DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 401,
          data: <String, Object?>{
            'message': 'Unauthorized',
            'code': 'unauthorized',
          },
        ),
        type: DioExceptionType.badResponse,
      );

      final mapped = ErrorMapper.map(error);

      expect(mapped, isA<AuthFailure>());
      expect(mapped.message, 'Unauthorized');
    });

    test('maps dio validation responses with field errors', () {
      final requestOptions = RequestOptions(path: '/decks');
      final error = DioException(
        requestOptions: requestOptions,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 422,
          data: <String, Object?>{
            'message': 'Invalid payload',
            'code': 'validation',
            'fieldErrors': <String, Object?>{
              'name': <String>['Required'],
              'size': 'Too large',
            },
          },
        ),
        type: DioExceptionType.badResponse,
      );

      final mapped = ErrorMapper.map(error);

      expect(mapped, isA<ValidationFailure>());
      expect((mapped as ValidationFailure).fieldErrors, <String, String>{
        'name': 'Required',
        'size': 'Too large',
      });
    });

    test('maps unknown objects to generic failure', () {
      final mapped = ErrorMapper.map(Object());

      expect(mapped, isA<Failure>());
      expect(mapped.code, 'unknown');
    });
  });
}
