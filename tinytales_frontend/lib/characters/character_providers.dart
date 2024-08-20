import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/characters/characters.dart';
import 'package:tale_ai_frontend/characters/data/data.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

part 'character_providers.g.dart';

@riverpod
Stream<Character?> character(CharacterRef ref, String characterId) =>
    ref.watch(characterServiceProvider).observeCharacter(characterId);

// We need to observe the character image link in order to display the change
// in the UI when the user image is generated. Currently, the image is displayed
// in lists where characters are downloaded once and not updated after that.
// There is potential for performance improvements here
@riverpod
Stream<String?> observeCharacterPictureUrl(
  ObserveCharacterPictureUrlRef ref,
  String characterId,
) async* {
  yield* ref
      .watch(characterServiceProvider)
      .observeCharacter(characterId)
      .map((character) => character?.picture);
}

@riverpod
AppGeneratedPictureState characterPictureState(
  CharacterPictureStateRef ref,
  String characterId,
) {
  final character = ref.watch(characterProvider(characterId));
  switch (character) {
    case AsyncLoading():
      return AppGeneratedPictureState.generating;
    case AsyncData(:final value):
      return switch (value?.pictureState) {
        CharacterPictureState.characterIllustrationGeneration =>
          AppGeneratedPictureState.generating,
        null => AppGeneratedPictureState.generating,
        CharacterPictureState.completed =>
          AppGeneratedPictureState.generationCompleted,
        CharacterPictureState.error => AppGeneratedPictureState.error,
      };
    case AsyncValue<Character?>():
      return AppGeneratedPictureState.error;
  }
}
