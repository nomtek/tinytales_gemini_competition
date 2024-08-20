// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story_creator_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StoryCreatorStateCWProxy {
  StoryCreatorState lengthStep(StoryLengthStepState lengthStep);

  StoryCreatorState characterStep(CharacterStepState characterStep);

  StoryCreatorState saveCharacter(bool saveCharacter);

  StoryCreatorState moralStep(MoralStepState moralStep);

  StoryCreatorState proposalsStep(ProposalsViewState proposalsStep);

  StoryCreatorState currentStep(StoryCreatorStep currentStep);

  StoryCreatorState shouldGenerateProposals(bool shouldGenerateProposals);

  StoryCreatorState shouldIncludeCharacterSelectionStep(
      bool shouldIncludeCharacterSelectionStep);

  StoryCreatorState isLoading(bool isLoading);

  StoryCreatorState storyId(String? storyId);

  StoryCreatorState error(StoryCreatorError? error);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StoryCreatorState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StoryCreatorState(...).copyWith(id: 12, name: "My name")
  /// ````
  StoryCreatorState call({
    StoryLengthStepState? lengthStep,
    CharacterStepState? characterStep,
    bool? saveCharacter,
    MoralStepState? moralStep,
    ProposalsViewState? proposalsStep,
    StoryCreatorStep? currentStep,
    bool? shouldGenerateProposals,
    bool? shouldIncludeCharacterSelectionStep,
    bool? isLoading,
    String? storyId,
    StoryCreatorError? error,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStoryCreatorState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStoryCreatorState.copyWith.fieldName(...)`
class _$StoryCreatorStateCWProxyImpl implements _$StoryCreatorStateCWProxy {
  const _$StoryCreatorStateCWProxyImpl(this._value);

  final StoryCreatorState _value;

  @override
  StoryCreatorState lengthStep(StoryLengthStepState lengthStep) =>
      this(lengthStep: lengthStep);

  @override
  StoryCreatorState characterStep(CharacterStepState characterStep) =>
      this(characterStep: characterStep);

  @override
  StoryCreatorState saveCharacter(bool saveCharacter) =>
      this(saveCharacter: saveCharacter);

  @override
  StoryCreatorState moralStep(MoralStepState moralStep) =>
      this(moralStep: moralStep);

  @override
  StoryCreatorState proposalsStep(ProposalsViewState proposalsStep) =>
      this(proposalsStep: proposalsStep);

  @override
  StoryCreatorState currentStep(StoryCreatorStep currentStep) =>
      this(currentStep: currentStep);

  @override
  StoryCreatorState shouldGenerateProposals(bool shouldGenerateProposals) =>
      this(shouldGenerateProposals: shouldGenerateProposals);

  @override
  StoryCreatorState shouldIncludeCharacterSelectionStep(
          bool shouldIncludeCharacterSelectionStep) =>
      this(
          shouldIncludeCharacterSelectionStep:
              shouldIncludeCharacterSelectionStep);

  @override
  StoryCreatorState isLoading(bool isLoading) => this(isLoading: isLoading);

  @override
  StoryCreatorState storyId(String? storyId) => this(storyId: storyId);

  @override
  StoryCreatorState error(StoryCreatorError? error) => this(error: error);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StoryCreatorState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StoryCreatorState(...).copyWith(id: 12, name: "My name")
  /// ````
  StoryCreatorState call({
    Object? lengthStep = const $CopyWithPlaceholder(),
    Object? characterStep = const $CopyWithPlaceholder(),
    Object? saveCharacter = const $CopyWithPlaceholder(),
    Object? moralStep = const $CopyWithPlaceholder(),
    Object? proposalsStep = const $CopyWithPlaceholder(),
    Object? currentStep = const $CopyWithPlaceholder(),
    Object? shouldGenerateProposals = const $CopyWithPlaceholder(),
    Object? shouldIncludeCharacterSelectionStep = const $CopyWithPlaceholder(),
    Object? isLoading = const $CopyWithPlaceholder(),
    Object? storyId = const $CopyWithPlaceholder(),
    Object? error = const $CopyWithPlaceholder(),
  }) {
    return StoryCreatorState(
      lengthStep:
          lengthStep == const $CopyWithPlaceholder() || lengthStep == null
              ? _value.lengthStep
              // ignore: cast_nullable_to_non_nullable
              : lengthStep as StoryLengthStepState,
      characterStep:
          characterStep == const $CopyWithPlaceholder() || characterStep == null
              ? _value.characterStep
              // ignore: cast_nullable_to_non_nullable
              : characterStep as CharacterStepState,
      saveCharacter:
          saveCharacter == const $CopyWithPlaceholder() || saveCharacter == null
              ? _value.saveCharacter
              // ignore: cast_nullable_to_non_nullable
              : saveCharacter as bool,
      moralStep: moralStep == const $CopyWithPlaceholder() || moralStep == null
          ? _value.moralStep
          // ignore: cast_nullable_to_non_nullable
          : moralStep as MoralStepState,
      proposalsStep:
          proposalsStep == const $CopyWithPlaceholder() || proposalsStep == null
              ? _value.proposalsStep
              // ignore: cast_nullable_to_non_nullable
              : proposalsStep as ProposalsViewState,
      currentStep:
          currentStep == const $CopyWithPlaceholder() || currentStep == null
              ? _value.currentStep
              // ignore: cast_nullable_to_non_nullable
              : currentStep as StoryCreatorStep,
      shouldGenerateProposals:
          shouldGenerateProposals == const $CopyWithPlaceholder() ||
                  shouldGenerateProposals == null
              ? _value.shouldGenerateProposals
              // ignore: cast_nullable_to_non_nullable
              : shouldGenerateProposals as bool,
      shouldIncludeCharacterSelectionStep:
          shouldIncludeCharacterSelectionStep == const $CopyWithPlaceholder() ||
                  shouldIncludeCharacterSelectionStep == null
              ? _value.shouldIncludeCharacterSelectionStep
              // ignore: cast_nullable_to_non_nullable
              : shouldIncludeCharacterSelectionStep as bool,
      isLoading: isLoading == const $CopyWithPlaceholder() || isLoading == null
          ? _value.isLoading
          // ignore: cast_nullable_to_non_nullable
          : isLoading as bool,
      storyId: storyId == const $CopyWithPlaceholder()
          ? _value.storyId
          // ignore: cast_nullable_to_non_nullable
          : storyId as String?,
      error: error == const $CopyWithPlaceholder()
          ? _value.error
          // ignore: cast_nullable_to_non_nullable
          : error as StoryCreatorError?,
    );
  }
}

extension $StoryCreatorStateCopyWith on StoryCreatorState {
  /// Returns a callable class that can be used as follows: `instanceOfStoryCreatorState.copyWith(...)` or like so:`instanceOfStoryCreatorState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StoryCreatorStateCWProxy get copyWith =>
      _$StoryCreatorStateCWProxyImpl(this);
}

abstract class _$StoryLengthStepStateCWProxy {
  StoryLengthStepState length(StoryLength? length);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StoryLengthStepState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StoryLengthStepState(...).copyWith(id: 12, name: "My name")
  /// ````
  StoryLengthStepState call({
    StoryLength? length,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStoryLengthStepState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStoryLengthStepState.copyWith.fieldName(...)`
class _$StoryLengthStepStateCWProxyImpl
    implements _$StoryLengthStepStateCWProxy {
  const _$StoryLengthStepStateCWProxyImpl(this._value);

  final StoryLengthStepState _value;

  @override
  StoryLengthStepState length(StoryLength? length) => this(length: length);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StoryLengthStepState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StoryLengthStepState(...).copyWith(id: 12, name: "My name")
  /// ````
  StoryLengthStepState call({
    Object? length = const $CopyWithPlaceholder(),
  }) {
    return StoryLengthStepState(
      length: length == const $CopyWithPlaceholder()
          ? _value.length
          // ignore: cast_nullable_to_non_nullable
          : length as StoryLength?,
    );
  }
}

extension $StoryLengthStepStateCopyWith on StoryLengthStepState {
  /// Returns a callable class that can be used as follows: `instanceOfStoryLengthStepState.copyWith(...)` or like so:`instanceOfStoryLengthStepState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StoryLengthStepStateCWProxy get copyWith =>
      _$StoryLengthStepStateCWProxyImpl(this);
}

abstract class _$CharacterStepStateCWProxy {
  CharacterStepState type(StepType type);

  CharacterStepState selectedCharacter(Character? selectedCharacter);

  CharacterStepState inputCharacterName(String? inputCharacterName);

  CharacterStepState inputCharacterDescription(
      String? inputCharacterDescription);

  CharacterStepState validation(Validation? validation);

  CharacterStepState isAIAutofillInProgress(bool isAIAutofillInProgress);

  CharacterStepState isValid(bool? isValid);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CharacterStepState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CharacterStepState(...).copyWith(id: 12, name: "My name")
  /// ````
  CharacterStepState call({
    StepType? type,
    Character? selectedCharacter,
    String? inputCharacterName,
    String? inputCharacterDescription,
    Validation? validation,
    bool? isAIAutofillInProgress,
    bool? isValid,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCharacterStepState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCharacterStepState.copyWith.fieldName(...)`
class _$CharacterStepStateCWProxyImpl implements _$CharacterStepStateCWProxy {
  const _$CharacterStepStateCWProxyImpl(this._value);

  final CharacterStepState _value;

  @override
  CharacterStepState type(StepType type) => this(type: type);

  @override
  CharacterStepState selectedCharacter(Character? selectedCharacter) =>
      this(selectedCharacter: selectedCharacter);

  @override
  CharacterStepState inputCharacterName(String? inputCharacterName) =>
      this(inputCharacterName: inputCharacterName);

  @override
  CharacterStepState inputCharacterDescription(
          String? inputCharacterDescription) =>
      this(inputCharacterDescription: inputCharacterDescription);

  @override
  CharacterStepState validation(Validation? validation) =>
      this(validation: validation);

  @override
  CharacterStepState isAIAutofillInProgress(bool isAIAutofillInProgress) =>
      this(isAIAutofillInProgress: isAIAutofillInProgress);

  @override
  CharacterStepState isValid(bool? isValid) => this(isValid: isValid);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CharacterStepState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CharacterStepState(...).copyWith(id: 12, name: "My name")
  /// ````
  CharacterStepState call({
    Object? type = const $CopyWithPlaceholder(),
    Object? selectedCharacter = const $CopyWithPlaceholder(),
    Object? inputCharacterName = const $CopyWithPlaceholder(),
    Object? inputCharacterDescription = const $CopyWithPlaceholder(),
    Object? validation = const $CopyWithPlaceholder(),
    Object? isAIAutofillInProgress = const $CopyWithPlaceholder(),
    Object? isValid = const $CopyWithPlaceholder(),
  }) {
    return CharacterStepState(
      type: type == const $CopyWithPlaceholder() || type == null
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as StepType,
      selectedCharacter: selectedCharacter == const $CopyWithPlaceholder()
          ? _value.selectedCharacter
          // ignore: cast_nullable_to_non_nullable
          : selectedCharacter as Character?,
      inputCharacterName: inputCharacterName == const $CopyWithPlaceholder()
          ? _value.inputCharacterName
          // ignore: cast_nullable_to_non_nullable
          : inputCharacterName as String?,
      inputCharacterDescription:
          inputCharacterDescription == const $CopyWithPlaceholder()
              ? _value.inputCharacterDescription
              // ignore: cast_nullable_to_non_nullable
              : inputCharacterDescription as String?,
      validation: validation == const $CopyWithPlaceholder()
          ? _value.validation
          // ignore: cast_nullable_to_non_nullable
          : validation as Validation?,
      isAIAutofillInProgress:
          isAIAutofillInProgress == const $CopyWithPlaceholder() ||
                  isAIAutofillInProgress == null
              ? _value.isAIAutofillInProgress
              // ignore: cast_nullable_to_non_nullable
              : isAIAutofillInProgress as bool,
      isValid: isValid == const $CopyWithPlaceholder()
          ? _value.isValid
          // ignore: cast_nullable_to_non_nullable
          : isValid as bool?,
    );
  }
}

extension $CharacterStepStateCopyWith on CharacterStepState {
  /// Returns a callable class that can be used as follows: `instanceOfCharacterStepState.copyWith(...)` or like so:`instanceOfCharacterStepState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CharacterStepStateCWProxy get copyWith =>
      _$CharacterStepStateCWProxyImpl(this);
}

abstract class _$MoralStepStateCWProxy {
  MoralStepState type(StepType type);

  MoralStepState selectedSuggestionsIds(List<String> selectedSuggestionsIds);

  MoralStepState moral(String? moral);

  MoralStepState validation(Validation? validation);

  MoralStepState isAIAutofillInProgress(bool isAIAutofillInProgress);

  MoralStepState isValid(bool? isValid);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MoralStepState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MoralStepState(...).copyWith(id: 12, name: "My name")
  /// ````
  MoralStepState call({
    StepType? type,
    List<String>? selectedSuggestionsIds,
    String? moral,
    Validation? validation,
    bool? isAIAutofillInProgress,
    bool? isValid,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfMoralStepState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfMoralStepState.copyWith.fieldName(...)`
class _$MoralStepStateCWProxyImpl implements _$MoralStepStateCWProxy {
  const _$MoralStepStateCWProxyImpl(this._value);

  final MoralStepState _value;

  @override
  MoralStepState type(StepType type) => this(type: type);

  @override
  MoralStepState selectedSuggestionsIds(List<String> selectedSuggestionsIds) =>
      this(selectedSuggestionsIds: selectedSuggestionsIds);

  @override
  MoralStepState moral(String? moral) => this(moral: moral);

  @override
  MoralStepState validation(Validation? validation) =>
      this(validation: validation);

  @override
  MoralStepState isAIAutofillInProgress(bool isAIAutofillInProgress) =>
      this(isAIAutofillInProgress: isAIAutofillInProgress);

  @override
  MoralStepState isValid(bool? isValid) => this(isValid: isValid);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `MoralStepState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// MoralStepState(...).copyWith(id: 12, name: "My name")
  /// ````
  MoralStepState call({
    Object? type = const $CopyWithPlaceholder(),
    Object? selectedSuggestionsIds = const $CopyWithPlaceholder(),
    Object? moral = const $CopyWithPlaceholder(),
    Object? validation = const $CopyWithPlaceholder(),
    Object? isAIAutofillInProgress = const $CopyWithPlaceholder(),
    Object? isValid = const $CopyWithPlaceholder(),
  }) {
    return MoralStepState(
      type: type == const $CopyWithPlaceholder() || type == null
          ? _value.type
          // ignore: cast_nullable_to_non_nullable
          : type as StepType,
      selectedSuggestionsIds:
          selectedSuggestionsIds == const $CopyWithPlaceholder() ||
                  selectedSuggestionsIds == null
              ? _value.selectedSuggestionsIds
              // ignore: cast_nullable_to_non_nullable
              : selectedSuggestionsIds as List<String>,
      moral: moral == const $CopyWithPlaceholder()
          ? _value.moral
          // ignore: cast_nullable_to_non_nullable
          : moral as String?,
      validation: validation == const $CopyWithPlaceholder()
          ? _value.validation
          // ignore: cast_nullable_to_non_nullable
          : validation as Validation?,
      isAIAutofillInProgress:
          isAIAutofillInProgress == const $CopyWithPlaceholder() ||
                  isAIAutofillInProgress == null
              ? _value.isAIAutofillInProgress
              // ignore: cast_nullable_to_non_nullable
              : isAIAutofillInProgress as bool,
      isValid: isValid == const $CopyWithPlaceholder()
          ? _value.isValid
          // ignore: cast_nullable_to_non_nullable
          : isValid as bool?,
    );
  }
}

extension $MoralStepStateCopyWith on MoralStepState {
  /// Returns a callable class that can be used as follows: `instanceOfMoralStepState.copyWith(...)` or like so:`instanceOfMoralStepState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$MoralStepStateCWProxy get copyWith => _$MoralStepStateCWProxyImpl(this);
}

abstract class _$StoryCreatorErrorCWProxy {
  StoryCreatorError message(String? message);

  StoryCreatorError action(StoryCreatorErrorAction action);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StoryCreatorError(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StoryCreatorError(...).copyWith(id: 12, name: "My name")
  /// ````
  StoryCreatorError call({
    String? message,
    StoryCreatorErrorAction? action,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStoryCreatorError.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStoryCreatorError.copyWith.fieldName(...)`
class _$StoryCreatorErrorCWProxyImpl implements _$StoryCreatorErrorCWProxy {
  const _$StoryCreatorErrorCWProxyImpl(this._value);

  final StoryCreatorError _value;

  @override
  StoryCreatorError message(String? message) => this(message: message);

  @override
  StoryCreatorError action(StoryCreatorErrorAction action) =>
      this(action: action);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StoryCreatorError(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StoryCreatorError(...).copyWith(id: 12, name: "My name")
  /// ````
  StoryCreatorError call({
    Object? message = const $CopyWithPlaceholder(),
    Object? action = const $CopyWithPlaceholder(),
  }) {
    return StoryCreatorError(
      message: message == const $CopyWithPlaceholder()
          ? _value.message
          // ignore: cast_nullable_to_non_nullable
          : message as String?,
      action: action == const $CopyWithPlaceholder() || action == null
          ? _value.action
          // ignore: cast_nullable_to_non_nullable
          : action as StoryCreatorErrorAction,
    );
  }
}

extension $StoryCreatorErrorCopyWith on StoryCreatorError {
  /// Returns a callable class that can be used as follows: `instanceOfStoryCreatorError.copyWith(...)` or like so:`instanceOfStoryCreatorError.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StoryCreatorErrorCWProxy get copyWith =>
      _$StoryCreatorErrorCWProxyImpl(this);
}
