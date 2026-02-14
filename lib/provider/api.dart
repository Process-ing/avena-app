import 'package:avena/api/backend.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api.g.dart';

@riverpod
Dio dio(Ref ref) => Dio(
  BaseOptions(
    headers: {
      'Content-Type': 'application/json',
      'User-Agent': 'FlutterBetterAuth/1.0.0',
      'Origin': 'https://avena.henriquesf.me',
      'flutter-origin': 'flutter://',
      'expo-origin': 'exp://',
      'x-skip-oauth-proxy': true,
    },
    validateStatus: (status) => status != null && status < 300,
  ),
);

@riverpod
BackendApi backendApi(Ref ref) => BackendApi(ref.watch(dioProvider));
