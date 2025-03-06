// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopCategory _$ShopCategoryFromJson(Map<String, dynamic> json) => ShopCategory(
  categoryId: json['category_id'] as String,
  isRemoved: json['is_removed'] as String,
  tag: json['tag'] as String?,
  parentId: json['parent_id'] as String,
  inMenu: json['in_menu'] as String,
  isOnline: json['is_online'] as String,
  isFront: json['is_front'] as String,
  name: json['name'] as String,
  noIndex: json['no_index'] as String,
  noInternalSearch: json['no_internal_search'] as String,
  descriptionA: json['description_a'] as String,
  descriptionB: json['description_b'] as String,
  metaTitle: json['meta_title'] as String,
  metaDescription: json['meta_description'] as String,
  search: json['search'] as String?,
  rewriteUrl: json['rewrite_url'] as String,
  emptyRedir: json['empty_redir'] as String?,
  canonicalId: json['canonical_id'] as String?,
  sortOrder: json['sort_order'] as String,
  meta: json['meta'] as String,
  weight: json['weight'] as String,
  jsonData: json['json_data'] as String?,
  lastModified: json['last_modified'] as String,
  url: json['url'] as String,
  images: json['images'] as List<dynamic>,
  extensionData:
      (json['extension_data'] as List<dynamic>)
          .map((e) => ExtensionData.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$ShopCategoryToJson(ShopCategory instance) =>
    <String, dynamic>{
      'category_id': instance.categoryId,
      'is_removed': instance.isRemoved,
      'tag': instance.tag,
      'parent_id': instance.parentId,
      'in_menu': instance.inMenu,
      'is_online': instance.isOnline,
      'is_front': instance.isFront,
      'name': instance.name,
      'no_index': instance.noIndex,
      'no_internal_search': instance.noInternalSearch,
      'description_a': instance.descriptionA,
      'description_b': instance.descriptionB,
      'meta_title': instance.metaTitle,
      'meta_description': instance.metaDescription,
      'search': instance.search,
      'rewrite_url': instance.rewriteUrl,
      'empty_redir': instance.emptyRedir,
      'canonical_id': instance.canonicalId,
      'sort_order': instance.sortOrder,
      'meta': instance.meta,
      'weight': instance.weight,
      'json_data': instance.jsonData,
      'last_modified': instance.lastModified,
      'url': instance.url,
      'images': instance.images,
      'extension_data': instance.extensionData,
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
