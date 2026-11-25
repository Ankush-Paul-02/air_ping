import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/network/api_client.dart';

class AuthService {
  AuthService({
    ApiClient? apiClient,
    FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  }) : _apiClient = apiClient ?? ApiClient(),
       _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance {
    _initialization = _googleSignIn.initialize();
  }

  final ApiClient _apiClient;
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  late final Future<void> _initialization;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  User? get currentUser => _firebaseAuth.currentUser;

  Future<UserCredential> signInWithGoogle() async {
    await _initialization;

    final googleUser = await _googleSignIn.authenticate();

    final googleAuth = googleUser.authentication;
    final googleIdToken = googleAuth.idToken;

    if (googleIdToken == null) {
      throw Exception('Google authentication failed.');
    }

    final credential = GoogleAuthProvider.credential(idToken: googleIdToken);

    final userCredential = await _firebaseAuth.signInWithCredential(credential);

    final firebaseUser = userCredential.user;

    if (firebaseUser == null) {
      throw Exception('Firebase authentication failed.');
    }

    final firebaseIdToken = await firebaseUser.getIdToken(true);

    if (firebaseIdToken == null) {
      throw Exception('Authentication token unavailable.');
    }

    return userCredential;
  }

  Future<Map<String, dynamic>> syncUserWithBackend() async {
    if (_firebaseAuth.currentUser == null) {
      throw Exception('User is not authenticated.');
    }

    final response = await _apiClient.dio.get('/api/v1/auth/me');

    if (response.data is! Map) {
      throw Exception('Invalid server response.');
    }

    return Map<String, dynamic>.from(response.data);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
  }

  void dispose() {
    _apiClient.dispose();
  }
}
