import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/story/data/life_value.dart';
import 'package:tale_ai_frontend/story/data/story_service.dart';
import 'package:tale_ai_frontend/story_creator/state/state.dart';

part 'moral_providers.g.dart';

@riverpod
StepType storyMoralStepType(StoryMoralStepTypeRef ref) {
  final moralStepType =
      ref.watch(storyCreatorStateNotifierProvider).moralStep.type;
  return moralStepType;
}

@riverpod
Future<List<LifeValue>> lifeValues(LifeValuesRef ref) {
  return ref.watch(storyServiceProvider).getLifeValues();
}
