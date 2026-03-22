import 'package:memora/core/errors/failure.dart';

class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});
}
