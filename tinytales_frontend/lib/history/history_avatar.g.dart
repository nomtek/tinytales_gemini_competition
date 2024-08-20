// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_avatar.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$storyPictureUrlHash() => r'6a7cf2863aee606a9ecb4e6605a74e7be27b6d97';

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

/// See also [_storyPictureUrl].
@ProviderFor(_storyPictureUrl)
const _storyPictureUrlProvider = _StoryPictureUrlFamily();

/// See also [_storyPictureUrl].
class _StoryPictureUrlFamily extends Family<AsyncValue<String?>> {
  /// See also [_storyPictureUrl].
  const _StoryPictureUrlFamily();

  /// See also [_storyPictureUrl].
  _StoryPictureUrlProvider call(
    String storyId,
  ) {
    return _StoryPictureUrlProvider(
      storyId,
    );
  }

  @override
  _StoryPictureUrlProvider getProviderOverride(
    covariant _StoryPictureUrlProvider provider,
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
  String? get name => r'_storyPictureUrlProvider';
}

/// See also [_storyPictureUrl].
class _StoryPictureUrlProvider extends AutoDisposeStreamProvider<String?> {
  /// See also [_storyPictureUrl].
  _StoryPictureUrlProvider(
    String storyId,
  ) : this._internal(
          (ref) => _storyPictureUrl(
            ref as _StoryPictureUrlRef,
            storyId,
          ),
          from: _storyPictureUrlProvider,
          name: r'_storyPictureUrlProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$storyPictureUrlHash,
          dependencies: _StoryPictureUrlFamily._dependencies,
          allTransitiveDependencies:
              _StoryPictureUrlFamily._allTransitiveDependencies,
          storyId: storyId,
        );

  _StoryPictureUrlProvider._internal(
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
    Stream<String?> Function(_StoryPictureUrlRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _StoryPictureUrlProvider._internal(
        (ref) => create(ref as _StoryPictureUrlRef),
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
  AutoDisposeStreamProviderElement<String?> createElement() {
    return _StoryPictureUrlProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _StoryPictureUrlProvider && other.storyId == storyId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, storyId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin _StoryPictureUrlRef on AutoDisposeStreamProviderRef<String?> {
  /// The parameter `storyId` of this provider.
  String get storyId;
}

class _StoryPictureUrlProviderElement
    extends AutoDisposeStreamProviderElement<String?> with _StoryPictureUrlRef {
  _StoryPictureUrlProviderElement(super.provider);

  @override
  String get storyId => (origin as _StoryPictureUrlProvider).storyId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
