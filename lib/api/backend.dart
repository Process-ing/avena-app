import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'backend.g.dart';

@RestApi(baseUrl: 'https://avena.henriquesf.me')
abstract class BackendApi {
  factory BackendApi(Dio dio, {String baseUrl}) = _BackendApi;
}
