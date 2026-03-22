import 'package:memora/core/errors/failure.dart';

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message, super.code});
}
