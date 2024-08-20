import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tale_ai_frontend/characters/data/model/model.dart';
import 'package:tale_ai_frontend/firebase/firebase.dart';

extension CharacterFirestoreRefs on FirebaseFirestore {
  DocumentReference<Character> characterDocRef({
    required String userId,
    required String characterId,
  }) =>
      collection(FirestoreCollections.users)
          .doc(userId)
          .collection(FirestoreCollections.characters)
          .doc(characterId)
          .withConverter<Character>(
            fromFirestore: (snapshot, _) => Character.fromJson(
              snapshot.dataWithDocId()!,
            ),
            toFirestore: (model, _) => model.toJson(),
          );

  CollectionReference<Character> characterCollectionRef(String userId) =>
      collection(FirestoreCollections.users)
          .doc(userId)
          .collection(FirestoreCollections.characters)
          .withConverter<Character>(
            fromFirestore: (snapshot, _) => Character.fromJson(
              snapshot.dataWithDocId()!,
            ),
            toFirestore: (model, _) => model.toJson(),
          );
}
