import 'package:avena/model/user_profile_model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'backend.g.dart';

@RestApi(baseUrl: 'https://avena.henriquesf.me/api/')
abstract class BackendApi {
  factory BackendApi(Dio dio, {String baseUrl}) = _BackendApi;

  @GET("user/profile/")
  Future<UserProfile> getUserProfile();

  @PATCH("user/profile/")
  Future<UserProfile> updateUserProfile(@Body() UserProfile profile);
}
