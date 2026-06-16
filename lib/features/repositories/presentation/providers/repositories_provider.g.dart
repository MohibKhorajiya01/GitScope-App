// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repositories_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$repositoriesNotifierHash() =>
    r'81b50553e5ae748aa4665d5cc6a63b32e9dc4fa7';

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

abstract class _$RepositoriesNotifier
    extends BuildlessAutoDisposeNotifier<RepositoriesState> {
  late final String login;

  RepositoriesState build(String login);
}

/// See also [RepositoriesNotifier].
@ProviderFor(RepositoriesNotifier)
const repositoriesNotifierProvider = RepositoriesNotifierFamily();

/// See also [RepositoriesNotifier].
class RepositoriesNotifierFamily extends Family<RepositoriesState> {
  /// See also [RepositoriesNotifier].
  const RepositoriesNotifierFamily();

  /// See also [RepositoriesNotifier].
  RepositoriesNotifierProvider call(String login) {
    return RepositoriesNotifierProvider(login);
  }

  @override
  RepositoriesNotifierProvider getProviderOverride(
    covariant RepositoriesNotifierProvider provider,
  ) {
    return call(provider.login);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'repositoriesNotifierProvider';
}

/// See also [RepositoriesNotifier].
class RepositoriesNotifierProvider
    extends
        AutoDisposeNotifierProviderImpl<
          RepositoriesNotifier,
          RepositoriesState
        > {
  /// See also [RepositoriesNotifier].
  RepositoriesNotifierProvider(String login)
    : this._internal(
        () => RepositoriesNotifier()..login = login,
        from: repositoriesNotifierProvider,
        name: r'repositoriesNotifierProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$repositoriesNotifierHash,
        dependencies: RepositoriesNotifierFamily._dependencies,
        allTransitiveDependencies:
            RepositoriesNotifierFamily._allTransitiveDependencies,
        login: login,
      );

  RepositoriesNotifierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.login,
  }) : super.internal();

  final String login;

  @override
  RepositoriesState runNotifierBuild(covariant RepositoriesNotifier notifier) {
    return notifier.build(login);
  }

  @override
  Override overrideWith(RepositoriesNotifier Function() create) {
    return ProviderOverride(
      origin: this,
      override: RepositoriesNotifierProvider._internal(
        () => create()..login = login,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        login: login,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<RepositoriesNotifier, RepositoriesState>
  createElement() {
    return _RepositoriesNotifierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RepositoriesNotifierProvider && other.login == login;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, login.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RepositoriesNotifierRef
    on AutoDisposeNotifierProviderRef<RepositoriesState> {
  /// The parameter `login` of this provider.
  String get login;
}

class _RepositoriesNotifierProviderElement
    extends
        AutoDisposeNotifierProviderElement<
          RepositoriesNotifier,
          RepositoriesState
        >
    with RepositoriesNotifierRef {
  _RepositoriesNotifierProviderElement(super.provider);

  @override
  String get login => (origin as RepositoriesNotifierProvider).login;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
