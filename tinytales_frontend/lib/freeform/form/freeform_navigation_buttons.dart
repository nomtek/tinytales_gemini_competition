import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/freeform/state/state.dart';

part 'freeform_navigation_buttons.g.dart';

@riverpod
bool _isProceedButtonEnabled(_IsProceedButtonEnabledRef ref) {
  final freeformState = ref.watch(freeformNotifierProvider);
  return freeformState.canGoFurther &&
      !freeformState.isLoading &&
      freeformState.error == null;
}

@riverpod
bool _isGoBackEnabled(_IsGoBackEnabledRef ref) {
  final freeformState = ref.watch(freeformNotifierProvider);
  return freeformState.currentStep.index > 0 && !freeformState.isLoading;
}

@riverpod
bool _isCreateButtonVisible(_IsCreateButtonVisibleRef ref) {
  final freeformState = ref.watch(freeformNotifierProvider);
  return freeformState.canCreateStory;
}

class FreeformNavigationButtons extends ConsumerWidget {
  const FreeformNavigationButtons({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormNavigationButtons(
      isProceedButtonEnabled: ref.watch(_isProceedButtonEnabledProvider),
      onProceedButtonPressed: () {
        ref.read(freeformNotifierProvider.notifier).nextStep();
      },
      isGoBackVisible: ref.watch(_isGoBackEnabledProvider),
      onGoBackButtonPressed: () {
        ref.read(freeformNotifierProvider.notifier).previousStep();
      },
      isCreateButtonVisible: ref.watch(_isCreateButtonVisibleProvider),
      onCreteButtonPressed: () {
        ref.read(freeformNotifierProvider.notifier).finishStoryCreationAction();
      },
    );
  }
}
