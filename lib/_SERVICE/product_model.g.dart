// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Paging _$PagingFromJson(Map<String, dynamic> json) => Paging(
  offset: (json['offset'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
  count: (json['count'] as num).toInt(),
  total: (json['total'] as num).toInt(),
);

Map<String, dynamic> _$PagingToJson(Paging instance) => <String, dynamic>{
  'offset': instance.offset,
  'limit': instance.limit,
  'count': instance.count,
  'total': instance.total,
};

ImageData _$ImageDataFromJson(Map<String, dynamic> json) => ImageData(
  imageId: json['image_id'] as String?,
  weight: json['weight'] as String,
  variantName: json['variant_name'] as String?,
  description: json['description'] as String?,
  url: json['url'] as String,
);

Map<String, dynamic> _$ImageDataToJson(ImageData instance) => <String, dynamic>{
  'image_id': instance.imageId,
  'weight': instance.weight,
  'variant_name': instance.variantName,
  'description': instance.description,
  'url': instance.url,
};

ExtensionData _$ExtensionDataFromJson(Map<String, dynamic> json) =>
    ExtensionData(
      title: json['title'] as String,
      type: json['type'] as String,
      id: json['id'] as String,
      value: json['value'],
    );

Map<String, dynamic> _$ExtensionDataToJson(ExtensionData instance) =>
    <String, dynamic>{
      'title': instance.title,
      'type': instance.type,
      'id': instance.id,
      'value': instance.value,
    };

Product _$ProductFromJson(Map<String, dynamic> json) => Product(
  productId: (json['product_id'] as num?)?.toInt(),
  ownId: json['own_id'] as String?,
  secOwnId: json['sec_own_id'] as String?,
  gtin: json['gtin'] as String?,
  mpn: json['mpn'] as String?,
  profileId: (json['profile_id'] as num?)?.toInt(),
  supplierId: const IntOrStringConverter().fromJson(json['supplier_id']),
  manufacturerId: (json['manufacturer_id'] as num?)?.toInt(),
  safetyProfileId: (json['safety_profile_id'] as num?)?.toInt(),
  brandId: (json['brand_id'] as num?)?.toInt(),
  mainCategoryId: json['main_category_id'] as String?,
  created: json['created'] as String?,
  isOnline: (json['is_online'] as num).toInt(),
  onlineSince: json['online_since'] as String?,
  noIndex: (json['no_index'] as num?)?.toInt(),
  removedOn: json['removed_on'] as String?,
  rewriteUrl: json['rewrite_url'] as String?,
  name: json['name'] as String,
  listDescription: json['list_description'] as String?,
  description: json['description'] as String?,
  vat: (json['vat'] as num?)?.toDouble(),
  price: (json['price'] as num?)?.toDouble(),
  salePrice: (json['sale_price'] as num?)?.toDouble(),
  purchasePrice: (json['purchase_price'] as num?)?.toDouble(),
  location: json['location'] as String?,
  bulkDiscountOver: (json['bulk_discount_over'] as num?)?.toInt(),
  bulkDiscount: (json['bulk_discount'] as num?)?.toDouble(),
  discountIntervals: json['discountIntervals'] as List<dynamic>?,
  shipping: (json['shipping'] as num?)?.toDouble(),
  shippingWeight: (json['shipping_weight'] as num?)?.toDouble(),
  neverFreeShipping: (json['never_free_shipping'] as num?)?.toInt(),
  deliveryTime: json['delivery_time'] as String?,
  deliveryTimeNotInStock: json['delivery_time_not_in_stock'] as String?,
  allowNegativeStock: (json['allow_negative_stock'] as num?)?.toInt(),
  tariffCode: json['tariff_code'] as String?,
  weight: (json['weight'] as num?)?.toInt(),
  meta: json['meta'] as String?,
  metaTitle: json['meta_title'] as String?,
  metaDescription: json['meta_description'] as String?,
  search: json['search'] as String?,
  noInternalSearch: (json['no_internal_search'] as num?)?.toInt(),
  canonicalId: (json['canonical_id'] as num?)?.toInt(),
  mailingListIds:
      (json['mailing_list_ids'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
  categories:
      (json['categories'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
  related:
      (json['related'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
  similar:
      (json['similar'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
  bundleData: json['bundle_data'] as List<dynamic>?,
  htmlFields: json['html_fields'] as List<dynamic>?,
  attributes: json['attributes'] as List<dynamic>?,
  stockSettings: json['stock_settings'] as List<dynamic>?,
  productLabels: json['product_labels'] as List<dynamic>?,
  images:
      (json['images'] as List<dynamic>?)
          ?.map((e) => ImageData.fromJson(e as Map<String, dynamic>))
          .toList(),
  pdfFiles: json['pdf_files'] as List<dynamic>?,
  extensionData:
      (json['extension_data'] as List<dynamic>?)
          ?.map((e) => ExtensionData.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
  'product_id': instance.productId,
  'own_id': instance.ownId,
  'sec_own_id': instance.secOwnId,
  'gtin': instance.gtin,
  'mpn': instance.mpn,
  'profile_id': instance.profileId,
  'supplier_id': const IntOrStringConverter().toJson(instance.supplierId),
  'manufacturer_id': instance.manufacturerId,
  'safety_profile_id': instance.safetyProfileId,
  'brand_id': instance.brandId,
  'main_category_id': instance.mainCategoryId,
  'created': instance.created,
  'is_online': instance.isOnline,
  'online_since': instance.onlineSince,
  'no_index': instance.noIndex,
  'removed_on': instance.removedOn,
  'rewrite_url': instance.rewriteUrl,
  'name': instance.name,
  'list_description': instance.listDescription,
  'description': instance.description,
  'vat': instance.vat,
  'price': instance.price,
  'sale_price': instance.salePrice,
  'purchase_price': instance.purchasePrice,
  'location': instance.location,
  'bulk_discount_over': instance.bulkDiscountOver,
  'bulk_discount': instance.bulkDiscount,
  'discountIntervals': instance.discountIntervals,
  'shipping': instance.shipping,
  'shipping_weight': instance.shippingWeight,
  'never_free_shipping': instance.neverFreeShipping,
  'delivery_time': instance.deliveryTime,
  'delivery_time_not_in_stock': instance.deliveryTimeNotInStock,
  'allow_negative_stock': instance.allowNegativeStock,
  'tariff_code': instance.tariffCode,
  'weight': instance.weight,
  'meta': instance.meta,
  'meta_title': instance.metaTitle,
  'meta_description': instance.metaDescription,
  'search': instance.search,
  'no_internal_search': instance.noInternalSearch,
  'canonical_id': instance.canonicalId,
  'mailing_list_ids': instance.mailingListIds,
  'categories': instance.categories,
  'related': instance.related,
  'similar': instance.similar,
  'bundle_data': instance.bundleData,
  'html_fields': instance.htmlFields,
  'attributes': instance.attributes,
  'stock_settings': instance.stockSettings,
  'product_labels': instance.productLabels,
  'images': instance.images,
  'pdf_files': instance.pdfFiles,
  'extension_data': instance.extensionData,
};

ProductResponse _$ProductResponseFromJson(Map<String, dynamic> json) =>
    ProductResponse(
      paging: Paging.fromJson(json['paging'] as Map<String, dynamic>),
      products:
          (json['products'] as List<dynamic>)
              .map((e) => Product.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$ProductResponseToJson(ProductResponse instance) =>
    <String, dynamic>{'paging': instance.paging, 'products': instance.products};
