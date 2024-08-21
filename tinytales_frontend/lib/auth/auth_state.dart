import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/firebase/firebase.dart';

part 'auth_state.g.dart';

// - uses Raw to please the linter of riverpod as ChangeNotifier
//  is not supported by generator
// - we create this specially for the router to listen to the auth state change
// don't use this in your widgets
@Riverpod(keepAlive: true)
Raw<ValueNotifier<bool?>> listenToAuthStateChange(
  ListenToAuthStateChangeRef ref,
) {
  final notifier = ValueNotifier<bool?>(null);
  ref.listen(
    isLoggedInProvider,
    (_, isLoggedIn) => notifier.value = isLoggedIn,
  );
  return notifier;
}

@Riverpod(keepAlive: true)
bool isLoggedIn(IsLoggedInRef ref) {
  final userAsync = ref.watch(userStreamProvider);
  if (userAsync.valueOrNull != null) {
    return true;
  }
  return false;
}

/// null if the user is not logged in or we don't know yet
@Riverpod(keepAlive: true)
Stream<User?> userStream(UserStreamRef ref) async* {
  final firebaseAuth = ref.watch(firebaseAuthProvider);
  yield firebaseAuth.currentUser;
  yield* firebaseAuth.authStateChanges();
}

@Riverpod(keepAlive: true)
String? userId(UserIdRef ref) {
  final userAsync = ref.watch(userStreamProvider);
  return userAsync.valueOrNull?.uid;
}
