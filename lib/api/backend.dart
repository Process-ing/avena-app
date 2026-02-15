import 'package:avena/model/user_profile_model.dart';
import 'package:avena/model/ingredient.dart';
import 'package:avena/model/recipe.dart';
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

  @POST("suggest-recipes/")
  Future<List<Recipe>> suggestRecipes(
    @BodyExtra("ignoreInventory") bool ignoreInventory,
  );

  @GET("inventory/")
  Future<List<Ingredient>> getInventory();

  @POST("inventory/")
  Future<void> addInventoryItem(@Body() Ingredient item);

  @PATCH("inventory/{id}/")
  Future<Ingredient> updateInventoryItem(
    @Path('id') String name,
    @Body() Ingredient item,
  );

  @DELETE("inventory/{id}/")
  Future<void> removeInventoryItem(@Path('id') String name);
}
