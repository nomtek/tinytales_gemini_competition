import 'package:flutter_test/flutter_test.dart';
import 'package:tale_ai_frontend/characters/data/character_service.dart';
import 'package:tale_ai_frontend/characters/data/model/character.dart';

class MockCharacterService extends Fake implements CharacterService {
  MockCharacterService({this.character});

  final Character? character;

  @override
  Stream<Character?> observeCharacter(String characterId) {
    return Stream.value(character);
  }
}
