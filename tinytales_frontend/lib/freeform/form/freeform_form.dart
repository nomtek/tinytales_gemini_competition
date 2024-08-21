import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/async_value_status.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/freeform/form/steps/steps.dart';
import 'package:tale_ai_frontend/freeform/state/freeform_state.dart';
import 'package:tale_ai_frontend/freeform/state/state.dart';
import 'package:tale_ai_frontend/router/router.dart';
import 'package:tale_ai_frontend/widgets/widgets.dart';

part 'freeform_form.g.dart';

@riverpod
FreeformStep _currentFreeformStep(_CurrentFreeformStepRef ref) {
  final freeformState = ref.watch(freeformNotifierProvider);
  return freeformState.currentStep;
}

@riverpod
String? _createdStoryId(_CreatedStoryIdRef ref) {
  final freeformState = ref.watch(freeformNotifierProvider);
  return freeformState.storyId;
}

class FreeformForm extends HookConsumerWidget {
  const FreeformForm({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final freeformState = ref.watch(freeformNotifierProvider);
    ref.listen<String?>(
      _createdStoryIdProvider,
      (_, nextState) {
        if (nextState != null) {
          StoryPageRoute(storyId: nextState).go(context);
        }
      },
    );

    switch (freeformState.screenState) {
      case AsyncValueStatus.data:
        return const _FreeformStepContent();
      case AsyncValueStatus.loading:
        return _FreeformLoading(
          currentStep: freeformState.currentStep,
        );
      case AsyncValueStatus.error:
        return const _FreeformFormError();
    }
  }
}

class _FreeformStepContent extends HookConsumerWidget {
  const _FreeformStepContent();

  static const _steps = [
    FreeformContentStep(),
    FreeformProposalsStep(),
  ];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();

    final currentStep = ref.watch(_currentFreeformStepProvider);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (currentStep.index != pageController.page &&
          pageController.hasClients) {
        pageController.animateToPage(
          currentStep.index,
          duration: pageAnimationDuration,
          curve: pageAnimationCurve,
        );
      }
    });

    return Column(
      children: [
        StepProgressBar(stepsCount: FreeformStep.values.length),
        Expanded(
          child: PageView.builder(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _steps.length,
            itemBuilder: (context, index) {
              return PageHorizontalPadding(
                child: _steps[index],
              );
            },
            onPageChanged: (value) {
              ref
                  .read(stepProgressBarNotifierProvider.notifier)
                  .updateStep(value);
            },
          ),
        ),
      ],
    );
  }
}

class _FreeformFormError extends ConsumerWidget {
  const _FreeformFormError();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormError(
      onTryAgain: () {
        ref.read(freeformNotifierProvider.notifier).retryErrorAction();
      },
      onClose: () {
        ref.read(freeformNotifierProvider.notifier).clearError();
      },
    );
  }
}

class _FreeformLoading extends StatelessWidget {
  const _FreeformLoading({
    required this.currentStep,
  });

  final FreeformStep currentStep;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StepProgressBar(stepsCount: FreeformStep.values.length),
        Expanded(
          child: Center(
            child: currentStep == FreeformStep.proposals
                ? const StoryCreateLoader()
                : const CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
}
