// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'providers.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$NextAdventureStateCWProxy {
  NextAdventureState loadingState(LoadingState? loadingState);

  NextAdventureState error(NextAdventureError? error);

  NextAdventureState proposals(ProposalsViewState proposals);

  NextAdventureState nextAdventureId(String? nextAdventureId);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NextAdventureState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NextAdventureState(...).copyWith(id: 12, name: "My name")
  /// ````
  NextAdventureState call({
    LoadingState? loadingState,
    NextAdventureError? error,
    ProposalsViewState? proposals,
    String? nextAdventureId,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfNextAdventureState.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfNextAdventureState.copyWith.fieldName(...)`
class _$NextAdventureStateCWProxyImpl implements _$NextAdventureStateCWProxy {
  const _$NextAdventureStateCWProxyImpl(this._value);

  final NextAdventureState _value;

  @override
  NextAdventureState loadingState(LoadingState? loadingState) =>
      this(loadingState: loadingState);

  @override
  NextAdventureState error(NextAdventureError? error) => this(error: error);

  @override
  NextAdventureState proposals(ProposalsViewState proposals) =>
      this(proposals: proposals);

  @override
  NextAdventureState nextAdventureId(String? nextAdventureId) =>
      this(nextAdventureId: nextAdventureId);

  @override

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `NextAdventureState(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// NextAdventureState(...).copyWith(id: 12, name: "My name")
  /// ````
  NextAdventureState call({
    Object? loadingState = const $CopyWithPlaceholder(),
    Object? error = const $CopyWithPlaceholder(),
    Object? proposals = const $CopyWithPlaceholder(),
    Object? nextAdventureId = const $CopyWithPlaceholder(),
  }) {
    return NextAdventureState(
      loadingState: loadingState == const $CopyWithPlaceholder()
          ? _value.loadingState
          // ignore: cast_nullable_to_non_nullable
          : loadingState as LoadingState?,
      error: error == const $CopyWithPlaceholder()
          ? _value.error
          // ignore: cast_nullable_to_non_nullable
          : error as NextAdventureError?,
      proposals: proposals == const $CopyWithPlaceholder() || proposals == null
          ? _value.proposals
          // ignore: cast_nullable_to_non_nullable
          : proposals as ProposalsViewState,
      nextAdventureId: nextAdventureId == const $CopyWithPlaceholder()
          ? _value.nextAdventureId
          // ignore: cast_nullable_to_non_nullable
          : nextAdventureId as String?,
    );
  }
}

extension $NextAdventureStateCopyWith on NextAdventureState {
  /// Returns a callable class that can be used as follows: `instanceOfNextAdventureState.copyWith(...)` or like so:`instanceOfNextAdventureState.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$NextAdventureStateCWProxy get copyWith =>
      _$NextAdventureStateCWProxyImpl(this);
}

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$storyHash() => r'151e935fd6259fb2ecf0ffacc7dfe3ed00c11eb9';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [story].
@ProviderFor(story)
const storyProvider = StoryFamily();

/// See also [story].
class StoryFamily extends Family<AsyncValue<Story?>> {
  /// See also [story].
  const StoryFamily();

  /// See also [story].
  StoryProvider call(
    String storyId,
  ) {
    return StoryProvider(
      storyId,
    );
  }

  @override
  StoryProvider getProviderOverride(
    covariant StoryProvider provider,
  ) {
    return call(
      provider.storyId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'storyProvider';
}

/// See also [story].
class StoryProvider extends AutoDisposeStreamProvider<Story?> {
  /// See also [story].
  StoryProvider(
    String storyId,
  ) : this._internal(
          (ref) => story(
            ref as StoryRef,
            storyId,
          ),
          from: storyProvider,
          name: r'storyProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$storyHash,
          dependencies: StoryFamily._dependencies,
          allTransitiveDependencies: StoryFamily._allTransitiveDependencies,
          storyId: storyId,
        );

  StoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.storyId,
  }) : super.internal();

  final String storyId;

  @override
  Override overrideWith(
    Stream<Story?> Function(StoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StoryProvider._internal(
        (ref) => create(ref as StoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        storyId: storyId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Story?> createElement() {
    return _StoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StoryProvider && other.storyId == storyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, storyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin StoryRef on AutoDisposeStreamProviderRef<Story?> {
  /// The parameter `storyId` of this provider.
  String get storyId;
}

class _StoryProviderElement extends AutoDisposeStreamProviderElement<Story?>
    with StoryRef {
  _StoryProviderElement(super.provider);

  @override
  String get storyId => (origin as StoryProvider).storyId;
}

String _$storyPdfUrlHash() => r'6f256731d412bafdaf13e59f870575c46970c83e';

/// See also [storyPdfUrl].
@ProviderFor(storyPdfUrl)
const storyPdfUrlProvider = StoryPdfUrlFamily();

/// See also [storyPdfUrl].
class StoryPdfUrlFamily extends Family<String?> {
  /// See also [storyPdfUrl].
  const StoryPdfUrlFamily();

  /// See also [storyPdfUrl].
  StoryPdfUrlProvider call(
    String storyId,
  ) {
    return StoryPdfUrlProvider(
      storyId,
    );
  }

  @override
  StoryPdfUrlProvider getProviderOverride(
    covariant StoryPdfUrlProvider provider,
  ) {
    return call(
      provider.storyId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'storyPdfUrlProvider';
}

/// See also [storyPdfUrl].
class StoryPdfUrlProvider extends AutoDisposeProvider<String?> {
  /// See also [storyPdfUrl].
  StoryPdfUrlProvider(
    String storyId,
  ) : this._internal(
          (ref) => storyPdfUrl(
            ref as StoryPdfUrlRef,
            storyId,
          ),
          from: storyPdfUrlProvider,
          name: r'storyPdfUrlProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$storyPdfUrlHash,
          dependencies: StoryPdfUrlFamily._dependencies,
          allTransitiveDependencies:
              StoryPdfUrlFamily._allTransitiveDependencies,
          storyId: storyId,
        );

  StoryPdfUrlProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.storyId,
  }) : super.internal();

  final String storyId;

  @override
  Override overrideWith(
    String? Function(StoryPdfUrlRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StoryPdfUrlProvider._internal(
        (ref) => create(ref as StoryPdfUrlRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        storyId: storyId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String?> createElement() {
    return _StoryPdfUrlProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StoryPdfUrlProvider && other.storyId == storyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, storyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin StoryPdfUrlRef on AutoDisposeProviderRef<String?> {
  /// The parameter `storyId` of this provider.
  String get storyId;
}

class _StoryPdfUrlProviderElement extends AutoDisposeProviderElement<String?>
    with StoryPdfUrlRef {
  _StoryPdfUrlProviderElement(super.provider);

  @override
  String get storyId => (origin as StoryPdfUrlProvider).storyId;
}

String _$isPdfGeneratingHash() => r'e33f7e17685fa2e8f89be2ac67a3dfb1c77d42a3';

/// See also [isPdfGenerating].
@ProviderFor(isPdfGenerating)
const isPdfGeneratingProvider = IsPdfGeneratingFamily();

/// See also [isPdfGenerating].
class IsPdfGeneratingFamily extends Family<bool> {
  /// See also [isPdfGenerating].
  const IsPdfGeneratingFamily();

  /// See also [isPdfGenerating].
  IsPdfGeneratingProvider call(
    String storyId,
  ) {
    return IsPdfGeneratingProvider(
      storyId,
    );
  }

  @override
  IsPdfGeneratingProvider getProviderOverride(
    covariant IsPdfGeneratingProvider provider,
  ) {
    return call(
      provider.storyId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'isPdfGeneratingProvider';
}

/// See also [isPdfGenerating].
class IsPdfGeneratingProvider extends AutoDisposeProvider<bool> {
  /// See also [isPdfGenerating].
  IsPdfGeneratingProvider(
    String storyId,
  ) : this._internal(
          (ref) => isPdfGenerating(
            ref as IsPdfGeneratingRef,
            storyId,
          ),
          from: isPdfGeneratingProvider,
          name: r'isPdfGeneratingProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isPdfGeneratingHash,
          dependencies: IsPdfGeneratingFamily._dependencies,
          allTransitiveDependencies:
              IsPdfGeneratingFamily._allTransitiveDependencies,
          storyId: storyId,
        );

  IsPdfGeneratingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.storyId,
  }) : super.internal();

  final String storyId;

  @override
  Override overrideWith(
    bool Function(IsPdfGeneratingRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: IsPdfGeneratingProvider._internal(
        (ref) => create(ref as IsPdfGeneratingRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        storyId: storyId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _IsPdfGeneratingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsPdfGeneratingProvider && other.storyId == storyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, storyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin IsPdfGeneratingRef on AutoDisposeProviderRef<bool> {
  /// The parameter `storyId` of this provider.
  String get storyId;
}

class _IsPdfGeneratingProviderElement extends AutoDisposeProviderElement<bool>
    with IsPdfGeneratingRef {
  _IsPdfGeneratingProviderElement(super.provider);

  @override
  String get storyId => (origin as IsPdfGeneratingProvider).storyId;
}

String _$storyTitleHash() => r'6dce8804c9e097f0c3832710e7db350ab609cce6';

/// See also [storyTitle].
@ProviderFor(storyTitle)
const storyTitleProvider = StoryTitleFamily();

/// See also [storyTitle].
class StoryTitleFamily extends Family<String> {
  /// See also [storyTitle].
  const StoryTitleFamily();

  /// See also [storyTitle].
  StoryTitleProvider call(
    String storyId,
  ) {
    return StoryTitleProvider(
      storyId,
    );
  }

  @override
  StoryTitleProvider getProviderOverride(
    covariant StoryTitleProvider provider,
  ) {
    return call(
      provider.storyId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'storyTitleProvider';
}

/// See also [storyTitle].
class StoryTitleProvider extends AutoDisposeProvider<String> {
  /// See also [storyTitle].
  StoryTitleProvider(
    String storyId,
  ) : this._internal(
          (ref) => storyTitle(
            ref as StoryTitleRef,
            storyId,
          ),
          from: storyTitleProvider,
          name: r'storyTitleProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$storyTitleHash,
          dependencies: StoryTitleFamily._dependencies,
          allTransitiveDependencies:
              StoryTitleFamily._allTransitiveDependencies,
          storyId: storyId,
        );

  StoryTitleProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.storyId,
  }) : super.internal();

  final String storyId;

  @override
  Override overrideWith(
    String Function(StoryTitleRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StoryTitleProvider._internal(
        (ref) => create(ref as StoryTitleRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        storyId: storyId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _StoryTitleProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StoryTitleProvider && other.storyId == storyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, storyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin StoryTitleRef on AutoDisposeProviderRef<String> {
  /// The parameter `storyId` of this provider.
  String get storyId;
}

class _StoryTitleProviderElement extends AutoDisposeProviderElement<String>
    with StoryTitleRef {
  _StoryTitleProviderElement(super.provider);

  @override
  String get storyId => (origin as StoryTitleProvider).storyId;
}

String _$storyPictureUrlHash() => r'd6ecb4338c287aeea093b2582adc74971e88bcfb';

/// See also [storyPictureUrl].
@ProviderFor(storyPictureUrl)
const storyPictureUrlProvider = StoryPictureUrlFamily();

/// See also [storyPictureUrl].
class StoryPictureUrlFamily extends Family<String> {
  /// See also [storyPictureUrl].
  const StoryPictureUrlFamily();

  /// See also [storyPictureUrl].
  StoryPictureUrlProvider call(
    String storyId,
  ) {
    return StoryPictureUrlProvider(
      storyId,
    );
  }

  @override
  StoryPictureUrlProvider getProviderOverride(
    covariant StoryPictureUrlProvider provider,
  ) {
    return call(
      provider.storyId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'storyPictureUrlProvider';
}

/// See also [storyPictureUrl].
class StoryPictureUrlProvider extends AutoDisposeProvider<String> {
  /// See also [storyPictureUrl].
  StoryPictureUrlProvider(
    String storyId,
  ) : this._internal(
          (ref) => storyPictureUrl(
            ref as StoryPictureUrlRef,
            storyId,
          ),
          from: storyPictureUrlProvider,
          name: r'storyPictureUrlProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$storyPictureUrlHash,
          dependencies: StoryPictureUrlFamily._dependencies,
          allTransitiveDependencies:
              StoryPictureUrlFamily._allTransitiveDependencies,
          storyId: storyId,
        );

  StoryPictureUrlProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.storyId,
  }) : super.internal();

  final String storyId;

  @override
  Override overrideWith(
    String Function(StoryPictureUrlRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StoryPictureUrlProvider._internal(
        (ref) => create(ref as StoryPictureUrlRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        storyId: storyId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _StoryPictureUrlProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StoryPictureUrlProvider && other.storyId == storyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, storyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin StoryPictureUrlRef on AutoDisposeProviderRef<String> {
  /// The parameter `storyId` of this provider.
  String get storyId;
}

class _StoryPictureUrlProviderElement extends AutoDisposeProviderElement<String>
    with StoryPictureUrlRef {
  _StoryPictureUrlProviderElement(super.provider);

  @override
  String get storyId => (origin as StoryPictureUrlProvider).storyId;
}

String _$storyPictureStateHash() => r'824e9f18dd64551a3c77c3fd5dad259cb3aca3b7';

/// See also [storyPictureState].
@ProviderFor(storyPictureState)
const storyPictureStateProvider = StoryPictureStateFamily();

/// See also [storyPictureState].
class StoryPictureStateFamily extends Family<AppGeneratedPictureState> {
  /// See also [storyPictureState].
  const StoryPictureStateFamily();

  /// See also [storyPictureState].
  StoryPictureStateProvider call(
    String storyId,
  ) {
    return StoryPictureStateProvider(
      storyId,
    );
  }

  @override
  StoryPictureStateProvider getProviderOverride(
    covariant StoryPictureStateProvider provider,
  ) {
    return call(
      provider.storyId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'storyPictureStateProvider';
}

/// See also [storyPictureState].
class StoryPictureStateProvider
    extends AutoDisposeProvider<AppGeneratedPictureState> {
  /// See also [storyPictureState].
  StoryPictureStateProvider(
    String storyId,
  ) : this._internal(
          (ref) => storyPictureState(
            ref as StoryPictureStateRef,
            storyId,
          ),
          from: storyPictureStateProvider,
          name: r'storyPictureStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$storyPictureStateHash,
          dependencies: StoryPictureStateFamily._dependencies,
          allTransitiveDependencies:
              StoryPictureStateFamily._allTransitiveDependencies,
          storyId: storyId,
        );

  StoryPictureStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.storyId,
  }) : super.internal();

  final String storyId;

  @override
  Override overrideWith(
    AppGeneratedPictureState Function(StoryPictureStateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StoryPictureStateProvider._internal(
        (ref) => create(ref as StoryPictureStateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        storyId: storyId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<AppGeneratedPictureState> createElement() {
    return _StoryPictureStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StoryPictureStateProvider && other.storyId == storyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, storyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin StoryPictureStateRef on AutoDisposeProviderRef<AppGeneratedPictureState> {
  /// The parameter `storyId` of this provider.
  String get storyId;
}

class _StoryPictureStateProviderElement
    extends AutoDisposeProviderElement<AppGeneratedPictureState>
    with StoryPictureStateRef {
  _StoryPictureStateProviderElement(super.provider);

  @override
  String get storyId => (origin as StoryPictureStateProvider).storyId;
}

String _$storyTextHash() => r'c69c05660eccc90032fc960f006dc78b2750c07e';

/// See also [storyText].
@ProviderFor(storyText)
const storyTextProvider = StoryTextFamily();

/// See also [storyText].
class StoryTextFamily extends Family<String> {
  /// See also [storyText].
  const StoryTextFamily();

  /// See also [storyText].
  StoryTextProvider call(
    String storyId,
  ) {
    return StoryTextProvider(
      storyId,
    );
  }

  @override
  StoryTextProvider getProviderOverride(
    covariant StoryTextProvider provider,
  ) {
    return call(
      provider.storyId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'storyTextProvider';
}

/// See also [storyText].
class StoryTextProvider extends AutoDisposeProvider<String> {
  /// See also [storyText].
  StoryTextProvider(
    String storyId,
  ) : this._internal(
          (ref) => storyText(
            ref as StoryTextRef,
            storyId,
          ),
          from: storyTextProvider,
          name: r'storyTextProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$storyTextHash,
          dependencies: StoryTextFamily._dependencies,
          allTransitiveDependencies: StoryTextFamily._allTransitiveDependencies,
          storyId: storyId,
        );

  StoryTextProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.storyId,
  }) : super.internal();

  final String storyId;

  @override
  Override overrideWith(
    String Function(StoryTextRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StoryTextProvider._internal(
        (ref) => create(ref as StoryTextRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        storyId: storyId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String> createElement() {
    return _StoryTextProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StoryTextProvider && other.storyId == storyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, storyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin StoryTextRef on AutoDisposeProviderRef<String> {
  /// The parameter `storyId` of this provider.
  String get storyId;
}

class _StoryTextProviderElement extends AutoDisposeProviderElement<String>
    with StoryTextRef {
  _StoryTextProviderElement(super.provider);

  @override
  String get storyId => (origin as StoryTextProvider).storyId;
}

String _$storyAudioUrlHash() => r'df92ea49f893f64b54263d1060baca489b1e6673';

/// See also [storyAudioUrl].
@ProviderFor(storyAudioUrl)
const storyAudioUrlProvider = StoryAudioUrlFamily();

/// See also [storyAudioUrl].
class StoryAudioUrlFamily extends Family<String?> {
  /// See also [storyAudioUrl].
  const StoryAudioUrlFamily();

  /// See also [storyAudioUrl].
  StoryAudioUrlProvider call(
    String storyId,
  ) {
    return StoryAudioUrlProvider(
      storyId,
    );
  }

  @override
  StoryAudioUrlProvider getProviderOverride(
    covariant StoryAudioUrlProvider provider,
  ) {
    return call(
      provider.storyId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'storyAudioUrlProvider';
}

/// See also [storyAudioUrl].
class StoryAudioUrlProvider extends AutoDisposeProvider<String?> {
  /// See also [storyAudioUrl].
  StoryAudioUrlProvider(
    String storyId,
  ) : this._internal(
          (ref) => storyAudioUrl(
            ref as StoryAudioUrlRef,
            storyId,
          ),
          from: storyAudioUrlProvider,
          name: r'storyAudioUrlProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$storyAudioUrlHash,
          dependencies: StoryAudioUrlFamily._dependencies,
          allTransitiveDependencies:
              StoryAudioUrlFamily._allTransitiveDependencies,
          storyId: storyId,
        );

  StoryAudioUrlProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.storyId,
  }) : super.internal();

  final String storyId;

  @override
  Override overrideWith(
    String? Function(StoryAudioUrlRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StoryAudioUrlProvider._internal(
        (ref) => create(ref as StoryAudioUrlRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        storyId: storyId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<String?> createElement() {
    return _StoryAudioUrlProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StoryAudioUrlProvider && other.storyId == storyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, storyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin StoryAudioUrlRef on AutoDisposeProviderRef<String?> {
  /// The parameter `storyId` of this provider.
  String get storyId;
}

class _StoryAudioUrlProviderElement extends AutoDisposeProviderElement<String?>
    with StoryAudioUrlRef {
  _StoryAudioUrlProviderElement(super.provider);

  @override
  String get storyId => (origin as StoryAudioUrlProvider).storyId;
}

String _$nextAdventureIdHash() => r'41e672f81f76d2b779210075d9f318ca7ae6f0f8';

/// See also [nextAdventureId].
@ProviderFor(nextAdventureId)
final nextAdventureIdProvider = AutoDisposeProvider<String?>.internal(
  nextAdventureId,
  name: r'nextAdventureIdProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$nextAdventureIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef NextAdventureIdRef = AutoDisposeProviderRef<String?>;
String _$generateStoryPdfNotifierHash() =>
    r'968d6451e89c03245e9904c6d6e05df1b9fa8a79';

/// See also [GenerateStoryPdfNotifier].
@ProviderFor(GenerateStoryPdfNotifier)
final generateStoryPdfNotifierProvider = AutoDisposeNotifierProvider<
    GenerateStoryPdfNotifier, GeneratePdfState>.internal(
  GenerateStoryPdfNotifier.new,
  name: r'generateStoryPdfNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$generateStoryPdfNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GenerateStoryPdfNotifier = AutoDisposeNotifier<GeneratePdfState>;
String _$editStoryNotifierHash() => r'c7b809514349b227aacec4f92f03da760821a9f0';

/// See also [EditStoryNotifier].
@ProviderFor(EditStoryNotifier)
final editStoryNotifierProvider =
    AutoDisposeNotifierProvider<EditStoryNotifier, String>.internal(
  EditStoryNotifier.new,
  name: r'editStoryNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$editStoryNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$EditStoryNotifier = AutoDisposeNotifier<String>;
String _$audioGenerationNotifierHash() =>
    r'fc42e57ec70402bbe37c065294b81e0775afab67';

abstract class _$AudioGenerationNotifier
    extends BuildlessAutoDisposeNotifier<AudioGenerationState> {
  late final String storyId;

  AudioGenerationState build(
    String storyId,
  );
}

/// See also [AudioGenerationNotifier].
@ProviderFor(AudioGenerationNotifier)
const audioGenerationNotifierProvider = AudioGenerationNotifierFamily();

/// See also [AudioGenerationNotifier].
class AudioGenerationNotifierFamily extends Family<AudioGenerationState> {
  /// See also [AudioGenerationNotifier].
  const AudioGenerationNotifierFamily();

  /// See also [AudioGenerationNotifier].
  AudioGenerationNotifierProvider call(
    String storyId,
  ) {
    return AudioGenerationNotifierProvider(
      storyId,
    );
  }

  @override
  AudioGenerationNotifierProvider getProviderOverride(
    covariant AudioGenerationNotifierProvider provider,
  ) {
    return call(
      provider.storyId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'audioGenerationNotifierProvider';
}

/// See also [AudioGenerationNotifier].
class AudioGenerationNotifierProvider extends AutoDisposeNotifierProviderImpl<
    AudioGenerationNotifier, AudioGenerationState> {
  /// See also [AudioGenerationNotifier].
  AudioGenerationNotifierProvider(
    String storyId,
  ) : this._internal(
          () => AudioGenerationNotifier()..storyId = storyId,
          from: audioGenerationNotifierProvider,
          name: r'audioGenerationNotifierProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$audioGenerationNotifierHash,
          dependencies: AudioGenerationNotifierFamily._dependencies,
          allTransitiveDependencies:
              AudioGenerationNotifierFamily._allTransitiveDependencies,
          storyId: storyId,
        );

  AudioGenerationNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.storyId,
  }) : super.internal();

  final String storyId;

  @override
  AudioGenerationState runNotifierBuild(
    covariant AudioGenerationNotifier notifier,
  ) {
    return notifier.build(
      storyId,
    );
  }

  @override
  Override overrideWith(AudioGenerationNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: AudioGenerationNotifierProvider._internal(
        () => create()..storyId = storyId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        storyId: storyId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<AudioGenerationNotifier,
      AudioGenerationState> createElement() {
    return _AudioGenerationNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AudioGenerationNotifierProvider && other.storyId == storyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, storyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AudioGenerationNotifierRef
    on AutoDisposeNotifierProviderRef<AudioGenerationState> {
  /// The parameter `storyId` of this provider.
  String get storyId;
}

class _AudioGenerationNotifierProviderElement
    extends AutoDisposeNotifierProviderElement<AudioGenerationNotifier,
        AudioGenerationState> with AudioGenerationNotifierRef {
  _AudioGenerationNotifierProviderElement(super.provider);

  @override
  String get storyId => (origin as AudioGenerationNotifierProvider).storyId;
}

String _$audioPlayerVisibilityHash() =>
    r'da50fedce65dec28a48b9a6468a1d6c447a5e118';

abstract class _$AudioPlayerVisibility
    extends BuildlessAutoDisposeNotifier<bool> {
  late final String storyId;

  bool build(
    String storyId,
  );
}

/// See also [AudioPlayerVisibility].
@ProviderFor(AudioPlayerVisibility)
const audioPlayerVisibilityProvider = AudioPlayerVisibilityFamily();

/// See also [AudioPlayerVisibility].
class AudioPlayerVisibilityFamily extends Family<bool> {
  /// See also [AudioPlayerVisibility].
  const AudioPlayerVisibilityFamily();

  /// See also [AudioPlayerVisibility].
  AudioPlayerVisibilityProvider call(
    String storyId,
  ) {
    return AudioPlayerVisibilityProvider(
      storyId,
    );
  }

  @override
  AudioPlayerVisibilityProvider getProviderOverride(
    covariant AudioPlayerVisibilityProvider provider,
  ) {
    return call(
      provider.storyId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'audioPlayerVisibilityProvider';
}

/// See also [AudioPlayerVisibility].
class AudioPlayerVisibilityProvider
    extends AutoDisposeNotifierProviderImpl<AudioPlayerVisibility, bool> {
  /// See also [AudioPlayerVisibility].
  AudioPlayerVisibilityProvider(
    String storyId,
  ) : this._internal(
          () => AudioPlayerVisibility()..storyId = storyId,
          from: audioPlayerVisibilityProvider,
          name: r'audioPlayerVisibilityProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$audioPlayerVisibilityHash,
          dependencies: AudioPlayerVisibilityFamily._dependencies,
          allTransitiveDependencies:
              AudioPlayerVisibilityFamily._allTransitiveDependencies,
          storyId: storyId,
        );

  AudioPlayerVisibilityProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.storyId,
  }) : super.internal();

  final String storyId;

  @override
  bool runNotifierBuild(
    covariant AudioPlayerVisibility notifier,
  ) {
    return notifier.build(
      storyId,
    );
  }

  @override
  Override overrideWith(AudioPlayerVisibility Function() create) {
    return ProviderOverride(
      origin: this,
      override: AudioPlayerVisibilityProvider._internal(
        () => create()..storyId = storyId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        storyId: storyId,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<AudioPlayerVisibility, bool>
      createElement() {
    return _AudioPlayerVisibilityProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AudioPlayerVisibilityProvider && other.storyId == storyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, storyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin AudioPlayerVisibilityRef on AutoDisposeNotifierProviderRef<bool> {
  /// The parameter `storyId` of this provider.
  String get storyId;
}

class _AudioPlayerVisibilityProviderElement
    extends AutoDisposeNotifierProviderElement<AudioPlayerVisibility, bool>
    with AudioPlayerVisibilityRef {
  _AudioPlayerVisibilityProviderElement(super.provider);

  @override
  String get storyId => (origin as AudioPlayerVisibilityProvider).storyId;
}

String _$nextAdventureNotifierHash() =>
    r'ac2040c634af7aac0243ca68253cb8a87ca24325';

/// See also [NextAdventureNotifier].
@ProviderFor(NextAdventureNotifier)
final nextAdventureNotifierProvider = AutoDisposeNotifierProvider<
    NextAdventureNotifier, NextAdventureState>.internal(
  NextAdventureNotifier.new,
  name: r'nextAdventureNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$nextAdventureNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$NextAdventureNotifier = AutoDisposeNotifier<NextAdventureState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
