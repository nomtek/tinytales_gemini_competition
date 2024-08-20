import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/characters/characters.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/story_creator/form/steps/steps.dart';
import 'package:tale_ai_frontend/story_creator/form/story_creator_navigation_button.dart';
import 'package:tale_ai_frontend/story_creator/state/state.dart';
import 'package:tale_ai_frontend/theme/theme.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

part 'story_creator_character_selection_substep.g.dart';

@riverpod
Future<List<Character>> _characters(_CharactersRef ref) {
  return ref.watch(charactersServiceProvider).getCharacters();
}

class StoryCreatorCharacterSelectionSubstep extends ConsumerWidget {
  const StoryCreatorCharacterSelectionSubstep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScrollableContentScaffold(
      scrollableContent: Column(
        children: [
          FormStepHeader(
            title: context.l10n.storyCreatorSelectCharacterStepTitle,
          ),
          CustomStepTile(
            title: context
                .l10n.storyCreatorSelectCharacterStepCreateCharacterButton,
            onClicked: () => ref
                .read(storyCreatorStateNotifierProvider.notifier)
                .setCharacterStepType(
                  StepType.creation,
                ),
          ),
          const Gap(32),
          ref.watch(_charactersProvider).when(
                data: (characters) {
                  return _CharactersView(characters: characters);
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, _) {
                  return AppErrorWidget(
                    shouldScroll: false,
                    errorDescription: context.l10n
                        .storyCreatorSelectCharacterStepCharactersLoadingError,
                    onTryAgain: () => ref.invalidate(_charactersProvider),
                  );
                },
              ),
        ],
      ),
      bottomContent: const StoryCreatorNavigationButtons(),
    );
  }
}

class _CharactersView extends StatelessWidget {
  const _CharactersView({
    required this.characters,
  });

  final List<Character> characters;

  @override
  Widget build(BuildContext context) {
    if (characters.isEmpty) {
      return const SizedBox.shrink();
    }
    return AppListContainer(
      child: SizedBox(
        height: characters.length * 73,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final character in characters) ...[
              SelectableCharacterTile(character: character),
              if (characters.last != character) const Divider(),
            ],
          ],
        ),
      ),
    );
  }
}

@riverpod
String? _selectedCharacterId(_SelectedCharacterIdRef ref) {
  return ref.watch(characterStepStateProvider).selectedCharacter?.id;
}

class SelectableCharacterTile extends ConsumerWidget {
  const SelectableCharacterTile({
    required this.character,
    super.key,
  });

  final Character character;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      selected: ref.watch(_selectedCharacterIdProvider) == character.id,
      selectedTileColor: context.colors.secondaryContainer,
      title: Row(
        children: [
          ListCharacterAvatar(
            characterId: character.id,
          ),
          const Gap(16),
          Text(
            character.name,
            style: context.textTheme.bodyLarge,
          ),
        ],
      ),
      tileColor: context.colors.surface,
      onTap: () {
        ref
            .read(storyCreatorStateNotifierProvider.notifier)
            .selectCharacter(character);
      },
    );
  }
}
