import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

export 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;

part 'firebase.g.dart';

@Riverpod(keepAlive: true)
FirebaseFunctions firebaseFunctions(FirebaseFunctionsRef ref) {
  return FirebaseFunctions.instance;
}

@Riverpod(keepAlive: true)
FirebaseFirestore firestore(FirestoreRef ref) => FirebaseFirestore.instance;

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) => FirebaseAuth.instance;

// It's here due to direct connection with FirebaseAuth
@Riverpod(keepAlive: true)
GoogleSignIn googleSignIn(GoogleSignInRef ref) => GoogleSignIn();

/// Key to get the `docId` from the data of a [DocumentSnapshot]
/// with [DocumentSnapshotX.dataWithDocId] extension.
const firestoreDocIdKey = 'docId';

extension DocumentSnapshotX on DocumentSnapshot<Map<String, dynamic>> {
  /// Returns [data] with `docId` key added to it.
  /// Use [firestoreDocIdKey] as the key to get the `docId`.
  /// If [data] is null, returns null.
  ///
  /// use
  /// ```
  /// docRef.dataWithDocId()[firestoreDocIdKey]
  /// ```
  /// to get the `docId`
  Map<String, dynamic>? dataWithDocId() {
    final json = data();
    if (json == null) return null;
    return {
      firestoreDocIdKey: id,
      ...json,
    };
  }
}

/// Converts [Timestamp] to [DateTime] and vice versa.
class FirestoreDateTimeConverter implements JsonConverter<DateTime, Timestamp> {
  const FirestoreDateTimeConverter();

  @override
  DateTime fromJson(Timestamp json) => json.toDate();

  @override
  Timestamp toJson(DateTime object) => Timestamp.fromDate(object);
}

/// Converts [Map<String, dynamic>] to [Map<Object?, Object?>] and vice versa.
/// It is workaround for this issue: https://github.com/firebase/flutterfire/issues/11872
class MapConverter
    implements JsonConverter<Map<String, dynamic>, Map<Object?, Object?>> {
  const MapConverter();

  @override
  Map<String, dynamic> fromJson(Map<Object?, Object?> json) {
    return json.map((key, value) => MapEntry(key.toString(), value));
  }

  @override
  Map<Object?, Object?> toJson(Map<String, dynamic> object) {
    return object;
  }
}

extension CallJson on FirebaseFunctions {
  Future<HttpsCallableResult<Map<String, dynamic>>> callJson(
    String functionName, {
    Map<String, dynamic>? params,
  }) {
    final callable = httpsCallable(functionName);
    if (params == null || params.isEmpty) {
      return callable.call<Map<String, dynamic>>();
    } else {
      return callable.call<Map<String, dynamic>>(params);
    }
  }
}

class FirestoreCollections {
  static const users = 'users';
  static const characters = 'main_characters';
  static const stories = 'tales';
  static const lifeValues = 'life_values';
}
