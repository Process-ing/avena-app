import 'package:avena/api/backend.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

part 'api.g.dart';

@riverpod
Dio dio(Ref ref) { // Voltamos a usar 'Ref' temporariamente para permitir o build
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://avena.henriquesf.me/api',
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'FlutterBetterAuth/1.0.0',
        'Origin': 'https://avena.henriquesf.me',
        'flutter-origin': 'flutter://',
        'expo-origin': 'exp://',
        'x-skip-oauth-proxy': 'true',
      },
      extra: {'withCredentials': true},
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  // Adiciona o gestor de cookies para resolver o 401
  dio.interceptors.add(CookieManager(CookieJar()));

  return dio;
}

@riverpod
BackendApi backendApi(Ref ref) => BackendApi(ref.watch(dioProvider));