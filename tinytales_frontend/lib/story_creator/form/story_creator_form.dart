import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/router/router.dart';
import 'package:tale_ai_frontend/story_creator/form/steps/steps.dart';
import 'package:tale_ai_frontend/story_creator/state/state.dart';
import 'package:tale_ai_frontend/theme/theme_extensions.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

part 'story_creator_form.g.dart';

@riverpod
String? _createdStoryId(_CreatedStoryIdRef ref) {
  final storyCreatorState = ref.watch(storyCreatorStateNotifierProvider);
  return storyCreatorState.storyId;
}

@riverpod
({Validation? validation, StepType stepType}) _characterValidation(
  _CharacterValidationRef ref,
) {
  final characterStep =
      ref.watch(storyCreatorStateNotifierProvider).characterStep;
  return (
    validation: characterStep.validation,
    stepType: characterStep.type,
  );
}

@riverpod
Validation? _moralValidation(
  _MoralValidationRef ref,
) {
  final moralValidation =
      ref.watch(storyCreatorStateNotifierProvider).moralStep.validation;
  return moralValidation;
}

class StoryCreatorForm extends HookConsumerWidget {
  const StoryCreatorForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageIndex = ref.watch(currentStepIndexProvider);
    final pageController = usePageController(initialPage: pageIndex);
    ref
      ..listen<String?>(
        _createdStoryIdProvider,
        (_, nextState) {
          if (nextState != null) {
            StoryPageRoute(storyId: nextState).go(context);
          }
        },
      )
      ..listen(
        _characterValidationProvider,
        (_, nextState) {
          final validation = nextState.validation;
          if (validation != null && nextState.stepType == StepType.creation) {
            announceCharacterInputValidation(
              context: context,
              validation: validation,
            );
          }
        },
      )
      ..listen(_moralValidationProvider, (_, nextState) {
        final validation = nextState;

        if (validation != null) {
          announceMoralInputValidation(
            context: context,
            validation: validation,
          );
        }
      });

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref
              .read(stepProgressBarNotifierProvider.notifier)
              .updateStep(pageIndex);

          if (!pageController.hasClients) return;
          if (pageController.page == pageIndex) {
            return;
          }
          pageController.animateToPage(
            pageIndex,
            duration: pageAnimationDuration,
            curve: pageAnimationCurve,
          );
        });
        return null;
      },
      [pageIndex],
    );

    final steps = [
      const StoryCreatorLengthStep(),
      const StoryCreatorCharacterStep(),
      const StoryCreatorMoralStep(),
      const StoryCreatorProposalsStep(),
    ];

    return Column(
      children: [
        ColoredBox(
          color: context.colors.surfaceContainerHigh,
          child: StepProgressBar(
            stepsCount: StoryCreatorStep.values.length,
          ),
        ),
        Expanded(
          child: PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => StepContentWrapper(
              loader:
                  index == steps.length - 1 ? const StoryCreateLoader() : null,
              child: steps[index],
            ),
            itemCount: steps.length,
            controller: pageController,
          ),
        ),
      ],
    );
  }
}
