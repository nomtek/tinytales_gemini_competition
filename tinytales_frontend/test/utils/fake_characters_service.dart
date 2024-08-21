import 'package:flutter_test/flutter_test.dart';
import 'package:tale_ai_frontend/characters/characters.dart';

final List<Character> fakeCharacters = [
  Character(
    id: '1',
    name: 'Character 1',
    description: 'Description 1',
    createDate: DateTime.now(),
  ),
  Character(
    id: '2',
    name: 'Character 2',
    description: 'Description 2',
    createDate: DateTime.now(),
  ),
  Character(
    id: '3',
    name: 'Character 3',
    description: 'Description 3',
    createDate: DateTime.now(),
  ),
];

class FakeCharactersService extends Fake implements CharactersService {
  FakeCharactersService(this.characters);

  factory FakeCharactersService.empty() => FakeCharactersService([]);

  factory FakeCharactersService.withFakeCharacters() =>
      FakeCharactersService(fakeCharacters);

  final List<Character> characters;

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

  @override
  Future<bool> isCharactersCollectionEmpty() {
    return Future.value(characters.isEmpty);
  }
}
