import 'package:memora/core/errors/failure.dart';

class StorageFailure extends Failure {
  const StorageFailure({required super.message, super.code});
}
