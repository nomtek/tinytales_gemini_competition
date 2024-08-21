import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tale_ai_frontend/firebase/firebase.dart';
import 'package:tale_ai_frontend/story/data/story.dart';

extension StoryFirestoreRefs on FirebaseFirestore {
  DocumentReference<Story> storyDocRef({
    required String userId,
    required String storyId,
  }) =>
      collection(FirestoreCollections.users)
          .doc(userId)
          .collection(FirestoreCollections.stories)
          .doc(storyId)
          .withConverter<Story>(
            fromFirestore: (snapshot, _) => Story.fromJson(
              snapshot.dataWithDocId()!,
            ),
            toFirestore: (model, _) => model.toJson(),
          );
}
