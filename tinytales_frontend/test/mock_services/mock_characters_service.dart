import 'package:flutter_test/flutter_test.dart';
import 'package:tale_ai_frontend/characters/data/characters_service.dart';
import 'package:tale_ai_frontend/characters/data/model/model.dart';

class MockCharactersService extends Fake implements CharactersService {
  MockCharactersService({this.characters});

  final List<Character>? characters;

  @override
  Future<List<Character>> getCharacters() {
    return Future.value(characters);
  }

  @override
  Future<List<Character>> getCharactersLimited({
    required int pageSize,
    String? lastCharacterId,
  }) {
    return Future.value(characters);
  }
}
