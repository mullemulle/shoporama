// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Setup _$SetupFromJson(Map<String, dynamic> json) => Setup(
  id: json['id'] as String,
  setupType: $enumDecode(_$SetupTypeEnumMap, json['setupType']),
  setup: json['setup'] as Map<String, dynamic>,
  appKey: json['appKey'] as String?,
  supplierId: (json['supplierId'] as num?)?.toInt(),
  members: (json['members'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$SetupToJson(Setup instance) => <String, dynamic>{
  'id': instance.id,
  'setupType': _$SetupTypeEnumMap[instance.setupType]!,
  'setup': instance.setup,
  'appKey': instance.appKey,
  'supplierId': instance.supplierId,
  'members': instance.members,
};

const _$SetupTypeEnumMap = {
  SetupType.restparti: 'restparti',
  SetupType.shop: 'shop',
};

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$setupServiceHash() => r'af6eb45ce824441059046ddec2893afaf1fd8a7d';

/// See also [setupService].
@ProviderFor(setupService)
final setupServiceProvider = Provider<SetupService>.internal(
  setupService,
  name: r'setupServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$setupServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SetupServiceRef = ProviderRef<SetupService>;
String _$fetchSetupByIdHash() => r'4f37a3bca9fee406d4cda02eda3ece176c152c41';

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

/// See also [fetchSetupById].
@ProviderFor(fetchSetupById)
const fetchSetupByIdProvider = FetchSetupByIdFamily();

/// See also [fetchSetupById].
class FetchSetupByIdFamily extends Family<AsyncValue<Setup?>> {
  /// See also [fetchSetupById].
  const FetchSetupByIdFamily();

  /// See also [fetchSetupById].
  FetchSetupByIdProvider call({required String? uid}) {
    return FetchSetupByIdProvider(uid: uid);
  }

  @override
  FetchSetupByIdProvider getProviderOverride(
    covariant FetchSetupByIdProvider provider,
  ) {
    return call(uid: provider.uid);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchSetupByIdProvider';
}

/// See also [fetchSetupById].
class FetchSetupByIdProvider extends FutureProvider<Setup?> {
  /// See also [fetchSetupById].
  FetchSetupByIdProvider({required String? uid})
    : this._internal(
        (ref) => fetchSetupById(ref as FetchSetupByIdRef, uid: uid),
        from: fetchSetupByIdProvider,
        name: r'fetchSetupByIdProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$fetchSetupByIdHash,
        dependencies: FetchSetupByIdFamily._dependencies,
        allTransitiveDependencies:
            FetchSetupByIdFamily._allTransitiveDependencies,
        uid: uid,
      );

  FetchSetupByIdProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.uid,
  }) : super.internal();

  final String? uid;

  @override
  Override overrideWith(
    FutureOr<Setup?> Function(FetchSetupByIdRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchSetupByIdProvider._internal(
        (ref) => create(ref as FetchSetupByIdRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        uid: uid,
      ),
    );
  }

  @override
  FutureProviderElement<Setup?> createElement() {
    return _FetchSetupByIdProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchSetupByIdProvider && other.uid == uid;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, uid.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchSetupByIdRef on FutureProviderRef<Setup?> {
  /// The parameter `uid` of this provider.
  String? get uid;
}

class _FetchSetupByIdProviderElement extends FutureProviderElement<Setup?>
    with FetchSetupByIdRef {
  _FetchSetupByIdProviderElement(super.provider);

  @override
  String? get uid => (origin as FetchSetupByIdProvider).uid;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
