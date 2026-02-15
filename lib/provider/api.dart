import 'package:avena/api/backend.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api.g.dart';

@riverpod
Dio dio(Ref ref) {
  final dio = Dio(
    BaseOptions(
      headers: {
        'Content-Type': 'application/json',
        'User-Agent': 'FlutterBetterAuth/1.0.0',
        'Origin': 'https://avena.henriquesf.me',
        'flutter-origin': 'flutter://',
        'expo-origin': 'exp://',
        'x-skip-oauth-proxy': 'true',
      },
      validateStatus: (status) => status != null && status < 500,
    ),
  );

  dio.interceptors.add(
    InterceptorsWrapper(
      onResponse: (Response response, ResponseInterceptorHandler handler) {
        // Handle plain text error responses by converting them to JSON
        if (response.data is String &&
            response.statusCode != null &&
            response.statusCode! >= 400) {
          response.data = {
            'error': {'message': response.data, 'status': response.statusCode},
          };
        }
        handler.next(response);
      },
      onError: (DioException error, ErrorInterceptorHandler handler) {
        // Handle plain text error responses in error cases too
        if (error.response?.data is String) {
          error.response?.data = {
            'error': {
              'message': error.response?.data ?? 'Unknown error',
              'status': error.response?.statusCode,
            },
          };
        }
        handler.next(error);
      },
    ),
  );

  return dio;
}

@riverpod
BackendApi backendApi(Ref ref) => BackendApi(ref.watch(dioProvider));
