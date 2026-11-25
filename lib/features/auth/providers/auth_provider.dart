
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  AuthProvider({
    AuthService? authService,
  }) : _authService = authService ?? AuthService() {
    _initializeAuth();
  }

  final AuthService _authService;

  StreamSubscription<User?>? _authSubscription;

  User? _user;

  Map<String, dynamic>? _backendUser;

  bool _isInitializing = true;
  bool _isSigningIn = false;
  bool _isSigningOut = false;
  bool _isSyncing = false;

  String? _error;

  // Track synchronization to avoid duplicate API calls.
  String? _syncedUid;
  String? _syncingUid;

  Future<void>? _syncFuture;

  User? get user => _user;

  Map<String, dynamic>? get backendUser => _backendUser;

  bool get isAuthenticated => _user != null;

  bool get isInitializing => _isInitializing;

  bool get isSigningIn => _isSigningIn;

  bool get isSigningOut => _isSigningOut;

  bool get isSyncing => _isSyncing;

  String? get error => _error;

  String? get userEmail => _user?.email;

  String? get userName => _user?.displayName;

  String? get userPhoto => _user?.photoURL;

  // Listen to Firebase authentication changes.
  void _initializeAuth() {
    _authSubscription = _authService.authStateChanges.listen(
          (firebaseUser) {
        _user = firebaseUser;
        _isInitializing = false;

        if (firebaseUser == null) {
          _backendUser = null;
          _syncedUid = null;
          _syncingUid = null;
          _syncFuture = null;
          _isSyncing = false;
          _error = null;
        } else {
          // Synchronize restored sessions automatically.
          unawaited(_syncUser(firebaseUser));
        }

        notifyListeners();
      },
      onError: (Object error) {
        _error = error.toString();
        _isInitializing = false;
        notifyListeners();
      },
    );
  }

  // Google Sign-In.
  Future<void> signInWithGoogle() async {
    if (_isSigningIn) return;

    try {
      _isSigningIn = true;
      _error = null;
      notifyListeners();

      final credential = await _authService.signInWithGoogle();

      final firebaseUser = credential.user;

      if (firebaseUser == null) {
        throw Exception('Firebase authentication failed.');
      }

      _user = firebaseUser;
      notifyListeners();

      // Wait for synchronization.
      // If the Firebase listener already started it, reuse that request.
      await _syncUser(firebaseUser);

    } catch (e) {
      _error = e.toString();
      debugPrint('Sign-in error: $_error');
    } finally {
      _isSigningIn = false;
      notifyListeners();
    }
  }

  // Synchronize a Firebase user with PostgreSQL.
  Future<void> _syncUser(User firebaseUser) async {
    final uid = firebaseUser.uid;

    if (_syncedUid == uid) {
      return;
    }

    // Reuse an existing request for this user.
    if (_syncingUid == uid && _syncFuture != null) {
      await _syncFuture;
      return;
    }

    _syncingUid = uid;
    _isSyncing = true;
    _error = null;
    notifyListeners();

    final completer = Completer<void>();
    _syncFuture = completer.future;

    try {
      final response =
      await _authService.syncUserWithBackend();

      // Don't apply an old user's response after account switching.
      if (_user?.uid != uid) {
        return;
      }

      _backendUser = response;
      _syncedUid = uid;

    } catch (e) {
      if (_user?.uid == uid) {
        _error = 'Account synchronization failed: $e';
        debugPrint(_error);
      }

    } finally {
      if (!completer.isCompleted) {
        completer.complete();
      }

      if (_syncingUid == uid) {
        _syncingUid = null;
        _syncFuture = null;
        _isSyncing = false;
      }

      notifyListeners();
    }
  }

  // Retry backend synchronization.
  Future<void> retrySync() async {
    final firebaseUser = _user;

    if (firebaseUser == null) {
      _error = 'Please sign in first.';
      notifyListeners();
      return;
    }

    // Force another attempt.
    _syncedUid = null;

    await _syncUser(firebaseUser);
  }

  // Sign out.
  Future<void> signOut() async {
    if (_isSigningOut) return;

    try {
      _isSigningOut = true;
      _error = null;
      notifyListeners();

      await _authService.signOut();

      _user = null;
      _backendUser = null;
      _syncedUid = null;

    } catch (e) {
      _error = e.toString();
      debugPrint('Sign-out error: $_error');

    } finally {
      _isSigningOut = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    _authService.dispose();
    super.dispose();
  }
}
