import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/auth/auth_state.dart';
import 'package:tale_ai_frontend/characters/characters.dart';
import 'package:tale_ai_frontend/firebase/firebase.dart';
import 'package:tale_ai_frontend/form/form.dart';

part 'character_service.g.dart';

@riverpod
CharacterService characterService(CharacterServiceRef ref) {
  final functions = ref.watch(firebaseFunctionsProvider);
  final firestore = ref.watch(firestoreProvider);
  final userId = ref.watch(userIdProvider);
  if (userId == null) {
    throw StateError('User is not logged in');
  }
  return CharacterService(
    userId: userId,
    functions: functions,
    firestore: firestore,
  );
}

const _nameParam = 'name';
const _descriptionParam = 'description';

typedef CharacterId = String;

class CharacterService {
  CharacterService({
    required this.userId,
    required FirebaseFunctions functions,
    required FirebaseFirestore firestore,
  })  : _functions = functions,
        _firestore = firestore;

  final String userId;
  final FirebaseFunctions _functions;
  final FirebaseFirestore _firestore;

  /// Autofill a character with the given [name] and [description].
  ///
  /// Returns the autofilled character.
  Future<AutofillCharacter> autofillCharacter({
    required String name,
    required String description,
  }) async {
    final result = await _functions.callJson(
      'autofillCharacter',
      params: {
        _nameParam: name,
        _descriptionParam: description,
      },
    );
    return AutofillCharacter(
      name: result.data[_nameParam] as String,
      description: result.data[_descriptionParam] as String,
    );
  }

  Future<Validation> validateCharacter({
    required String name,
    required String description,
  }) {
    final result = _functions.callJson(
      'validateCharacter',
      params: {
        _nameParam: name,
        _descriptionParam: description,
      },
    );

    final validation = result.then((result) {
      return Validation.fromJson(result.data);
    });

    return validation;
  }

  /// Creates a new character with the [name], [description],
  ///
  /// Returns the id of the created character.
  Future<CharacterId> createCharacter({
    required String name,
    String? description,
  }) async {
    // send json data
    final result = await _functions.callJson(
      'createCharacter',
      params: {
        _nameParam: name,
        _descriptionParam: description,
      },
    );
    return result.data['characterId'] as String;
  }

  Future<void> updateCharacter({
    required CharacterId characterId,
    required String name,
    String? description,
  }) async {
    final characterDocRef = _characterDocRef(characterId);
    await characterDocRef.update(
      {
        'name': name,
        'user_description': description,
        'description': description,
        'update_date': FieldValue.serverTimestamp(),
      },
    );
  }

  Future<void> deleteCharacter(CharacterId characterId) async {
    final characterDocRef = _characterDocRef(characterId);
    await characterDocRef.delete();
  }

  Future<void> regeneratePicture(String characterId) async {
    final characterDocRef = _characterDocRef(characterId);
    unawaited(
      characterDocRef.update(
        {
          'picture': null,
          'illustrations_state': 'CHARACTER_IMAGE_GENERATION',
        },
      ),
    );
    await _functions
        .httpsCallable('regenerateCharacterImage')
        .call<void>({'characterId': characterId});
  }

  Stream<Character?> observeCharacter(String characterId) async* {
    final character = _characterDocRef(characterId).snapshots().map(
          (snapshot) => snapshot.data(),
        );
    yield* character;
  }

  DocumentReference<Character> _characterDocRef(String characterId) =>
      _firestore.characterDocRef(userId: userId, characterId: characterId);
}
