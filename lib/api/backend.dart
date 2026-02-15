import 'package:avena/model/recipe.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'backend.g.dart';

@RestApi(baseUrl: 'https://avena.henriquesf.me/api/')
abstract class BackendApi {
  factory BackendApi(Dio dio, {String baseUrl}) = _BackendApi;

  @POST("suggest-recipes/")
  Future<List<Recipe>> suggestRecipes(
    @BodyExtra("ignoreInventory") bool ignoreInventory,
  );
}
