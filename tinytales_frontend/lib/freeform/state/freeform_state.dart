// ignore_for_file: avoid_redundant_argument_values

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/async_value_status.dart';
import 'package:tale_ai_frontend/debug/talker.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/freeform/data/freeform_proposals.dart';
import 'package:tale_ai_frontend/freeform/data/freeform_service.dart';

part 'freeform_state.g.dart';

@riverpod
class FreeformNotifier extends _$FreeformNotifier with RetryErrorAction {
  @override
  FreeformState build() => FreeformState.initial();

  void setFreeformContent(String content) {
    assert(
      !state.isLoading,
      'Cannot update freeform content when loading',
    );
    assert(
      state.error == null,
      'Cannot update freeform content when error',
    );
    state = state.copyWith(
      contentStep: state.contentStep.copyWith(
        content: content,
        isValid: null,
        validation: null,
      ),
      shouldGenerateProposals: true,
    );
  }

  void setStoryProposal(FreeformProposal proposal) {
    assert(
      !state.isLoading,
      'Cannot set story proposal when loading',
    );
    assert(
      state.error == null,
      'Cannot set story proposal when error',
    );
    state = state.copyWith(
      proposalsStep: state.proposalsStep.copyWith(
        selectedProposalIndex: state.proposalsStep.proposals.indexOf(proposal),
      ),
    );
  }

  Future<void> nextStep() async {
    assert(
      !state.isLoading,
      'Cannot go to next step when loading',
    );
    assert(
      state.canGoFurther,
      'Cannot go to next step when not ready',
    );
    assert(
      state.error == null,
      'Cannot go to next step when error',
    );
    final actionResult = await _performStepAction(state.currentStep);

    switch (actionResult) {
      case StepActionResult.success:
        _goToNextStep();
      case StepActionResult.failure:
        state = state.copyWith(isLoading: false);
    }
  }

  Future<StepActionResult> _performStepAction(FreeformStep step) async {
    switch (step) {
      case FreeformStep.content:
        state = state.copyWith(isLoading: true);
        return _contentStepAction();
      case FreeformStep.proposals:
        assert(
          false,
          'Proposals step should not be handled here',
        );
        return StepActionResult.failure;
    }
  }

  Future<StepActionResult> _contentStepAction() async {
    try {
      final validationAction = await _contentValidationAction();
      switch (validationAction) {
        case StepActionResult.failure:
          return StepActionResult.failure;
        case StepActionResult.success:
          if (state.shouldGenerateProposals) {
            return _proposalsGenerationAction();
          }
          return StepActionResult.success;
      }
    } catch (e, st) {
      ref.read(talkerProvider).handle(e, st);
      state = state.copyWith(
        error: FreeformError(
          action: FreeformErrorAction.contentStepAction,
          error: e.toString(),
        ),
      );
      return StepActionResult.failure;
    }
  }

  Future<StepActionResult> _contentValidationAction() async {
    final isContentStepValid = state.contentStep.isValid;
    if (isContentStepValid != null && isContentStepValid) {
      return StepActionResult.success;
    }

    final contentValidation =
        await ref.read(freeformServiceProvider).validateContent(
              content: state.contentStep.content ?? '',
            );

    switch (contentValidation.validationStatus) {
      case ValidationStatus.inappropriate:
        state = state.copyWith(
          contentStep: state.contentStep.copyWith(
            isValid: false,
            validation: contentValidation,
          ),
        );
        return StepActionResult.failure;
      case ValidationStatus.needsImprovement:
        state = state.copyWith(
          contentStep: state.contentStep.copyWith(
            isValid: true,
            validation: contentValidation,
          ),
        );
        return StepActionResult.failure;
      case ValidationStatus.excellent:
        state = state.copyWith(
          contentStep: state.contentStep.copyWith(
            isValid: true,
            validation: contentValidation,
          ),
        );
        return StepActionResult.success;
    }
  }

  Future<StepActionResult> _proposalsGenerationAction() async {
    final proposals =
        await ref.read(freeformServiceProvider).createStoryProposals(
              content: state.contentStep.content ?? '',
            );

    assert(
      proposals.isNotEmpty,
      'StoryProposalsStep requires proposals list',
    );
    state = state.copyWith(
      proposalsStep: state.proposalsStep.copyWith(
        proposals: proposals,
      ),
      shouldGenerateProposals: false,
    );

    return StepActionResult.success;
  }

  void _goToNextStep() {
    final currentStep = state.currentStep;
    final nextStep = FreeformStep.values[currentStep.index + 1];
    final newState = state.copyWith(
      currentStep: nextStep,
      isLoading: false,
    );
    state = newState;
  }

  Future<StepActionResult> finishStoryCreationAction() async {
    try {
      state = state.copyWith(isLoading: true);
      final freeformState = state;
      assert(
        freeformState.contentStep.content != null,
        'Content can not be null at the end of the story creation',
      );
      assert(
        freeformState.proposalsStep.selectedProposalIndex != null,
        'Proposal index can not be null at the end of the story creation',
      );

      final storyId = await ref.read(freeformServiceProvider).createStory(
            proposals: freeformState.proposalsStep.proposals,
            chosenProposalIndex:
                freeformState.proposalsStep.selectedProposalIndex ?? 0,
          );

      state = freeformState.copyWith(
        storyId: storyId,
        isLoading: false,
      );

      return StepActionResult.success;
    } catch (e, st) {
      ref.read(talkerProvider).handle(e, st);
      state = state.copyWith(
        isLoading: false,
        error: FreeformError(
          action: FreeformErrorAction.finishStoryCreationAction,
          error: e.toString(),
        ),
      );
      return StepActionResult.failure;
    }
  }

  void previousStep() {
    assert(
      !state.isLoading,
      'Cannot go to previous step when loading',
    );
    final currentStep = state.currentStep;
    final nextStep = FreeformStep.values[currentStep.index - 1];
    final newState = state.copyWith(
      currentStep: nextStep,
      error: null,
    );
    state = newState;
  }

  void clearError() {
    state = state.copyWith(
      error: null,
    );
  }

  @override
  Future<void> retryErrorAction() async {
    final error = state.error;
    state = state.copyWith(
      error: null,
    );
    if (error == null) {
      return;
    }
    switch (error.action) {
      case FreeformErrorAction.contentStepAction:
        await _handleStepAction(_contentStepAction());
      case FreeformErrorAction.finishStoryCreationAction:
        await finishStoryCreationAction();
    }
  }

  Future<void> _handleStepAction(Future<StepActionResult> action) async {
    state = state.copyWith(isLoading: true);
    final actionResult = await action;
    switch (actionResult) {
      case StepActionResult.success:
        _goToNextStep();
      case StepActionResult.failure:
        state = state.copyWith(isLoading: false);
    }
  }
}

@CopyWith()
class FreeformState with EquatableMixin {
  const FreeformState({
    this.contentStep = const ContentStepState(),
    this.proposalsStep = const FreeformProposalsState(),
    this.currentStep = FreeformStep.content,
    this.shouldGenerateProposals = true,
    this.isLoading = false,
    this.storyId,
    this.error,
  });

  factory FreeformState.initial() => const FreeformState();

  final ContentStepState contentStep;
  final FreeformProposalsState proposalsStep;
  final FreeformStep currentStep;
  final bool shouldGenerateProposals;
  final bool isLoading;
  final String? storyId;
  final FreeformError? error;

  @override
  List<Object?> get props => [
        contentStep,
        proposalsStep,
        currentStep,
        shouldGenerateProposals,
        isLoading,
        storyId,
        error,
      ];
}

@CopyWith()
class ContentStepState extends FormStepState with EquatableMixin {
  const ContentStepState({
    this.content,
    this.validation,
    super.isValid,
  });

  final String? content;
  final Validation? validation;

  @override
  bool canProceed() {
    final content = this.content;
    return content != null && content.isNotEmpty;
  }

  @override
  List<Object?> get props => [
        content,
        isValid,
        validation,
      ];
}

@CopyWith()
class FreeformProposalsState extends FormStepState with EquatableMixin {
  const FreeformProposalsState({
    this.selectedProposalIndex,
    this.proposals = const [],
  }) : super(isValid: true);

  final int? selectedProposalIndex;
  final List<FreeformProposal> proposals;

  @override
  bool canProceed() {
    return selectedProposalIndex != null;
  }

  @override
  List<Object?> get props => [
        selectedProposalIndex,
        proposals,
        isValid,
      ];
}

enum FreeformStep { content, proposals }

enum FreeformErrorAction {
  contentStepAction,
  finishStoryCreationAction,
}

class FreeformError with EquatableMixin {
  const FreeformError({
    required this.action,
    required this.error,
  });

  final FreeformErrorAction action;
  final String? error;

  @override
  List<Object?> get props => [action, error];
}

extension ButtonsExtension on FreeformState {
  bool get canCreateStory {
    return currentStep == FreeformStep.proposals;
  }

  bool get canGoFurther {
    switch (currentStep) {
      case FreeformStep.content:
        return contentStep.canProceed();
      case FreeformStep.proposals:
        return proposalsStep.canProceed();
    }
  }
}

extension FreeformFormStepStatus on FreeformState {
  AsyncValueStatus get screenState {
    final error = this.error;
    if (error != null && !isLoading) {
      return AsyncValueStatus.error;
    } else if (error == null && isLoading) {
      return AsyncValueStatus.loading;
    }
    return AsyncValueStatus.data;
  }
}
