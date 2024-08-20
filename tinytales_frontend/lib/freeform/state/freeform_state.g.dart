// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'freeform_state.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FreeformStateCWProxy {
  FreeformState contentStep(ContentStepState contentStep);

  FreeformState proposalsStep(FreeformProposalsState proposalsStep);

  FreeformState currentStep(FreeformStep currentStep);

  FreeformState shouldGenerateProposals(bool shouldGenerateProposals);

  FreeformState isLoading(bool isLoading);

  FreeformState storyId(String? storyId);

  FreeformState error(FreeformError? error);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FreeformState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FreeformState(...).copyWith(id: 12, name: "My name")
  /// ````
  FreeformState call({
    ContentStepState? contentStep,
    FreeformProposalsState? proposalsStep,
    FreeformStep? currentStep,
    bool? shouldGenerateProposals,
    bool? isLoading,
    String? storyId,
    FreeformError? error,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFreeformState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFreeformState.copyWith.fieldName(...)`
class _$FreeformStateCWProxyImpl implements _$FreeformStateCWProxy {
  const _$FreeformStateCWProxyImpl(this._value);

  final FreeformState _value;

  @override
  FreeformState contentStep(ContentStepState contentStep) =>
      this(contentStep: contentStep);

  @override
  FreeformState proposalsStep(FreeformProposalsState proposalsStep) =>
      this(proposalsStep: proposalsStep);

  @override
  FreeformState currentStep(FreeformStep currentStep) =>
      this(currentStep: currentStep);

  @override
  FreeformState shouldGenerateProposals(bool shouldGenerateProposals) =>
      this(shouldGenerateProposals: shouldGenerateProposals);

  @override
  FreeformState isLoading(bool isLoading) => this(isLoading: isLoading);

  @override
  FreeformState storyId(String? storyId) => this(storyId: storyId);

  @override
  FreeformState error(FreeformError? error) => this(error: error);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FreeformState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FreeformState(...).copyWith(id: 12, name: "My name")
  /// ````
  FreeformState call({
    Object? contentStep = const $CopyWithPlaceholder(),
    Object? proposalsStep = const $CopyWithPlaceholder(),
    Object? currentStep = const $CopyWithPlaceholder(),
    Object? shouldGenerateProposals = const $CopyWithPlaceholder(),
    Object? isLoading = const $CopyWithPlaceholder(),
    Object? storyId = const $CopyWithPlaceholder(),
    Object? error = const $CopyWithPlaceholder(),
  }) {
    return FreeformState(
      contentStep:
          contentStep == const $CopyWithPlaceholder() || contentStep == null
              ? _value.contentStep
              // ignore: cast_nullable_to_non_nullable
              : contentStep as ContentStepState,
      proposalsStep:
          proposalsStep == const $CopyWithPlaceholder() || proposalsStep == null
              ? _value.proposalsStep
              // ignore: cast_nullable_to_non_nullable
              : proposalsStep as FreeformProposalsState,
      currentStep:
          currentStep == const $CopyWithPlaceholder() || currentStep == null
              ? _value.currentStep
              // ignore: cast_nullable_to_non_nullable
              : currentStep as FreeformStep,
      shouldGenerateProposals:
          shouldGenerateProposals == const $CopyWithPlaceholder() ||
                  shouldGenerateProposals == null
              ? _value.shouldGenerateProposals
              // ignore: cast_nullable_to_non_nullable
              : shouldGenerateProposals as bool,
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
          : error as FreeformError?,
    );
  }
}

extension $FreeformStateCopyWith on FreeformState {
  /// Returns a callable class that can be used as follows: `instanceOfFreeformState.copyWith(...)` or like so:`instanceOfFreeformState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FreeformStateCWProxy get copyWith => _$FreeformStateCWProxyImpl(this);
}

abstract class _$ContentStepStateCWProxy {
  ContentStepState content(String? content);

  ContentStepState validation(Validation? validation);

  ContentStepState isValid(bool? isValid);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ContentStepState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ContentStepState(...).copyWith(id: 12, name: "My name")
  /// ````
  ContentStepState call({
    String? content,
    Validation? validation,
    bool? isValid,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfContentStepState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfContentStepState.copyWith.fieldName(...)`
class _$ContentStepStateCWProxyImpl implements _$ContentStepStateCWProxy {
  const _$ContentStepStateCWProxyImpl(this._value);

  final ContentStepState _value;

  @override
  ContentStepState content(String? content) => this(content: content);

  @override
  ContentStepState validation(Validation? validation) =>
      this(validation: validation);

  @override
  ContentStepState isValid(bool? isValid) => this(isValid: isValid);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ContentStepState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ContentStepState(...).copyWith(id: 12, name: "My name")
  /// ````
  ContentStepState call({
    Object? content = const $CopyWithPlaceholder(),
    Object? validation = const $CopyWithPlaceholder(),
    Object? isValid = const $CopyWithPlaceholder(),
  }) {
    return ContentStepState(
      content: content == const $CopyWithPlaceholder()
          ? _value.content
          // ignore: cast_nullable_to_non_nullable
          : content as String?,
      validation: validation == const $CopyWithPlaceholder()
          ? _value.validation
          // ignore: cast_nullable_to_non_nullable
          : validation as Validation?,
      isValid: isValid == const $CopyWithPlaceholder()
          ? _value.isValid
          // ignore: cast_nullable_to_non_nullable
          : isValid as bool?,
    );
  }
}

extension $ContentStepStateCopyWith on ContentStepState {
  /// Returns a callable class that can be used as follows: `instanceOfContentStepState.copyWith(...)` or like so:`instanceOfContentStepState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ContentStepStateCWProxy get copyWith => _$ContentStepStateCWProxyImpl(this);
}

abstract class _$FreeformProposalsStateCWProxy {
  FreeformProposalsState selectedProposalIndex(int? selectedProposalIndex);

  FreeformProposalsState proposals(List<FreeformProposal> proposals);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FreeformProposalsState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FreeformProposalsState(...).copyWith(id: 12, name: "My name")
  /// ````
  FreeformProposalsState call({
    int? selectedProposalIndex,
    List<FreeformProposal>? proposals,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFreeformProposalsState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFreeformProposalsState.copyWith.fieldName(...)`
class _$FreeformProposalsStateCWProxyImpl
    implements _$FreeformProposalsStateCWProxy {
  const _$FreeformProposalsStateCWProxyImpl(this._value);

  final FreeformProposalsState _value;

  @override
  FreeformProposalsState selectedProposalIndex(int? selectedProposalIndex) =>
      this(selectedProposalIndex: selectedProposalIndex);

  @override
  FreeformProposalsState proposals(List<FreeformProposal> proposals) =>
      this(proposals: proposals);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `FreeformProposalsState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// FreeformProposalsState(...).copyWith(id: 12, name: "My name")
  /// ````
  FreeformProposalsState call({
    Object? selectedProposalIndex = const $CopyWithPlaceholder(),
    Object? proposals = const $CopyWithPlaceholder(),
  }) {
    return FreeformProposalsState(
      selectedProposalIndex:
          selectedProposalIndex == const $CopyWithPlaceholder()
              ? _value.selectedProposalIndex
              // ignore: cast_nullable_to_non_nullable
              : selectedProposalIndex as int?,
      proposals: proposals == const $CopyWithPlaceholder() || proposals == null
          ? _value.proposals
          // ignore: cast_nullable_to_non_nullable
          : proposals as List<FreeformProposal>,
    );
  }
}

extension $FreeformProposalsStateCopyWith on FreeformProposalsState {
  /// Returns a callable class that can be used as follows: `instanceOfFreeformProposalsState.copyWith(...)` or like so:`instanceOfFreeformProposalsState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FreeformProposalsStateCWProxy get copyWith =>
      _$FreeformProposalsStateCWProxyImpl(this);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$freeformNotifierHash() => r'5baedfbca3e6b664458d2f951a8eb6f1ca07b41f';

/// See also [FreeformNotifier].
@ProviderFor(FreeformNotifier)
final freeformNotifierProvider =
    AutoDisposeNotifierProvider<FreeformNotifier, FreeformState>.internal(
  FreeformNotifier.new,
  name: r'freeformNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$freeformNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FreeformNotifier = AutoDisposeNotifier<FreeformState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
