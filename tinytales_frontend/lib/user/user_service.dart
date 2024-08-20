import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/auth/auth_state.dart';
import 'package:tale_ai_frontend/debug/talker.dart';
import 'package:tale_ai_frontend/firebase/firebase.dart';
import 'package:talker_flutter/talker_flutter.dart';

part 'user_service.g.dart';

class UserService {
  UserService({
    required this.userId,
    required FirebaseFirestore firestore,
    required Talker talker,
  })  : _firestore = firestore,
        _talker = talker;

  final String userId;
  final FirebaseFirestore _firestore;
  final Talker _talker;

  // in current impl we want to set locale on backend so
  // AI knows what language to use to generate text
  void setUserLocale({
    required Locale locale,
  }) {
    // unawaited to not block the UI
    // firestore locally caches the data so it should be fast
    // whenever we need to read it
    _talker.debug('Setting user locale to $locale.');
    unawaited(
      _firestore.collection('users').doc(userId).update({
        'language': locale.toLanguageTag(),
      }),
    );
  }
}

/// Throws [StateError] if user is not logged in.
@riverpod
UserService userService(UserServiceRef ref) {
  final userId = ref.watch(userIdProvider);
  if (userId == null) {
    throw StateError('User id is not available / not logged in.');
  }
  return UserService(
    userId: userId,
    firestore: ref.watch(firestoreProvider),
    talker: ref.watch(talkerProvider),
  );
}
