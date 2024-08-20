// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$characterHash() => r'226e6ec0f42b1c24bc0f03573f865b916de2b446';

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

/// See also [character].
@ProviderFor(character)
const characterProvider = CharacterFamily();

/// See also [character].
class CharacterFamily extends Family<AsyncValue<Character?>> {
  /// See also [character].
  const CharacterFamily();

  /// See also [character].
  CharacterProvider call(
    String characterId,
  ) {
    return CharacterProvider(
      characterId,
    );
  }

  @override
  CharacterProvider getProviderOverride(
    covariant CharacterProvider provider,
  ) {
    return call(
      provider.characterId,
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
  String? get name => r'characterProvider';
}

/// See also [character].
class CharacterProvider extends AutoDisposeStreamProvider<Character?> {
  /// See also [character].
  CharacterProvider(
    String characterId,
  ) : this._internal(
          (ref) => character(
            ref as CharacterRef,
            characterId,
          ),
          from: characterProvider,
          name: r'characterProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$characterHash,
          dependencies: CharacterFamily._dependencies,
          allTransitiveDependencies: CharacterFamily._allTransitiveDependencies,
          characterId: characterId,
        );

  CharacterProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.characterId,
  }) : super.internal();

  final String characterId;

  @override
  Override overrideWith(
    Stream<Character?> Function(CharacterRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CharacterProvider._internal(
        (ref) => create(ref as CharacterRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        characterId: characterId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<Character?> createElement() {
    return _CharacterProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CharacterProvider && other.characterId == characterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, characterId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CharacterRef on AutoDisposeStreamProviderRef<Character?> {
  /// The parameter `characterId` of this provider.
  String get characterId;
}

class _CharacterProviderElement
    extends AutoDisposeStreamProviderElement<Character?> with CharacterRef {
  _CharacterProviderElement(super.provider);

  @override
  String get characterId => (origin as CharacterProvider).characterId;
}

String _$observeCharacterPictureUrlHash() =>
    r'92b712ac6e6ebae297c74b4cfaf5e9edceff85f7';

/// See also [observeCharacterPictureUrl].
@ProviderFor(observeCharacterPictureUrl)
const observeCharacterPictureUrlProvider = ObserveCharacterPictureUrlFamily();

/// See also [observeCharacterPictureUrl].
class ObserveCharacterPictureUrlFamily extends Family<AsyncValue<String?>> {
  /// See also [observeCharacterPictureUrl].
  const ObserveCharacterPictureUrlFamily();

  /// See also [observeCharacterPictureUrl].
  ObserveCharacterPictureUrlProvider call(
    String characterId,
  ) {
    return ObserveCharacterPictureUrlProvider(
      characterId,
    );
  }

  @override
  ObserveCharacterPictureUrlProvider getProviderOverride(
    covariant ObserveCharacterPictureUrlProvider provider,
  ) {
    return call(
      provider.characterId,
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
  String? get name => r'observeCharacterPictureUrlProvider';
}

/// See also [observeCharacterPictureUrl].
class ObserveCharacterPictureUrlProvider
    extends AutoDisposeStreamProvider<String?> {
  /// See also [observeCharacterPictureUrl].
  ObserveCharacterPictureUrlProvider(
    String characterId,
  ) : this._internal(
          (ref) => observeCharacterPictureUrl(
            ref as ObserveCharacterPictureUrlRef,
            characterId,
          ),
          from: observeCharacterPictureUrlProvider,
          name: r'observeCharacterPictureUrlProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$observeCharacterPictureUrlHash,
          dependencies: ObserveCharacterPictureUrlFamily._dependencies,
          allTransitiveDependencies:
              ObserveCharacterPictureUrlFamily._allTransitiveDependencies,
          characterId: characterId,
        );

  ObserveCharacterPictureUrlProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.characterId,
  }) : super.internal();

  final String characterId;

  @override
  Override overrideWith(
    Stream<String?> Function(ObserveCharacterPictureUrlRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ObserveCharacterPictureUrlProvider._internal(
        (ref) => create(ref as ObserveCharacterPictureUrlRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        characterId: characterId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<String?> createElement() {
    return _ObserveCharacterPictureUrlProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ObserveCharacterPictureUrlProvider &&
        other.characterId == characterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, characterId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ObserveCharacterPictureUrlRef on AutoDisposeStreamProviderRef<String?> {
  /// The parameter `characterId` of this provider.
  String get characterId;
}

class _ObserveCharacterPictureUrlProviderElement
    extends AutoDisposeStreamProviderElement<String?>
    with ObserveCharacterPictureUrlRef {
  _ObserveCharacterPictureUrlProviderElement(super.provider);

  @override
  String get characterId =>
      (origin as ObserveCharacterPictureUrlProvider).characterId;
}

String _$characterPictureStateHash() =>
    r'744e7c94725f67cafd90e5979b2a02a312fa0b8b';

/// See also [characterPictureState].
@ProviderFor(characterPictureState)
const characterPictureStateProvider = CharacterPictureStateFamily();

/// See also [characterPictureState].
class CharacterPictureStateFamily extends Family<AppGeneratedPictureState> {
  /// See also [characterPictureState].
  const CharacterPictureStateFamily();

  /// See also [characterPictureState].
  CharacterPictureStateProvider call(
    String characterId,
  ) {
    return CharacterPictureStateProvider(
      characterId,
    );
  }

  @override
  CharacterPictureStateProvider getProviderOverride(
    covariant CharacterPictureStateProvider provider,
  ) {
    return call(
      provider.characterId,
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
  String? get name => r'characterPictureStateProvider';
}

/// See also [characterPictureState].
class CharacterPictureStateProvider
    extends AutoDisposeProvider<AppGeneratedPictureState> {
  /// See also [characterPictureState].
  CharacterPictureStateProvider(
    String characterId,
  ) : this._internal(
          (ref) => characterPictureState(
            ref as CharacterPictureStateRef,
            characterId,
          ),
          from: characterPictureStateProvider,
          name: r'characterPictureStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$characterPictureStateHash,
          dependencies: CharacterPictureStateFamily._dependencies,
          allTransitiveDependencies:
              CharacterPictureStateFamily._allTransitiveDependencies,
          characterId: characterId,
        );

  CharacterPictureStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.characterId,
  }) : super.internal();

  final String characterId;

  @override
  Override overrideWith(
    AppGeneratedPictureState Function(CharacterPictureStateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CharacterPictureStateProvider._internal(
        (ref) => create(ref as CharacterPictureStateRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        characterId: characterId,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<AppGeneratedPictureState> createElement() {
    return _CharacterPictureStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CharacterPictureStateProvider &&
        other.characterId == characterId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, characterId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CharacterPictureStateRef
    on AutoDisposeProviderRef<AppGeneratedPictureState> {
  /// The parameter `characterId` of this provider.
  String get characterId;
}

class _CharacterPictureStateProviderElement
    extends AutoDisposeProviderElement<AppGeneratedPictureState>
    with CharacterPictureStateRef {
  _CharacterPictureStateProviderElement(super.provider);

  @override
  String get characterId =>
      (origin as CharacterPictureStateProvider).characterId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
