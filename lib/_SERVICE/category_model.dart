import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart'; // Sørg for at køre `flutter pub run build_runner build` for at generere den nødvendige kode

@JsonSerializable()
class ShopCategory {
  @JsonKey(name: 'category_id')
  String categoryId;
  @JsonKey(name: 'is_removed')
  String isRemoved;
  String? tag; // Kan være null
  @JsonKey(name: 'parent_id')
  String parentId;
  @JsonKey(name: 'in_menu')
  String inMenu;
  @JsonKey(name: 'is_online')
  String isOnline;
  @JsonKey(name: 'is_front')
  String isFront;
  String name;
  @JsonKey(name: 'no_index')
  String noIndex;
  @JsonKey(name: 'no_internal_search')
  String noInternalSearch;
  @JsonKey(name: 'description_a')
  String descriptionA;
  @JsonKey(name: 'description_b')
  String descriptionB;
  @JsonKey(name: 'meta_title')
  String metaTitle;
  @JsonKey(name: 'meta_description')
  String metaDescription;
  String? search; // Kan være null
  @JsonKey(name: 'rewrite_url')
  String rewriteUrl;
  @JsonKey(name: 'empty_redir')
  String? emptyRedir; // Kan være null
  @JsonKey(name: 'canonical_id')
  String? canonicalId; // Kan være null
  @JsonKey(name: 'sort_order')
  String sortOrder;
  String meta;
  String weight;
  @JsonKey(name: 'json_data')
  String? jsonData; // Kan være null
  @JsonKey(name: 'last_modified')
  String lastModified;
  String url;
  List<dynamic> images; // Kan indeholde en liste (kan være tom)
  @JsonKey(name: 'extension_data')
  List<ExtensionData> extensionData;

  ShopCategory({
    required this.categoryId,
    required this.isRemoved,
    this.tag,
    required this.parentId,
    required this.inMenu,
    required this.isOnline,
    required this.isFront,
    required this.name,
    required this.noIndex,
    required this.noInternalSearch,
    required this.descriptionA,
    required this.descriptionB,
    required this.metaTitle,
    required this.metaDescription,
    this.search,
    required this.rewriteUrl,
    this.emptyRedir,
    this.canonicalId,
    required this.sortOrder,
    required this.meta,
    required this.weight,
    this.jsonData,
    required this.lastModified,
    required this.url,
    required this.images,
    required this.extensionData,
  });

  // Factory constructor til at lave objektet fra JSON
  factory ShopCategory.fromJson(Map<String, dynamic> json) => _$ShopCategoryFromJson(json);

  // Metode til at konvertere objektet til JSON
  Map<String, dynamic> toJson() => _$ShopCategoryToJson(this);
}

@JsonSerializable()
class ExtensionData {
  String title;
  String type;
  String id;
  dynamic value;

  ExtensionData({required this.title, required this.type, required this.id, required this.value});

  // Factory constructor til at lave objektet fra JSON
  factory ExtensionData.fromJson(Map<String, dynamic> json) => _$ExtensionDataFromJson(json);

  // Metode til at konvertere objektet til JSON
  Map<String, dynamic> toJson() => _$ExtensionDataToJson(this);
}
