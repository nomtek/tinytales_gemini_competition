// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'step_progress_bar.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$StepProgressBarStateCWProxy {
  StepProgressBarState previousStepIndex(int previousStepIndex);

  StepProgressBarState currentStepIndex(int currentStepIndex);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StepProgressBarState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StepProgressBarState(...).copyWith(id: 12, name: "My name")
  /// ````
  StepProgressBarState call({
    int? previousStepIndex,
    int? currentStepIndex,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfStepProgressBarState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfStepProgressBarState.copyWith.fieldName(...)`
class _$StepProgressBarStateCWProxyImpl
    implements _$StepProgressBarStateCWProxy {
  const _$StepProgressBarStateCWProxyImpl(this._value);

  final StepProgressBarState _value;

  @override
  StepProgressBarState previousStepIndex(int previousStepIndex) =>
      this(previousStepIndex: previousStepIndex);

  @override
  StepProgressBarState currentStepIndex(int currentStepIndex) =>
      this(currentStepIndex: currentStepIndex);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `StepProgressBarState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// StepProgressBarState(...).copyWith(id: 12, name: "My name")
  /// ````
  StepProgressBarState call({
    Object? previousStepIndex = const $CopyWithPlaceholder(),
    Object? currentStepIndex = const $CopyWithPlaceholder(),
  }) {
    return StepProgressBarState(
      previousStepIndex: previousStepIndex == const $CopyWithPlaceholder() ||
              previousStepIndex == null
          ? _value.previousStepIndex
          // ignore: cast_nullable_to_non_nullable
          : previousStepIndex as int,
      currentStepIndex: currentStepIndex == const $CopyWithPlaceholder() ||
              currentStepIndex == null
          ? _value.currentStepIndex
          // ignore: cast_nullable_to_non_nullable
          : currentStepIndex as int,
    );
  }
}

extension $StepProgressBarStateCopyWith on StepProgressBarState {
  /// Returns a callable class that can be used as follows: `instanceOfStepProgressBarState.copyWith(...)` or like so:`instanceOfStepProgressBarState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$StepProgressBarStateCWProxy get copyWith =>
      _$StepProgressBarStateCWProxyImpl(this);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stepProgressBarNotifierHash() =>
    r'faaa1e076abf74009f4fc16bae67ca152783255a';

/// See also [StepProgressBarNotifier].
@ProviderFor(StepProgressBarNotifier)
final stepProgressBarNotifierProvider = AutoDisposeNotifierProvider<
    StepProgressBarNotifier, StepProgressBarState>.internal(
  StepProgressBarNotifier.new,
  name: r'stepProgressBarNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$stepProgressBarNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$StepProgressBarNotifier = AutoDisposeNotifier<StepProgressBarState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
