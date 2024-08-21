import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/story_creator/form/steps/character/story_creator_character_creation_substep.dart';
import 'package:tale_ai_frontend/story_creator/form/steps/character/story_creator_character_selection_substep.dart';
import 'package:tale_ai_frontend/story_creator/state/state.dart';

part 'story_creator_character_step.g.dart';

@riverpod
CharacterStepState characterStepState(CharacterStepStateRef ref) {
  return ref.watch(storyCreatorStateNotifierProvider).characterStep;
}

@riverpod
StepType characterStepType(CharacterStepTypeRef ref) {
  return ref.watch(storyCreatorStateNotifierProvider).characterStep.type;
}

class StoryCreatorCharacterStep extends ConsumerWidget {
  const StoryCreatorCharacterStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (ref.watch(characterStepTypeProvider)) {
      case StepType.selection:
        return const StoryCreatorCharacterSelectionSubstep();
      case StepType.creation:
        return const StoryCreatorCharacterCreationSubstep();
    }
  }
}
