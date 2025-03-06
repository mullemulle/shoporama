// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shoporama.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shoporamaServiceHash() => r'4db41519f558af3c7087c8f3392d8073a5fed9f8';

/// See also [shoporamaService].
@ProviderFor(shoporamaService)
final shoporamaServiceProvider = Provider<ShoporamaService>.internal(
  shoporamaService,
  name: r'shoporamaServiceProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$shoporamaServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ShoporamaServiceRef = ProviderRef<ShoporamaService>;
String _$fetchProductsHash() => r'86ef509c88642a3c5857064f7c4d0a0e29c69758';

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

/// See also [fetchProducts].
@ProviderFor(fetchProducts)
const fetchProductsProvider = FetchProductsFamily();

/// See also [fetchProducts].
class FetchProductsFamily extends Family<AsyncValue<ProductResponse?>> {
  /// See also [fetchProducts].
  const FetchProductsFamily();

  /// See also [fetchProducts].
  FetchProductsProvider call({
    required int? supplierId,
    int? offset,
    int? limit,
  }) {
    return FetchProductsProvider(
      supplierId: supplierId,
      offset: offset,
      limit: limit,
    );
  }

  @override
  FetchProductsProvider getProviderOverride(
    covariant FetchProductsProvider provider,
  ) {
    return call(
      supplierId: provider.supplierId,
      offset: provider.offset,
      limit: provider.limit,
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
  String? get name => r'fetchProductsProvider';
}

/// See also [fetchProducts].
class FetchProductsProvider extends FutureProvider<ProductResponse?> {
  /// See also [fetchProducts].
  FetchProductsProvider({required int? supplierId, int? offset, int? limit})
    : this._internal(
        (ref) => fetchProducts(
          ref as FetchProductsRef,
          supplierId: supplierId,
          offset: offset,
          limit: limit,
        ),
        from: fetchProductsProvider,
        name: r'fetchProductsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$fetchProductsHash,
        dependencies: FetchProductsFamily._dependencies,
        allTransitiveDependencies:
            FetchProductsFamily._allTransitiveDependencies,
        supplierId: supplierId,
        offset: offset,
        limit: limit,
      );

  FetchProductsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.supplierId,
    required this.offset,
    required this.limit,
  }) : super.internal();

  final int? supplierId;
  final int? offset;
  final int? limit;

  @override
  Override overrideWith(
    FutureOr<ProductResponse?> Function(FetchProductsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchProductsProvider._internal(
        (ref) => create(ref as FetchProductsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        supplierId: supplierId,
        offset: offset,
        limit: limit,
      ),
    );
  }

  @override
  FutureProviderElement<ProductResponse?> createElement() {
    return _FetchProductsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchProductsProvider &&
        other.supplierId == supplierId &&
        other.offset == offset &&
        other.limit == limit;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, supplierId.hashCode);
    hash = _SystemHash.combine(hash, offset.hashCode);
    hash = _SystemHash.combine(hash, limit.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchProductsRef on FutureProviderRef<ProductResponse?> {
  /// The parameter `supplierId` of this provider.
  int? get supplierId;

  /// The parameter `offset` of this provider.
  int? get offset;

  /// The parameter `limit` of this provider.
  int? get limit;
}

class _FetchProductsProviderElement
    extends FutureProviderElement<ProductResponse?>
    with FetchProductsRef {
  _FetchProductsProviderElement(super.provider);

  @override
  int? get supplierId => (origin as FetchProductsProvider).supplierId;
  @override
  int? get offset => (origin as FetchProductsProvider).offset;
  @override
  int? get limit => (origin as FetchProductsProvider).limit;
}

String _$fetchSupplierHash() => r'f2ba8d251684052c4a80e24888b4025166b53767';

/// See also [fetchSupplier].
@ProviderFor(fetchSupplier)
const fetchSupplierProvider = FetchSupplierFamily();

/// See also [fetchSupplier].
class FetchSupplierFamily extends Family<AsyncValue<Supplier?>> {
  /// See also [fetchSupplier].
  const FetchSupplierFamily();

  /// See also [fetchSupplier].
  FetchSupplierProvider call({required int supplierId}) {
    return FetchSupplierProvider(supplierId: supplierId);
  }

  @override
  FetchSupplierProvider getProviderOverride(
    covariant FetchSupplierProvider provider,
  ) {
    return call(supplierId: provider.supplierId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'fetchSupplierProvider';
}

/// See also [fetchSupplier].
class FetchSupplierProvider extends FutureProvider<Supplier?> {
  /// See also [fetchSupplier].
  FetchSupplierProvider({required int supplierId})
    : this._internal(
        (ref) => fetchSupplier(ref as FetchSupplierRef, supplierId: supplierId),
        from: fetchSupplierProvider,
        name: r'fetchSupplierProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$fetchSupplierHash,
        dependencies: FetchSupplierFamily._dependencies,
        allTransitiveDependencies:
            FetchSupplierFamily._allTransitiveDependencies,
        supplierId: supplierId,
      );

  FetchSupplierProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.supplierId,
  }) : super.internal();

  final int supplierId;

  @override
  Override overrideWith(
    FutureOr<Supplier?> Function(FetchSupplierRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchSupplierProvider._internal(
        (ref) => create(ref as FetchSupplierRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        supplierId: supplierId,
      ),
    );
  }

  @override
  FutureProviderElement<Supplier?> createElement() {
    return _FetchSupplierProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchSupplierProvider && other.supplierId == supplierId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, supplierId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchSupplierRef on FutureProviderRef<Supplier?> {
  /// The parameter `supplierId` of this provider.
  int get supplierId;
}

class _FetchSupplierProviderElement extends FutureProviderElement<Supplier?>
    with FetchSupplierRef {
  _FetchSupplierProviderElement(super.provider);

  @override
  int get supplierId => (origin as FetchSupplierProvider).supplierId;
}

String _$fetchCategoriesHash() => r'6db34c7c98916498c591a72771a0795aabe63884';

/// See also [fetchCategories].
@ProviderFor(fetchCategories)
final fetchCategoriesProvider = FutureProvider<List<ShopCategory>?>.internal(
  fetchCategories,
  name: r'fetchCategoriesProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$fetchCategoriesHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FetchCategoriesRef = FutureProviderRef<List<ShopCategory>?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
