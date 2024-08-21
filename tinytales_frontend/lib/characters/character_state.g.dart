// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CharacterStateCWProxy {
  CharacterState characterId(String? characterId);

  CharacterState newCharacterName(String? newCharacterName);

  CharacterState initialCharacterName(String? initialCharacterName);

  CharacterState newCharacterDescription(String? newCharacterDescription);

  CharacterState initialCharacterDescription(
      String? initialCharacterDescription);

  CharacterState validation(Validation? validation);

  CharacterState isAIAutofillInProgress(bool isAIAutofillInProgress);

  CharacterState isLoading(bool isLoading);

  CharacterState shouldExitScreen(bool? shouldExitScreen);

  CharacterState error(EditCharacterError? error);

  CharacterState pageMode(CharacterPageMode pageMode);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CharacterState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CharacterState(...).copyWith(id: 12, name: "My name")
  /// ````
  CharacterState call({
    String? characterId,
    String? newCharacterName,
    String? initialCharacterName,
    String? newCharacterDescription,
    String? initialCharacterDescription,
    Validation? validation,
    bool? isAIAutofillInProgress,
    bool? isLoading,
    bool? shouldExitScreen,
    EditCharacterError? error,
    CharacterPageMode? pageMode,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCharacterState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCharacterState.copyWith.fieldName(...)`
class _$CharacterStateCWProxyImpl implements _$CharacterStateCWProxy {
  const _$CharacterStateCWProxyImpl(this._value);

  final CharacterState _value;

  @override
  CharacterState characterId(String? characterId) =>
      this(characterId: characterId);

  @override
  CharacterState newCharacterName(String? newCharacterName) =>
      this(newCharacterName: newCharacterName);

  @override
  CharacterState initialCharacterName(String? initialCharacterName) =>
      this(initialCharacterName: initialCharacterName);

  @override
  CharacterState newCharacterDescription(String? newCharacterDescription) =>
      this(newCharacterDescription: newCharacterDescription);

  @override
  CharacterState initialCharacterDescription(
          String? initialCharacterDescription) =>
      this(initialCharacterDescription: initialCharacterDescription);

  @override
  CharacterState validation(Validation? validation) =>
      this(validation: validation);

  @override
  CharacterState isAIAutofillInProgress(bool isAIAutofillInProgress) =>
      this(isAIAutofillInProgress: isAIAutofillInProgress);

  @override
  CharacterState isLoading(bool isLoading) => this(isLoading: isLoading);

  @override
  CharacterState shouldExitScreen(bool? shouldExitScreen) =>
      this(shouldExitScreen: shouldExitScreen);

  @override
  CharacterState error(EditCharacterError? error) => this(error: error);

  @override
  CharacterState pageMode(CharacterPageMode pageMode) =>
      this(pageMode: pageMode);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `CharacterState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// CharacterState(...).copyWith(id: 12, name: "My name")
  /// ````
  CharacterState call({
    Object? characterId = const $CopyWithPlaceholder(),
    Object? newCharacterName = const $CopyWithPlaceholder(),
    Object? initialCharacterName = const $CopyWithPlaceholder(),
    Object? newCharacterDescription = const $CopyWithPlaceholder(),
    Object? initialCharacterDescription = const $CopyWithPlaceholder(),
    Object? validation = const $CopyWithPlaceholder(),
    Object? isAIAutofillInProgress = const $CopyWithPlaceholder(),
    Object? isLoading = const $CopyWithPlaceholder(),
    Object? shouldExitScreen = const $CopyWithPlaceholder(),
    Object? error = const $CopyWithPlaceholder(),
    Object? pageMode = const $CopyWithPlaceholder(),
  }) {
    return CharacterState(
      characterId: characterId == const $CopyWithPlaceholder()
          ? _value.characterId
          // ignore: cast_nullable_to_non_nullable
          : characterId as String?,
      newCharacterName: newCharacterName == const $CopyWithPlaceholder()
          ? _value.newCharacterName
          // ignore: cast_nullable_to_non_nullable
          : newCharacterName as String?,
      initialCharacterName: initialCharacterName == const $CopyWithPlaceholder()
          ? _value.initialCharacterName
          // ignore: cast_nullable_to_non_nullable
          : initialCharacterName as String?,
      newCharacterDescription:
          newCharacterDescription == const $CopyWithPlaceholder()
              ? _value.newCharacterDescription
              // ignore: cast_nullable_to_non_nullable
              : newCharacterDescription as String?,
      initialCharacterDescription:
          initialCharacterDescription == const $CopyWithPlaceholder()
              ? _value.initialCharacterDescription
              // ignore: cast_nullable_to_non_nullable
              : initialCharacterDescription as String?,
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
      isLoading: isLoading == const $CopyWithPlaceholder() || isLoading == null
          ? _value.isLoading
          // ignore: cast_nullable_to_non_nullable
          : isLoading as bool,
      shouldExitScreen: shouldExitScreen == const $CopyWithPlaceholder()
          ? _value.shouldExitScreen
          // ignore: cast_nullable_to_non_nullable
          : shouldExitScreen as bool?,
      error: error == const $CopyWithPlaceholder()
          ? _value.error
          // ignore: cast_nullable_to_non_nullable
          : error as EditCharacterError?,
      pageMode: pageMode == const $CopyWithPlaceholder() || pageMode == null
          ? _value.pageMode
          // ignore: cast_nullable_to_non_nullable
          : pageMode as CharacterPageMode,
    );
  }
}

extension $CharacterStateCopyWith on CharacterState {
  /// Returns a callable class that can be used as follows: `instanceOfCharacterState.copyWith(...)` or like so:`instanceOfCharacterState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CharacterStateCWProxy get copyWith => _$CharacterStateCWProxyImpl(this);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$characterNotifierHash() => r'bd56126579a60beffdad66bbed5708a759b523b9';

/// See also [CharacterNotifier].
@ProviderFor(CharacterNotifier)
final characterNotifierProvider =
    AutoDisposeNotifierProvider<CharacterNotifier, CharacterState>.internal(
  CharacterNotifier.new,
  name: r'characterNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$characterNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CharacterNotifier = AutoDisposeNotifier<CharacterState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
