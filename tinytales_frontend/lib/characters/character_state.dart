// ignore_for_file: avoid_redundant_argument_values

import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tale_ai_frontend/characters/characters.dart';
import 'package:tale_ai_frontend/debug/talker.dart';
import 'package:tale_ai_frontend/extensions.dart';
import 'package:tale_ai_frontend/form/form.dart';

part 'character_state.g.dart';

@riverpod
class CharacterNotifier extends _$CharacterNotifier with RetryErrorAction {
  @override
  CharacterState build() => CharacterState();

  void initEditMode({
    String? characterId,
    String? characterName,
    String? characterDescription,
  }) {
    state = state.copyWith(
      characterId: characterId,
      initialCharacterName: characterName,
      initialCharacterDescription: characterDescription,
      newCharacterName: characterName,
      newCharacterDescription: characterDescription,
      pageMode: CharacterPageMode.edit,
    );
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
      newCharacterName: characterName,
      validation: null,
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
      newCharacterDescription: characterDescription,
      validation: null,
    );
  }

  Future<void> aiAutofill() async {
    assert(
      !state.isLoading,
      'Cannot do AI autofill when loading',
    );
    assert(
      state.error == null,
      'Cannot do AI autofill when error',
    );
    state = state.copyWith(
      isAIAutofillInProgress: true,
    );

    try {
      final autofillCharacter =
          await ref.read(characterServiceProvider).autofillCharacter(
                name: state.newCharacterName ?? '',
                description: state.newCharacterDescription ?? '',
              );

      state = state.copyWith(
        newCharacterName: autofillCharacter.name,
        newCharacterDescription: autofillCharacter.description,
        isAIAutofillInProgress: false,
        validation: null,
      );
    } catch (e, st) {
      ref.read(talkerProvider).handle(e, st);
      state = state.copyWith(
        isAIAutofillInProgress: false,
        error: EditCharacterError(
          action: EditCharacterErrorAction.aiAutofill,
          error: e.toString(),
        ),
      );
    }
  }

  Future<void> deleteCharacter() async {
    assert(
      !state.isLoading,
      'Cannot save when loading',
    );
    assert(
      state.error == null,
      'Cannot save when error is present',
    );
    assert(
      state.characterId != null,
      'Character ID must not be null when saving changes',
    );
    state = state.copyWith(
      isLoading: true,
    );
    try {
      await ref.read(characterServiceProvider).deleteCharacter(
            state.characterId ?? '',
          );
      state = state.copyWith(
        isLoading: false,
        shouldExitScreen: true,
      );
    } catch (e, st) {
      ref.read(talkerProvider).handle(e, st);
      state = state.copyWith(
        isLoading: false,
        error: EditCharacterError(
          action: EditCharacterErrorAction.deleteCharacter,
          error: e.toString(),
        ),
      );
    }
  }

  Future<StepActionResult> save() async {
    assert(
      !state.isLoading,
      'Cannot save when loading',
    );
    assert(
      state.error == null,
      'Cannot save when error is present',
    );
    assert(
      state.newCharacterName != null,
      'Character name must not be null when saving changes',
    );
    assert(
      state.pageMode != CharacterPageMode.edit || state.characterId != null,
      'Character ID must not be null when saving changes in edit mode',
    );
    state = state.copyWith(
      isLoading: true,
    );
    try {
      // If the character was validated before, and the validation status is
      // needs improvement, we can save the character without revalidating it.
      if (state.validation?.validationStatus ==
          ValidationStatus.needsImprovement) {
        await submit(pageMode: state.pageMode);

        state = state.copyWith(
          isLoading: false,
          shouldExitScreen: true,
        );
        return StepActionResult.success;
      }

      final characterName = state.newCharacterName;
      final characterDescription = state.newCharacterDescription;
      if (characterName.isNullOrBlank || characterDescription.isNullOrBlank) {
        state = state.copyWith(
          isLoading: false,
          validation: const Validation(
            valid: false,
            validationStatus: ValidationStatus.inappropriate,
            suggestedVersion: SuggestedVersion(),
          ),
        );
        return StepActionResult.failure;
      }

      final validation =
          await ref.read(characterServiceProvider).validateCharacter(
                name: state.newCharacterName ?? '',
                description: state.newCharacterDescription ?? '',
              );

      if (validation.validationStatus == ValidationStatus.excellent) {
        await submit(pageMode: state.pageMode);
        state = state.copyWith(
          isLoading: false,
          validation: validation,
          shouldExitScreen: true,
        );
        return StepActionResult.success;
      } else {
        state = state.copyWith(
          isLoading: false,
          validation: validation,
        );
        return StepActionResult.failure;
      }
    } catch (e, st) {
      ref.read(talkerProvider).handle(e, st);
      state = state.copyWith(
        isLoading: false,
        error: EditCharacterError(
          action: EditCharacterErrorAction.saveChanges,
          error: e.toString(),
        ),
      );
      return StepActionResult.failure;
    }
  }

  Future<void> submit({
    required CharacterPageMode pageMode,
  }) async {
    switch (pageMode) {
      case CharacterPageMode.edit:
        await ref.read(characterServiceProvider).updateCharacter(
              characterId: state.characterId ?? '',
              name: state.newCharacterName ?? '',
              description: state.newCharacterDescription ?? '',
            );
      case CharacterPageMode.create:
        await ref.read(characterServiceProvider).createCharacter(
              name: state.newCharacterName ?? '',
              description: state.newCharacterDescription ?? '',
            );
    }
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
      case EditCharacterErrorAction.aiAutofill:
        await aiAutofill();
      case EditCharacterErrorAction.saveChanges:
        await save();
      case EditCharacterErrorAction.deleteCharacter:
        await deleteCharacter();
    }
  }
}

@CopyWith()
class CharacterState with EquatableMixin {
  CharacterState({
    this.characterId,
    this.newCharacterName,
    this.initialCharacterName,
    this.newCharacterDescription,
    this.initialCharacterDescription,
    this.validation,
    this.isAIAutofillInProgress = false,
    this.isLoading = false,
    this.shouldExitScreen,
    this.error,
    this.pageMode = CharacterPageMode.create,
  });

  final String? characterId;
  final String? newCharacterName;
  final String? initialCharacterName;
  final String? newCharacterDescription;
  final String? initialCharacterDescription;
  // If null, the step has not been validated on backend
  final Validation? validation;
  final bool isAIAutofillInProgress;
  final bool isLoading;
  final EditCharacterError? error;
  final bool? shouldExitScreen;
  final CharacterPageMode pageMode;

  @override
  List<Object?> get props => [
        newCharacterName,
        initialCharacterName,
        newCharacterDescription,
        initialCharacterDescription,
        validation,
        isAIAutofillInProgress,
        isLoading,
        error,
        shouldExitScreen,
        pageMode,
      ];
}

enum EditCharacterErrorAction {
  aiAutofill,
  saveChanges,
  deleteCharacter,
}

@immutable
class EditCharacterError {
  const EditCharacterError({
    required this.action,
    required this.error,
  });

  final EditCharacterErrorAction action;
  final String? error;
}
