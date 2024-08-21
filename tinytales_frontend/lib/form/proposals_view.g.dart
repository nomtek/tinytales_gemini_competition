// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proposals_view.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ProposalsViewStateCWProxy {
  ProposalsViewState selectedProposalIndex(int? selectedProposalIndex);

  ProposalsViewState storyProposals(List<StoryProposal> storyProposals);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ProposalsViewState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ProposalsViewState(...).copyWith(id: 12, name: "My name")
  /// ````
  ProposalsViewState call({
    int? selectedProposalIndex,
    List<StoryProposal>? storyProposals,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfProposalsViewState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfProposalsViewState.copyWith.fieldName(...)`
class _$ProposalsViewStateCWProxyImpl implements _$ProposalsViewStateCWProxy {
  const _$ProposalsViewStateCWProxyImpl(this._value);

  final ProposalsViewState _value;

  @override
  ProposalsViewState selectedProposalIndex(int? selectedProposalIndex) =>
      this(selectedProposalIndex: selectedProposalIndex);

  @override
  ProposalsViewState storyProposals(List<StoryProposal> storyProposals) =>
      this(storyProposals: storyProposals);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ProposalsViewState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ProposalsViewState(...).copyWith(id: 12, name: "My name")
  /// ````
  ProposalsViewState call({
    Object? selectedProposalIndex = const $CopyWithPlaceholder(),
    Object? storyProposals = const $CopyWithPlaceholder(),
  }) {
    return ProposalsViewState(
      selectedProposalIndex:
          selectedProposalIndex == const $CopyWithPlaceholder()
              ? _value.selectedProposalIndex
              // ignore: cast_nullable_to_non_nullable
              : selectedProposalIndex as int?,
      storyProposals: storyProposals == const $CopyWithPlaceholder() ||
              storyProposals == null
          ? _value.storyProposals
          // ignore: cast_nullable_to_non_nullable
          : storyProposals as List<StoryProposal>,
    );
  }
}

extension $ProposalsViewStateCopyWith on ProposalsViewState {
  /// Returns a callable class that can be used as follows: `instanceOfProposalsViewState.copyWith(...)` or like so:`instanceOfProposalsViewState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ProposalsViewStateCWProxy get copyWith =>
      _$ProposalsViewStateCWProxyImpl(this);
}
