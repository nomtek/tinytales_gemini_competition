import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/firebase/firebase.dart';

part 'auth_service.g.dart';

enum LoginResult {
  success,
  failure,
}

@riverpod
AuthService authService(AuthServiceRef ref) {
  return AuthService(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    googleSignIn: ref.watch(googleSignInProvider),
  );
}

class AuthService {
  AuthService({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  Future<LoginResult> signInWithGoogle() async {
    if (kIsWeb) {
      return _signInWithGoogleWeb();
    } else {
      return _signInWithGoogleMobile();
    }
  }

  Future<void> logout() => _firebaseAuth.signOut();

  Future<LoginResult> _signInWithGoogleWeb() async {
    // Create a new provider
    final googleProvider = GoogleAuthProvider()
      ..setCustomParameters({'login_hint': 'user@example.com'});

    // Once signed in, return the UserCredential
    await _firebaseAuth.signInWithPopup(googleProvider);
    return LoginResult.success;
  }

  Future<LoginResult> _signInWithGoogleMobile() async {
    // Trigger the authentication flow
    final googleUser = await _googleSignIn.signIn();

    // Without this check, the app will crash if the user cancels the login
    // https://github.com/firebase/flutterfire/issues/10636
    if (googleUser == null) {
      return LoginResult.failure;
    }

    // Obtain the auth details from the request
    final googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await _firebaseAuth.signInWithCredential(credential);
    return LoginResult.success;
  }
}
