import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/auth/auth_state.dart';
import 'package:tale_ai_frontend/firebase/firebase.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/story/data/data.dart';

part 'story_service.g.dart';

@riverpod
StoryService storyService(StoryServiceRef ref) {
  final userId = ref.watch(userIdProvider);
  if (userId == null) {
    throw StateError('User is not logged in');
  }
  return StoryService(
    firestore: ref.watch(firestoreProvider),
    firebaseFunctions: ref.watch(firebaseFunctionsProvider),
    userId: userId,
  );
}

class StoryService {
  StoryService({
    required FirebaseFirestore firestore,
    required FirebaseFunctions firebaseFunctions,
    required this.userId,
  })  : _firestore = firestore,
        _firebaseFunctions = firebaseFunctions;

  final FirebaseFirestore _firestore;
  final FirebaseFunctions _firebaseFunctions;
  final String userId;

  DocumentReference<Story> _storyDocRef(String storyId) =>
      _firestore.storyDocRef(userId: userId, storyId: storyId);

  CollectionReference<Story> _storyCollectionRef() => _firestore
      .collection(FirestoreCollections.users)
      .doc(userId)
      .collection(FirestoreCollections.stories)
      .withConverter<Story>(
        fromFirestore: (snapshot, _) => Story.fromJson(
          snapshot.dataWithDocId()!,
        ),
        toFirestore: (model, _) => model.toJson(),
      );

  Query<Story> _notDeletedStoriesQuery() =>
      _storyCollectionRef().where('deleted', isEqualTo: false);

  Stream<Story?> observeStory(String storyId) async* {
    yield* _storyDocRef(storyId).snapshots().map((snapshot) {
      if (snapshot.data()?.deleted ?? false) {
        return null;
      }
      return snapshot.data();
    });
  }

  Future<List<Story>> getStories({
    required int pageSize,
    String? lastStoryId,
  }) async {
    var pagedQuery = _notDeletedStoriesQuery()
        .orderBy('create_date', descending: true)
        .limit(pageSize);
    if (lastStoryId != null) {
      pagedQuery =
          pagedQuery.startAfterDocument(await _storyDocRef(lastStoryId).get());
    }
    final snapshot = await pagedQuery.get();
    final stories =
        snapshot.docs.map((docSnapshot) => docSnapshot.data()).toList();
    return stories;
  }

  void updateStory(String storyId, String editedStory) {
    _storyDocRef(storyId).update({
      'update_date': FieldValue.serverTimestamp(),
      'full_text': editedStory,
    });
  }

  /// Requests a pdf generation for the story.
  /// The pdf will be available under the [Story.pdfUrl].
  Future<String> generatePdf(String storyId) async {
    final result = await _firebaseFunctions
        .httpsCallable(
      'createPdfForTale',
    )
        .call<String>({'taleId': storyId});
    return result.data;
  }

  void deleteStory(String storyId) {
    _storyDocRef(storyId).update({'deleted': true});
  }

  /// Requests an audio generation for the story.
  /// The audio will be available under the [Story.audioUrl].
  ///
  /// Returns the audio URL.
  Future<String?> generateAudio(String storyId) async {
    final result = await _firebaseFunctions
        .httpsCallable(
      'createAudioForTale',
    )
        .call<String?>({'taleId': storyId});
    return result.data;
  }

  Future<List<StoryProposal>> createNextAdventureProposals({
    required String taleId,
  }) async {
    final result = await _firebaseFunctions.callJson(
      'createProposalsForTale',
      params: {
        'taleId': taleId,
      },
    );

    final proposals = StoryProposals.fromJson(result.data).proposals;

    return proposals;
  }

  Future<String> createNextAdventure({
    required String originalStoryId,
    required List<StoryProposal> proposals,
    required int chosenProposalIndex,
  }) async {
    final result = await _firebaseFunctions.callJson(
      'createSimilarTale',
      params: {
        'taleId': originalStoryId,
        'proposals': proposals.map((e) => e.toJson()).toList(),
        'chosenProposalIndex': chosenProposalIndex,
      },
    );
    return result.data['taleId'] as String;
  }

  Future<List<LifeValue>> getLifeValues() async {
    final query =
        _firestore.collection(FirestoreCollections.lifeValues).orderBy('order');
    final snapshot = await query.get();
    return snapshot.docs
        .map((docSnapshot) => LifeValue.fromJson(docSnapshot.dataWithDocId()!))
        .toList();
  }

  Future<void> regeneratePicture(String storyId) async {
    final storyRef = _storyDocRef(storyId);
    unawaited(
      storyRef.update(
        {
          'illustrations_state': 'PAGE_ILUSTRATION_GENERATION',
          'picture': null,
        },
      ),
    );

    await _firebaseFunctions
        .httpsCallable('regenerateCoverImage')
        .call<void>({'taleId': storyId});
  }
}
