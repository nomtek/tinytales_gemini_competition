import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:tale_ai_frontend/async_value_status.dart';
import 'package:tale_ai_frontend/characters/characters.dart';
import 'package:tale_ai_frontend/extensions.dart';
import 'package:tale_ai_frontend/form/form.dart';

part 'story_creator_state.g.dart';

@CopyWith()
class StoryCreatorState with EquatableMixin {
  const StoryCreatorState({
    this.lengthStep = const StoryLengthStepState(),
    this.characterStep = const CharacterStepState(),
    this.saveCharacter = false,
    this.moralStep = const MoralStepState(),
    this.proposalsStep = const ProposalsViewState(),
    this.currentStep = StoryCreatorStep.length,
    this.shouldGenerateProposals = true,
    this.shouldIncludeCharacterSelectionStep = true,
    this.isLoading = false,
    this.storyId,
    this.error,
  });

  factory StoryCreatorState.initial() => const StoryCreatorState();

  final StoryLengthStepState lengthStep;
  final CharacterStepState characterStep;
  final bool saveCharacter;
  final MoralStepState moralStep;
  final ProposalsViewState proposalsStep;
  final StoryCreatorStep currentStep;
  final bool shouldGenerateProposals;
  final bool shouldIncludeCharacterSelectionStep;
  final bool isLoading;
  final String? storyId;
  final StoryCreatorError? error;

  @override
  List<Object?> get props => [
        lengthStep,
        currentStep,
        characterStep,
        saveCharacter,
        moralStep,
        proposalsStep,
        shouldGenerateProposals,
        shouldIncludeCharacterSelectionStep,
        isLoading,
        storyId,
        error,
      ];
}

@CopyWith()
class StoryLengthStepState extends FormStepState with EquatableMixin {
  const StoryLengthStepState({
    this.length,
  }) : super(isValid: true);

  final StoryLength? length;

  @override
  bool canProceed() => length != null;

  @override
  List<Object?> get props => [length, isValid];
}

@CopyWith()
class CharacterStepState extends FormStepState with EquatableMixin {
  const CharacterStepState({
    this.type = StepType.selection,
    this.selectedCharacter,
    this.inputCharacterName,
    this.inputCharacterDescription,
    this.validation,
    this.isAIAutofillInProgress = false,
    super.isValid,
  });

  String get effectiveCharacterName {
    final selectedCharacter = this.selectedCharacter;
    if (selectedCharacter != null) {
      return selectedCharacter.name;
    }
    return inputCharacterName ?? '';
  }

  String get effectiveCharacterDescription {
    final selectedCharacter = this.selectedCharacter;
    if (selectedCharacter != null) {
      return selectedCharacter.userDescription ?? '';
    }
    return inputCharacterDescription ?? '';
  }

  final StepType type;
  final Character? selectedCharacter;
  final String? inputCharacterName;
  final String? inputCharacterDescription;
  final Validation? validation;
  final bool isAIAutofillInProgress;

  @override
  bool canProceed() {
    final characterName = inputCharacterName;
    final characterDescription = inputCharacterDescription;
    return ((characterName.isNotNullOrBlank &&
                characterDescription.isNotNullOrBlank) ||
            selectedCharacter != null) &&
        !isAIAutofillInProgress;
  }

  @override
  List<Object?> get props => [
        type,
        inputCharacterName,
        selectedCharacter,
        inputCharacterDescription,
        validation,
        isAIAutofillInProgress,
        isValid,
      ];
}

@CopyWith()
class MoralStepState extends FormStepState with EquatableMixin {
  const MoralStepState({
    this.type = StepType.selection,
    this.selectedSuggestionsIds = const [],
    this.moral,
    this.validation,
    this.isAIAutofillInProgress = false,
    super.isValid,
  });

  final StepType type;
  final String? moral;
  final List<String> selectedSuggestionsIds;
  final Validation? validation;
  final bool isAIAutofillInProgress;

  @override
  bool canProceed() {
    final storyMoral = moral;
    return (storyMoral.isNotNullOrBlank || selectedSuggestionsIds.isNotEmpty) &&
        !isAIAutofillInProgress;
  }

  @override
  List<Object?> get props => [
        type,
        moral,
        selectedSuggestionsIds,
        validation,
        isAIAutofillInProgress,
        isValid,
      ];
}

enum StoryCreatorStep {
  length,
  character,
  moral,
  proposals,
}

enum StepType {
  selection,
  creation,
}

enum StoryLength {
  short,
  medium,
  long,
}

enum StoryCreatorErrorAction {
  characterStepAiAutofill,
  moralAIAutofill,
  mainCharacterStepAction,
  moralStepAction,
  finishStoryCreationAction
}

@CopyWith()
class StoryCreatorError with EquatableMixin {
  const StoryCreatorError({
    required this.message,
    required this.action,
  });

  final String? message;
  final StoryCreatorErrorAction action;

  @override
  List<Object?> get props => [
        message,
        action,
      ];
}

extension ButtonsExtension on StoryCreatorState {
  bool get canCreateStory {
    return currentStep == StoryCreatorStep.proposals;
  }

  bool get canGoFurther {
    switch (currentStep) {
      case StoryCreatorStep.length:
        return lengthStep.canProceed();
      case StoryCreatorStep.character:
        return characterStep.canProceed();
      case StoryCreatorStep.moral:
        return moralStep.canProceed();
      case StoryCreatorStep.proposals:
        return proposalsStep.canProceed();
    }
  }
}

extension MutationExtension on StoryCreatorState {
  StoryCreatorState updateCharacterStepType(StepType type) {
    // If the user changes the character step type to custom, we need to reset
    // the validation when the selected character is not null to avoid showing
    // selected character validation warning.
    if (type == StepType.creation && characterStep.selectedCharacter != null) {
      return copyWith(
        characterStep: characterStep.copyWith(
          type: type,
          // ignore: avoid_redundant_argument_values
          selectedCharacter: null,
          // ignore: avoid_redundant_argument_values
          validation: null,
          isValid: false,
        ),
      );
    }

    return copyWith(
      characterStep: characterStep.copyWith(type: type),
    );
  }

  StoryCreatorState updateMoralStepType(StepType type) {
    return switch (type) {
      StepType.selection => copyWith(
          moralStep: moralStep.copyWith(
            type: type,
            // ignore: avoid_redundant_argument_values
            moral: null,
          ),
        ),
      StepType.creation => copyWith(
          moralStep: moralStep.copyWith(
            type: type,
            isValid: false,
            selectedSuggestionsIds: [],
            // ignore: avoid_redundant_argument_values
            validation: null,
          ),
        ),
    };
  }
}

extension StoryCreatorStepStatus on StoryCreatorState {
  AsyncValueStatus get stepStatus {
    final error = this.error;
    if (error != null && !isLoading) {
      return AsyncValueStatus.error;
    } else if (error == null && isLoading) {
      return AsyncValueStatus.loading;
    }
    return AsyncValueStatus.data;
  }
}
