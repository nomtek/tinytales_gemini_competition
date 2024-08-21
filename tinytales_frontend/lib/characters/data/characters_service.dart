import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/auth/auth_state.dart';
import 'package:tale_ai_frontend/characters/data/data.dart';
import 'package:tale_ai_frontend/firebase/firebase.dart';

part 'characters_service.g.dart';

@riverpod
CharactersService charactersService(CharactersServiceRef ref) {
  final userId = ref.watch(userIdProvider);
  if (userId == null) {
    throw StateError('User is not logged in');
  }
  return CharactersService(
    firestore: ref.watch(firestoreProvider),
    userId: userId,
  );
}

class CharactersService {
  CharactersService({
    required FirebaseFirestore firestore,
    required this.userId,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;
  final String userId;

  DocumentReference<Character> _characterDocRef(String characterId) =>
      _firestore.characterDocRef(userId: userId, characterId: characterId);

  CollectionReference<Character> _characterCollectionRef() =>
      _firestore.characterCollectionRef(userId);

  Future<List<Character>> getCharacters() async {
    final snapshot = await _characterCollectionRef().get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<List<Character>> getCharactersLimited({
    required int pageSize,
    String? lastCharacterId,
  }) async {
    var pagedQuery = _characterCollectionRef().limit(pageSize);

    if (lastCharacterId != null) {
      pagedQuery = pagedQuery.startAfterDocument(
        await _characterDocRef(lastCharacterId).get(),
      );
    }

    final snapshot = await pagedQuery.get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<bool> isCharactersCollectionEmpty() async {
    final snapshot = await _characterCollectionRef().limit(1).get();
    return snapshot.docs.isEmpty;
  }
}
