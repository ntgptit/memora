import 'package:memora/core/errors/app_exception.dart';
import 'package:memora/core/errors/auth_failure.dart';
import 'package:memora/core/errors/failure.dart';
import 'package:memora/core/errors/network_failure.dart';
import 'package:memora/core/errors/storage_failure.dart';
import 'package:memora/core/errors/validation_failure.dart';

abstract final class ErrorMapper {
  static Failure map(Object error) {
    if (error is Failure) {
      return error;
    }

    if (error is AppException) {
      final code = error.code?.toLowerCase();
      if (code == 'unauthorized' || code == 'forbidden') {
        return AuthFailure(message: error.message, code: error.code);
      }
      if (code == 'validation') {
        return ValidationFailure(message: error.message, code: error.code);
      }
      if (code == 'storage') {
        return StorageFailure(message: error.message, code: error.code);
      }
      return NetworkFailure(message: error.message, code: error.code);
    }

    return const Failure(message: 'Unexpected application error.');
  }
}
