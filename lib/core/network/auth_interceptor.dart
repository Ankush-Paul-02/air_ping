import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user != null) {
        // Firebase automatically refreshes expired ID tokens.
        final idToken = await user.getIdToken();

        if (idToken != null) {
          options.headers['Authorization'] = 'Bearer $idToken';
        }
      }

      handler.next(options);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          error: 'Unable to retrieve authentication token.',
          type: DioExceptionType.unknown,
        ),
      );
    }
  }
}
