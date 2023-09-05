import 'package:retrofit/retrofit.dart';
// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart';
import 'package:maison_mate/network/response/auth_response.dart';

part 'auth_service.g.dart';

@RestApi(baseUrl: "http://192.168.1.7:3000/api/v1/partner")
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST("/login")
  @FormUrlEncoded()
  Future<AuthResponse> login(
    @Field("email") String email,
    @Field("password") String password,
  );
}
