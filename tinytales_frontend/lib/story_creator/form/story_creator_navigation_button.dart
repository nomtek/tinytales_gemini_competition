import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/story_creator/state/state.dart';

part 'story_creator_navigation_button.g.dart';

@riverpod
bool _isNextButtonEnabled(_IsNextButtonEnabledRef ref) {
  final storyCreatorState = ref.watch(storyCreatorStateNotifierProvider);
  return storyCreatorState.canGoFurther &&
      !storyCreatorState.isLoading &&
      storyCreatorState.error == null;
}

@riverpod
bool _goBackEnabled(_GoBackEnabledRef ref) {
  final storyCreatorState = ref.watch(storyCreatorStateNotifierProvider);
  return storyCreatorState.currentStep.index > 0 &&
      !storyCreatorState.isLoading;
}

@riverpod
bool _isCreateButtonVisible(_IsCreateButtonVisibleRef ref) {
  final storyCreatorState = ref.watch(storyCreatorStateNotifierProvider);
  return storyCreatorState.canCreateStory;
}

class StoryCreatorNavigationButtons extends ConsumerWidget {
  const StoryCreatorNavigationButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormNavigationButtons(
      isProceedButtonEnabled: ref.watch(_isNextButtonEnabledProvider),
      onProceedButtonPressed: () =>
          ref.read(storyCreatorStateNotifierProvider.notifier).nextStep(),
      isGoBackVisible: ref.watch(_goBackEnabledProvider),
      onGoBackButtonPressed: () =>
          ref.read(storyCreatorStateNotifierProvider.notifier).previousStep(),
      isCreateButtonVisible: ref.watch(_isCreateButtonVisibleProvider),
      onCreteButtonPressed: () => ref
          .read(storyCreatorStateNotifierProvider.notifier)
          .finishStoryCreationAction(),
    );
  }
}
