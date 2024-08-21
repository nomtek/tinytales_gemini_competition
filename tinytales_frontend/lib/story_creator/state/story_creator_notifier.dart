// ignore_for_file: avoid_redundant_argument_values

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/characters/characters.dart';
import 'package:tale_ai_frontend/characters/data/data.dart';
import 'package:tale_ai_frontend/debug/talker.dart';
import 'package:tale_ai_frontend/form/form.dart';
import 'package:tale_ai_frontend/story_creator/data/data.dart';
import 'package:tale_ai_frontend/story_creator/state/story_creator_state.dart';

part 'story_creator_notifier.g.dart';

@riverpod
class StoryCreatorStateNotifier extends _$StoryCreatorStateNotifier
    with RetryErrorAction {
  @override
  StoryCreatorState build() => StoryCreatorState.initial();

  void setLength(StoryLength? length) {
    assert(
      !state.isLoading,
      'Cannot set length when loading',
    );
    assert(
      state.error == null,
      'Cannot set length when error',
    );
    state = state.copyWith(
      lengthStep: state.lengthStep.copyWith(
        length: length,
      ),
    );
  }

  void setCharacterStepType(StepType type) {
    state = state.updateCharacterStepType(type);
  }

  void setCharacterName(String characterName) {
    assert(
      !state.isLoading,
      'Cannot set character name when loading',
    );
    assert(
      state.error == null,
      'Cannot set character name when error',
    );

    state = state.copyWith(
      characterStep: state.characterStep.copyWith(
        inputCharacterName: characterName,
        isValid: null,
        validation: null,
      ),
      shouldGenerateProposals: true,
    );
  }

  void setCharacterDescription(String characterDescription) {
    assert(
      !state.isLoading,
      'Cannot set character description when loading',
    );
    assert(
      state.error == null,
      'Cannot set character description when error',
    );

    state = state.copyWith(
      characterStep: state.characterStep.copyWith(
        inputCharacterDescription: characterDescription,
        isValid: null,
        validation: null,
      ),
      shouldGenerateProposals: true,
    );
  }

  void selectCharacter(
    Character character,
  ) {
    assert(
      !state.isLoading,
      'Cannot set character when loading',
    );
    assert(
      state.error == null,
      'Cannot set character when error',
    );

    state = state.copyWith(
      characterStep: state.characterStep.copyWith(
        selectedCharacter: character,
        isValid: null,
        validation: null,
      ),
      shouldGenerateProposals: true,
    );
  }

  Future<void> characterAIAutofill() async {
    assert(
      !state.isLoading,
      'Cannot do AI autofill when loading',
    );
    assert(
      state.error == null,
      'Cannot do AI autofill when error',
    );

    state = state.copyWith(
      characterStep: state.characterStep.copyWith(
        isAIAutofillInProgress: true,
      ),
    );

    try {
      final autofillCharacter = await ref
          .read(characterServiceProvider)
          .autofillCharacter(
            name: state.characterStep.inputCharacterName ?? '',
            description: state.characterStep.inputCharacterDescription ?? '',
          );
      state = state.copyWith(
        characterStep: state.characterStep.copyWith(
          inputCharacterName: autofillCharacter.name,
          inputCharacterDescription: autofillCharacter.description,
          isAIAutofillInProgress: false,
          isValid: null,
          validation: null,
        ),
        shouldGenerateProposals: true,
      );
    } catch (e, st) {
      ref.read(talkerProvider).handle(e, st);
      state = state.copyWith(
        characterStep: state.characterStep.copyWith(
          isAIAutofillInProgress: false,
        ),
        error: StoryCreatorError(
          message: e.toString(),
          action: StoryCreatorErrorAction.characterStepAiAutofill,
        ),
      );
    }
  }

  void toggleSaveCharacter({required bool value}) {
    assert(
      !state.isLoading,
      'Cannot toggle save character when loading',
    );
    assert(
      state.error == null,
      'Cannot toggle save character when error',
    );
    state = state.copyWith(
      saveCharacter: value,
    );
  }

  void setMoralStepType(StepType type) {
    state = state.updateMoralStepType(type);
  }

  void setStoryMoral(String moral) {
    assert(
      !state.isLoading,
      'Cannot update story moral when loading',
    );
    assert(
      state.error == null,
      'Cannot update story moral when error',
    );
    state = state.copyWith(
      moralStep: state.moralStep.copyWith(
        moral: moral,
        isValid: null,
        validation: null,
      ),
      shouldGenerateProposals: true,
    );
  }

  void selectStoryMoralSuggestions(List<String> suggestions) {
    assert(
      !state.isLoading,
      'Cannot select story moral suggestion when loading',
    );
    assert(
      state.error == null,
      'Cannot select story moral suggestion when error',
    );
    state = state.copyWith(
      moralStep: state.moralStep.copyWith(
        selectedSuggestionsIds: suggestions,
      ),
      shouldGenerateProposals: true,
    );
  }

  Future<void> moralAIAutofill() async {
    assert(
      !state.isLoading,
      'Cannot do AI autofill when loading',
    );
    assert(
      state.error == null,
      'Cannot do AI autofill when error',
    );

    state = state.copyWith(
      moralStep: state.moralStep.copyWith(isAIAutofillInProgress: true),
    );

    try {
      final aiMoral = await ref.read(storyCreatorServiceProvider).autofillMoral(
            description: state.moralStep.moral ?? '',
          );

      state = state.copyWith(
        moralStep: state.moralStep.copyWith(
          moral: aiMoral,
          isAIAutofillInProgress: false,
          isValid: null,
          validation: null,
        ),
        shouldGenerateProposals: true,
      );
    } catch (e, st) {
      ref.read(talkerProvider).handle(e, st);
      state = state.copyWith(
        moralStep: state.moralStep.copyWith(isAIAutofillInProgress: false),
        error: StoryCreatorError(
          message: e.toString(),
          action: StoryCreatorErrorAction.moralAIAutofill,
        ),
      );
    }
  }

  void setStoryProposal(StoryProposal proposal) {
    assert(
      !state.isLoading,
      'Cannot set story overview when loading',
    );
    assert(
      state.error == null,
      'Cannot set story overview when error',
    );
    state = state.copyWith(
      proposalsStep: state.proposalsStep.copyWith(
        selectedProposalIndex:
            state.proposalsStep.storyProposals.indexOf(proposal),
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
    state = state.copyWith(isLoading: true);
    final actionResult = await _performStepAction(state.currentStep);

    switch (actionResult) {
      case StepActionResult.success:
        _goToNextStep();
      case StepActionResult.failure:
        state = state.copyWith(isLoading: false);
    }
  }

  void _goToNextStep() {
    final currentStep = state.currentStep;
    final nextStep = StoryCreatorStep.values[currentStep.index + 1];
    final newState = state.copyWith(
      currentStep: nextStep,
      isLoading: false,
    );
    state = newState;
  }

  Future<StepActionResult> _performStepAction(StoryCreatorStep step) async {
    switch (step) {
      case StoryCreatorStep.length:
        await _checkIfShouldSkipCharacterSelection();
        return StepActionResult.success;
      case StoryCreatorStep.character:
        return _mainCharacterStepAction(state.characterStep);
      case StoryCreatorStep.moral:
        return _moralStepAction(state);
      case StoryCreatorStep.proposals:
        assert(
          false,
          'Proposals step should not be handled here. '
          'Check finishStoryCreationAction that should be called instead.',
        );
        return StepActionResult.failure;
    }
  }

  Future<void> _checkIfShouldSkipCharacterSelection() async {
    if (!state.shouldIncludeCharacterSelectionStep) return;

    final isCharactersListEmpty =
        await ref.read(charactersServiceProvider).isCharactersCollectionEmpty();

    var newState = state.copyWith();
    if (isCharactersListEmpty) {
      newState = newState.copyWith(shouldIncludeCharacterSelectionStep: false);
      newState = newState.updateCharacterStepType(StepType.creation);
    }
    state = newState;
  }

  Future<StepActionResult> _mainCharacterStepAction(
    CharacterStepState characterStep,
  ) async {
    try {
      final isCharacterStepValid = characterStep.isValid;
      if (isCharacterStepValid != null && isCharacterStepValid) {
        return StepActionResult.success;
      }

      final characterValidation =
          await ref.read(characterServiceProvider).validateCharacter(
                name: characterStep.effectiveCharacterName,
                description: characterStep.effectiveCharacterDescription,
              );

      switch (characterValidation.validationStatus) {
        case ValidationStatus.inappropriate:
          state = state.copyWith(
            characterStep: characterStep.copyWith(
              isValid: false,
              validation: characterValidation,
              // Handles situations when selected character is inappropriate
              // It is corner case, but worth to handle it
              type: StepType.creation,
              inputCharacterName: characterStep.effectiveCharacterName,
              inputCharacterDescription:
                  characterStep.effectiveCharacterDescription,
            ),
          );
          return StepActionResult.failure;
        case ValidationStatus.needsImprovement:
          state = state.copyWith(
            characterStep: characterStep.copyWith(
              isValid: true,
              validation: characterValidation,
            ),
          );

          // We want to skip improvement step if we are in selection mode
          if (state.characterStep.type == StepType.selection) {
            return StepActionResult.success;
          }

          return StepActionResult.failure;
        case ValidationStatus.excellent:
          state = state.copyWith(
            characterStep: characterStep.copyWith(
              isValid: true,
              validation: characterValidation,
            ),
          );
          return StepActionResult.success;
      }
    } catch (e, st) {
      ref.read(talkerProvider).handle(e, st);
      state = state.copyWith(
        error: StoryCreatorError(
          message: e.toString(),
          action: StoryCreatorErrorAction.mainCharacterStepAction,
        ),
      );
      return StepActionResult.failure;
    }
  }

  Future<StepActionResult> _moralStepAction(
    StoryCreatorState storyCreatorState,
  ) async {
    try {
      late StepActionResult validationAction;
      switch (storyCreatorState.moralStep.type) {
        case StepType.selection:
          validationAction = StepActionResult.success;
        case StepType.creation:
          validationAction =
              await _moralValidationAction(storyCreatorState.moralStep);
      }
      switch (validationAction) {
        case StepActionResult.failure:
          return StepActionResult.failure;
        case StepActionResult.success:
          if (storyCreatorState.shouldGenerateProposals) {
            await _proposalsGenerationAction(
              storyCreatorState,
            );
          }
          return StepActionResult.success;
      }
    } catch (e, st) {
      ref.read(talkerProvider).handle(e, st);
      state = storyCreatorState.copyWith(
        error: StoryCreatorError(
          message: e.toString(),
          action: StoryCreatorErrorAction.moralStepAction,
        ),
      );
      return StepActionResult.failure;
    }
  }

  Future<StepActionResult> _moralValidationAction(
    MoralStepState moralStep,
  ) async {
    final isMoralStepValid = moralStep.isValid;
    if (isMoralStepValid != null && isMoralStepValid) {
      return StepActionResult.success;
    }

    final moralValidation =
        await ref.read(storyCreatorServiceProvider).validateMoral(
              description: moralStep.moral ?? '',
            );

    switch (moralValidation.validationStatus) {
      case ValidationStatus.inappropriate:
        state = state.copyWith(
          moralStep: moralStep.copyWith(
            isValid: false,
            validation: moralValidation,
          ),
        );
        return StepActionResult.failure;
      case ValidationStatus.needsImprovement:
        state = state.copyWith(
          moralStep: moralStep.copyWith(
            isValid: true,
            validation: moralValidation,
          ),
        );
        return StepActionResult.failure;
      case ValidationStatus.excellent:
        state = state.copyWith(
          moralStep: moralStep.copyWith(
            isValid: true,
            validation: moralValidation,
          ),
        );
        return StepActionResult.success;
    }
  }

  Future<StepActionResult> finishStoryCreationAction() async {
    state = state.copyWith(isLoading: true);
    final storyCreatorState = state;
    try {
      assert(
        storyCreatorState.characterStep.effectiveCharacterName.isNotEmpty,
        'Character name can not be empty at the end of the story creation',
      );
      assert(
        storyCreatorState
            .characterStep.effectiveCharacterDescription.isNotEmpty,
        'Character description can not be empty '
        'at the end of the story creation',
      );
      assert(
        storyCreatorState.moralStep.moral != null ||
            storyCreatorState.moralStep.selectedSuggestionsIds.isNotEmpty,
        'Story moral cannot be null or moral suggestions empty '
        'at the end of the story creation',
      );
      assert(
        storyCreatorState.proposalsStep.selectedProposalIndex != null,
        'Proposal index can not be null at the end of the story creation',
      );

      if (storyCreatorState.saveCharacter) {
        await ref.read(characterServiceProvider).createCharacter(
              name: storyCreatorState.characterStep.inputCharacterName ?? '',
              description:
                  storyCreatorState.characterStep.inputCharacterDescription,
            );
      }

      final storyId = await ref.read(storyCreatorServiceProvider).createStory(
            characterName:
                storyCreatorState.characterStep.effectiveCharacterName,
            characterDescription:
                storyCreatorState.characterStep.effectiveCharacterDescription,
            moral: storyCreatorState.moralStep.moral ?? '',
            proposals: storyCreatorState.proposalsStep.storyProposals,
            chosenProposalIndex:
                storyCreatorState.proposalsStep.selectedProposalIndex ?? 0,
            storyLength:
                storyCreatorState.lengthStep.length ?? StoryLength.short,
            suggestions: storyCreatorState.moralStep.selectedSuggestionsIds,
          );

      state = storyCreatorState.copyWith(
        storyId: storyId,
        isLoading: false,
      );

      return StepActionResult.success;
    } catch (e, st) {
      ref.read(talkerProvider).handle(e, st);

      state = state.copyWith(
        isLoading: false,
        error: StoryCreatorError(
          message: e.toString(),
          action: StoryCreatorErrorAction.finishStoryCreationAction,
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

    if (state.currentStep == StoryCreatorStep.character &&
        state.characterStep.type == StepType.creation &&
        state.shouldIncludeCharacterSelectionStep) {
      setCharacterStepType(StepType.selection);
      return;
    }

    if (state.currentStep == StoryCreatorStep.moral &&
        state.moralStep.type == StepType.creation) {
      setMoralStepType(StepType.selection);
      return;
    }

    final currentStep = state.currentStep;
    final nextStep = StoryCreatorStep.values[currentStep.index - 1];
    final newState = state.copyWith(
      currentStep: nextStep,
      error: null,
    );
    state = newState;
  }

  Future<void> _proposalsGenerationAction(
    StoryCreatorState storyCreatorState,
  ) async {
    assert(
      storyCreatorState.moralStep.moral != null ||
          storyCreatorState.moralStep.selectedSuggestionsIds.isNotEmpty,
      'Proposal generation requires moral or suggestions',
    );

    final proposals = await ref
        .read(storyCreatorServiceProvider)
        .createStoryProposals(
          taleDescription: storyCreatorState.moralStep.moral,
          characterName: storyCreatorState.characterStep.effectiveCharacterName,
          characterDescription:
              storyCreatorState.characterStep.effectiveCharacterDescription,
          suggestions: storyCreatorState.moralStep.selectedSuggestionsIds,
        );

    assert(
      proposals.isNotEmpty,
      'StoryProposalsStep requires proposals list',
    );
    state = storyCreatorState.copyWith(
      proposalsStep: storyCreatorState.proposalsStep.copyWith(
        selectedProposalIndex: null,
        storyProposals: proposals,
      ),
      shouldGenerateProposals: false,
    );
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
      case StoryCreatorErrorAction.characterStepAiAutofill:
        await characterAIAutofill();
      case StoryCreatorErrorAction.mainCharacterStepAction:
        await _handleStepAction(
          _mainCharacterStepAction(state.characterStep),
        );
      case StoryCreatorErrorAction.moralAIAutofill:
        await moralAIAutofill();
      case StoryCreatorErrorAction.moralStepAction:
        await _handleStepAction(_moralStepAction(state));
      case StoryCreatorErrorAction.finishStoryCreationAction:
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
