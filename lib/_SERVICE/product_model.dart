import 'package:json_annotation/json_annotation.dart';

part 'product_model.g.dart';

@JsonSerializable()
class Paging {
  final int offset;
  final int limit;
  final int count;
  final int total;

  Paging({required this.offset, required this.limit, required this.count, required this.total});

  factory Paging.fromJson(Map<String, dynamic> json) => _$PagingFromJson(json);

  Map<String, dynamic> toJson() => _$PagingToJson(this);
}

@JsonSerializable()
class ImageData {
  @JsonKey(name: 'image_id')
  //@IntOrStringConverter()
  final String? imageId;
  final String weight;
  @JsonKey(name: 'variant_name')
  final String? variantName;
  final String? description;
  final String url;

  ImageData({required this.imageId, required this.weight, this.variantName, this.description, required this.url});

  factory ImageData.fromJson(Map<String, dynamic> json) => _$ImageDataFromJson(json);

  Map<String, dynamic> toJson() => _$ImageDataToJson(this);
}

@JsonSerializable()
class ExtensionData {
  final String title;
  final String type;
  final String id;
  final dynamic value;

  ExtensionData({required this.title, required this.type, required this.id, required this.value});

  factory ExtensionData.fromJson(Map<String, dynamic> json) => _$ExtensionDataFromJson(json);

  Map<String, dynamic> toJson() => _$ExtensionDataToJson(this);
}

@JsonSerializable()
class Product {
  @JsonKey(name: 'product_id')
  final int? productId;
  @JsonKey(name: 'own_id')
  final String? ownId;
  @JsonKey(name: 'sec_own_id')
  final String? secOwnId;
  final String? gtin;
  final String? mpn;
  @JsonKey(name: 'profile_id')
  final int? profileId;
  @JsonKey(name: 'supplier_id')
  @IntOrStringConverter()
  final String? supplierId;
  @JsonKey(name: 'manufacturer_id')
  final int? manufacturerId;
  @JsonKey(name: 'safety_profile_id')
  final int? safetyProfileId;
  @JsonKey(name: 'brand_id')
  final int? brandId;
  @JsonKey(name: 'main_category_id')
  final String? mainCategoryId;
  final String? created;
  @JsonKey(name: 'is_online')
  final int isOnline;
  @JsonKey(name: 'online_since')
  final String? onlineSince;
  @JsonKey(name: 'no_index')
  final int? noIndex;
  @JsonKey(name: 'removed_on')
  final String? removedOn;
  @JsonKey(name: 'rewrite_url')
  final String? rewriteUrl;
  final String name;
  @JsonKey(name: 'list_description')
  final String? listDescription;
  final String? description;
  final double? vat;
  final double? price;
  @JsonKey(name: 'sale_price')
  final double? salePrice;
  @JsonKey(name: 'purchase_price')
  final double? purchasePrice;
  final String? location;
  @JsonKey(name: 'bulk_discount_over')
  final int? bulkDiscountOver;
  @JsonKey(name: 'bulk_discount')
  final double? bulkDiscount;
  final List<dynamic>? discountIntervals;
  final double? shipping;
  @JsonKey(name: 'shipping_weight')
  final double? shippingWeight;
  @JsonKey(name: 'never_free_shipping')
  final int? neverFreeShipping;
  @JsonKey(name: 'delivery_time')
  final String? deliveryTime;
  @JsonKey(name: 'delivery_time_not_in_stock')
  final String? deliveryTimeNotInStock;
  @JsonKey(name: 'allow_negative_stock')
  final int? allowNegativeStock;
  @JsonKey(name: 'tariff_code')
  final String? tariffCode;
  final int? weight;
  final String? meta;
  @JsonKey(name: 'meta_title')
  final String? metaTitle;
  @JsonKey(name: 'meta_description')
  final String? metaDescription;
  final String? search;
  @JsonKey(name: 'no_internal_search')
  final int? noInternalSearch;
  @JsonKey(name: 'canonical_id')
  final int? canonicalId;
  @JsonKey(name: 'mailing_list_ids')
  final List<int>? mailingListIds;
  final List<int>? categories;
  final List<int>? related;
  final List<int>? similar;
  @JsonKey(name: 'bundle_data')
  final List<dynamic>? bundleData;
  @JsonKey(name: 'html_fields')
  final List<dynamic>? htmlFields;
  final List<dynamic>? attributes;
  @JsonKey(name: 'stock_settings')
  final List<dynamic>? stockSettings;
  @JsonKey(name: 'product_labels')
  final List<dynamic>? productLabels;
  final List<ImageData>? images;
  @JsonKey(name: 'pdf_files')
  final List<dynamic>? pdfFiles;
  @JsonKey(name: 'extension_data')
  final List<ExtensionData>? extensionData;

  Product({
    this.productId,
    this.ownId,
    this.secOwnId,
    this.gtin,
    this.mpn,
    this.profileId,
    this.supplierId,
    this.manufacturerId,
    this.safetyProfileId,
    this.brandId,
    this.mainCategoryId,
    this.created,
    required this.isOnline,
    this.onlineSince,
    this.noIndex,
    this.removedOn,
    this.rewriteUrl,
    required this.name,
    this.listDescription,
    this.description,
    this.vat,
    this.price,
    this.salePrice,
    this.purchasePrice,
    this.location,
    this.bulkDiscountOver,
    this.bulkDiscount,
    this.discountIntervals,
    this.shipping,
    this.shippingWeight,
    this.neverFreeShipping,
    this.deliveryTime,
    this.deliveryTimeNotInStock,
    this.allowNegativeStock,
    this.tariffCode,
    this.weight,
    this.meta,
    this.metaTitle,
    this.metaDescription,
    this.search,
    this.noInternalSearch,
    this.canonicalId,
    this.mailingListIds,
    this.categories,
    this.related,
    this.similar,
    this.bundleData,
    this.htmlFields,
    this.attributes,
    this.stockSettings,
    this.productLabels,
    this.images,
    this.pdfFiles,
    this.extensionData,
  });

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  Map<String, dynamic> toJson() => _$ProductToJson(this);

  factory Product.fromFormSimple(Map<String, dynamic> defaultValues) {
    final String name = defaultValues['name'] as String;

    final int isOnline =
        defaultValues.containsKey('isOnline')
            ? defaultValues['isOnline'] as bool
                ? 0
                : 1
            : 0;

    // Supplier
    final String supplierId = defaultValues.containsKey('isOnline') ? defaultValues['supplierId'] as String : '';

    final product = Product(name: name, isOnline: isOnline, supplierId: supplierId);
    return product;
  }
}

@JsonSerializable()
class ProductResponse {
  final Paging paging;
  final List<Product> products;

  ProductResponse({required this.paging, required this.products});

  factory ProductResponse.fromJson(Map<String, dynamic> json) => _$ProductResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductResponseToJson(this);
}

class IntOrStringConverter implements JsonConverter<String?, dynamic> {
  const IntOrStringConverter();

  @override
  String? fromJson(dynamic json) {
    if (json == null) {
      return null;
    }
    if (json is int) {
      return json.toString();
    }
    if (json is String) {
      return json;
    }
    return null; // Eller throw en exception, hvis du vil håndtere ukendte typer
  }

  @override
  dynamic toJson(String? object) {
    return object; // Eller konverter tilbage til int, hvis nødvendigt
  }
}
