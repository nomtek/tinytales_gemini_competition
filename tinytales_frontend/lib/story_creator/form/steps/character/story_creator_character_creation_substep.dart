import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/l10n/l10n.dart';
import 'package:tale_ai_frontend/story_creator/form/components.dart';
import 'package:tale_ai_frontend/story_creator/form/steps/character/story_creator_character_step.dart';
import 'package:tale_ai_frontend/story_creator/form/story_creator_navigation_button.dart';
import 'package:tale_ai_frontend/story_creator/state/state.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

part 'story_creator_character_creation_substep.g.dart';

@riverpod
bool _isAIAutofillLoading(_IsAIAutofillLoadingRef ref) {
  return ref
      .watch(storyCreatorStateNotifierProvider)
      .characterStep
      .isAIAutofillInProgress;
}

@riverpod
bool _saveCharacter(_SaveCharacterRef ref) {
  return ref.watch(storyCreatorStateNotifierProvider).saveCharacter;
}

@riverpod
bool? _characterStepIsValid(_CharacterStepIsValidRef ref) {
  return ref.watch(storyCreatorStateNotifierProvider).characterStep.isValid;
}

class StoryCreatorCharacterCreationSubstep extends HookConsumerWidget {
  const StoryCreatorCharacterCreationSubstep({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final characterNameController = useTextEditingController(
      text: ref.read(characterStepStateProvider).inputCharacterName ?? '',
    );
    final characterDescriptionController = useTextEditingController(
      text:
          ref.read(characterStepStateProvider).inputCharacterDescription ?? '',
    );
    final characterDescriptionScrollController = useScrollController();
    final isAIAutofillLoading = ref.watch(_isAIAutofillLoadingProvider);
    final isCharacterNameAnimationStopped = useState(true);
    final characterNameEditable =
        isCharacterNameAnimationStopped.value && !isAIAutofillLoading;
    final isCharacterDescriptionAnimationStopped = useState(true);
    final characterDescriptionEditable =
        isCharacterDescriptionAnimationStopped.value && !isAIAutofillLoading;

    final validation =
        ref.watch(storyCreatorStateNotifierProvider).characterStep.validation;

    // Listen to the state changes of character name and description
    // after state change, and update the text fields accordingly if
    // the values are different, it means that the name and description are
    // updated from the AI autofill button.
    ref.listen<StoryCreatorState>(
      storyCreatorStateNotifierProvider,
      (prevState, nextState) {
        announceAiAutofillChanges(
          context: context,
          previousName: prevState?.characterStep.inputCharacterName,
          previousDescription:
              prevState?.characterStep.inputCharacterDescription,
          nextName: nextState.characterStep.inputCharacterName,
          nextDescription: nextState.characterStep.inputCharacterDescription,
        );

        // canceling previous animation
        // here we will have also a problem when moral will change faster
        // than the animation, we should cancel the previous animation
        // but that will require refactoring the whole animation
        if (prevState?.characterStep.inputCharacterName !=
            nextState.characterStep.inputCharacterName) {
          updateTextFieldInChunks(
            controller: characterNameController,
            duration: const Duration(milliseconds: 500),
            value: nextState.characterStep.inputCharacterName,
            context: context,
            onUpdateStart: () => isCharacterNameAnimationStopped.value = false,
            onUpdateEnd: () => isCharacterNameAnimationStopped.value = true,
          );
        }

        // canceling previous animation
        // here we will have also a problem when moral will change faster
        // than the animation, we should cancel the previous animation
        // but that will require refactoring the whole animation
        if (prevState?.characterStep.inputCharacterDescription !=
            nextState.characterStep.inputCharacterDescription) {
          updateTextFieldInChunks(
            context: context,
            controller: characterDescriptionController,
            scrollController: characterDescriptionScrollController,
            duration: const Duration(milliseconds: 3000),
            value: nextState.characterStep.inputCharacterDescription,
            onUpdateStart: () =>
                isCharacterDescriptionAnimationStopped.value = false,
            onUpdateEnd: () =>
                isCharacterDescriptionAnimationStopped.value = true,
          );
        }
      },
    );

    return AppScrollableContentScaffold(
      scrollableContent: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FormStepHeader(
            title: context.l10n.storyCreatorCustomCharacterStepTitle,
          ),
          CharacterInput(
            nameInputParams: CharacterInputParams(
              textController: characterNameController,
              onInputChanged: (value) => ref
                  .read(storyCreatorStateNotifierProvider.notifier)
                  .setCharacterName(value),
              isInputEnabled: characterNameEditable,
            ),
            descriptionInputParams: DescriptionInputParams(
              textController: characterDescriptionController,
              scrollController: characterDescriptionScrollController,
              onInputChanged: (value) => ref
                  .read(storyCreatorStateNotifierProvider.notifier)
                  .setCharacterDescription(value),
              isInputEnabled: characterDescriptionEditable,
            ),
            isAIAutofillLoading: ref.watch(_isAIAutofillLoadingProvider),
            onAIAutofillPressed: () => ref
                .read(storyCreatorStateNotifierProvider.notifier)
                .characterAIAutofill(),
            onAutofixPressed: () {
              final suggestedName = validation?.suggestedVersion.name ?? '';

              final suggestedDescription =
                  validation?.suggestedVersion.description ?? '';

              announceCharacterInputAutofix(
                context: context,
                name: suggestedName,
                description: suggestedDescription,
              );

              ref.read(storyCreatorStateNotifierProvider.notifier)
                ..setCharacterName(suggestedName)
                ..setCharacterDescription(suggestedDescription);
            },
            validation: validation,
          ),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(
              l10n.storyCreatorCustomCharacterStepSaveActionLabel,
            ),
            value: ref.watch(_saveCharacterProvider),
            onChanged: (checked) {
              if (checked != null) {
                ref
                    .read(storyCreatorStateNotifierProvider.notifier)
                    .toggleSaveCharacter(value: checked);
              }
            },
          ),
        ],
      ),
      bottomContent: const StoryCreatorNavigationButtons(),
    );
  }
}
