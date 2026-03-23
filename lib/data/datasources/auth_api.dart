import 'package:dio/dio.dart';
import 'package:memora/data/models/auth_requests.dart';
import 'package:memora/data/models/auth_session_model.dart';
import 'package:memora/data/models/auth_user_model.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String? baseUrl}) = _AuthApi;

  @POST('/api/v1/auth/login')
  Future<AuthSessionModel> login(@Body() AuthLoginRequest body);

  @POST('/api/v1/auth/register')
  Future<AuthSessionModel> register(@Body() AuthRegisterRequest body);

  @POST('/api/v1/auth/refresh')
  Future<AuthSessionModel> refresh(@Body() AuthRefreshRequest body);

  @POST('/api/v1/auth/logout')
  Future<void> logout(@Body() AuthLogoutRequest body);

  @GET('/api/v1/auth/me')
  Future<AuthUserModel> me();
}
