import 'package:dio/dio.dart';

import 'auth_interceptor.dart';

class ApiClient {
  ApiClient({String baseUrl = 'http://localhost:8080'}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(AuthInterceptor());
  }

  late final Dio _dio;

  Dio get dio => _dio;

  void dispose() {
    _dio.close();
  }
}
