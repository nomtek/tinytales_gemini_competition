import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tale_ai_frontend/story_creator/form/steps/moral/moral_providers.dart';
import 'package:tale_ai_frontend/story_creator/form/steps/moral/story_creator_moral_creation_substep.dart';
import 'package:tale_ai_frontend/story_creator/form/steps/moral/story_creator_moral_selection_substep.dart';
import 'package:tale_ai_frontend/story_creator/state/state.dart';

class StoryCreatorMoralStep extends ConsumerWidget {
  const StoryCreatorMoralStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stepType = ref.watch(storyMoralStepTypeProvider);

    switch (stepType) {
      case StepType.selection:
        return const StoryCreatorMoralSelectionSubstep();
      case StepType.creation:
        return const StorCreatorMoralCreationSubstep();
    }
  }
}
