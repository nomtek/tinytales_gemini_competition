// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$listenToAuthStateChangeHash() =>
    r'47325b90cb608f6f3cd76ef7f76e0e27aa7aec48';

/// See also [listenToAuthStateChange].
@ProviderFor(listenToAuthStateChange)
final listenToAuthStateChangeProvider =
    Provider<Raw<ValueNotifier<bool?>>>.internal(
  listenToAuthStateChange,
  name: r'listenToAuthStateChangeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$listenToAuthStateChangeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ListenToAuthStateChangeRef = ProviderRef<Raw<ValueNotifier<bool?>>>;
String _$isLoggedInHash() => r'7c4416655d85ed57d5ef0473a2aeafa4415cf6ad';

/// See also [isLoggedIn].
@ProviderFor(isLoggedIn)
final isLoggedInProvider = Provider<bool>.internal(
  isLoggedIn,
  name: r'isLoggedInProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isLoggedInHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsLoggedInRef = ProviderRef<bool>;
String _$userStreamHash() => r'f0a7a899b75d7231dbb9c824238c254bacc31a53';

/// null if the user is not logged in or we don't know yet
///
/// Copied from [userStream].
@ProviderFor(userStream)
final userStreamProvider = StreamProvider<User?>.internal(
  userStream,
  name: r'userStreamProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userStreamHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserStreamRef = StreamProviderRef<User?>;
String _$userIdHash() => r'b5cd73234f98d809c5a87e9ef51a9e7e730567cf';

/// See also [userId].
@ProviderFor(userId)
final userIdProvider = Provider<String?>.internal(
  userId,
  name: r'userIdProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$userIdHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef UserIdRef = ProviderRef<String?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
