import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/async_value_status.dart';
import 'package:tale_ai_frontend/form/proposals_view.dart';
import 'package:tale_ai_frontend/story_creator/state/state.dart';

part 'providers.g.dart';

// providers are gathered in a single file
// to make it easier to import them and generate only one file

@riverpod
int currentStepIndex(CurrentStepIndexRef ref) {
  final storyCreatorState = ref.watch(storyCreatorStateNotifierProvider);
  return storyCreatorState.currentStep.index;
}

@riverpod
StoryLength? storyLength(StoryLengthRef ref) {
  final storyCreatorState = ref.watch(storyCreatorStateNotifierProvider);
  return storyCreatorState.lengthStep.length;
}

@riverpod
MoralStepState storyMoralStep(StoryMoralStepRef ref) {
  final storyCreatorState = ref.watch(storyCreatorStateNotifierProvider);
  return storyCreatorState.moralStep;
}

@riverpod
ProposalsViewState storyProposalsStep(StoryProposalsStepRef ref) {
  final storyCreatorState = ref.watch(storyCreatorStateNotifierProvider);
  return storyCreatorState.proposalsStep;
}

@riverpod
AsyncValueStatus formStepStatus(FormStepStatusRef ref) {
  final storyCreatorState = ref.watch(storyCreatorStateNotifierProvider);
  return storyCreatorState.stepStatus;
}
