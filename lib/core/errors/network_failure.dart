import 'package:memora/core/errors/failure.dart';

class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.isRetryable = true,
  });
}
